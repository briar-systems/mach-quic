# mach-quic

Lightweight QUIC transport primitives for Mach.

The packet layer implements the allocation-free wire foundation for QUIC v1 and
v2. It incrementally decodes long and short headers, packet numbers, Version
Negotiation, Retry, every core RFC 9000 frame, and transport parameters. Encoding
uses fixed caller-owned builders and publishes each logical object atomically.

Decoded payloads, tokens, reasons, version lists, and extension parameters are
borrowed views into the input. Connection IDs, reset tokens, path data, and
preferred addresses are copied into bounded values. Callers therefore retain the
input datagram until all borrowed views have been consumed.

Packet headers are decoded after header protection has been removed. The crypto
layer owns header and packet protection, Retry integrity, traffic-key derivation,
key phases, and deterministic key discard.

All decode entry points distinguish incomplete input from malformed input.
Neither a failed nor incomplete operation advances its cursor or publishes its
output. Protocol fields accept the non-minimal varint encodings allowed by RFC
9000. Frame types reject non-minimal encodings as required by the protocol.

## Boundaries

- `wire.varint` owns bounded 62-bit integer encoding.
- `packet` owns invariant and version-specific headers, packet numbers, Version
  Negotiation, Retry, and borrowed packet bodies.
- `frame` owns every core RFC 9000 frame codec. ACK range storage is supplied by
  the caller so decode remains bounded and allocation-free.
- `transport_parameters` owns known parameter validation, peer-role rules,
  defaults, duplicate detection, preferred addresses, and lossless borrowed views
  of unknown extensions.
- `crypto.protection` consumes bounded TLS traffic secrets and owns QUIC-specific
  HKDF labels, AEAD nonces, AES and ChaCha20 header masks, packet protection,
  Retry integrity, key phases, and discard.
- `recovery.ack` owns received-packet ranges and ACK generation.
- `recovery.recovery` owns sent-packet history, RTT, loss detection, probe state,
  and retransmission ownership.
- `congestion` owns NewReno, CUBIC, send allowance, and pacing independently of
  recovery and stream flow-control policy.
- `stream.stream` owns stream creation, ordered byte delivery, independent
  connection and stream flow control, cancellation, and recovery ownership.
- `stream.datagram` owns optional RFC 9221 send and receive queues.
- `path.path` owns network-path identity, validation, migration, per-path
  amplification accounting, and DPLPMTUD policy.
- `connection.core` composes packet protection, handshake, recovery, congestion,
  paths, connection IDs, streams, datagrams, and close into one serialized QUIC
  connection without owning UDP or HTTP semantics.
- `transport` owns the version-neutral application and UDP driver contracts.

HTTP/3 consumes QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer.

## Packet protection contracts

`crypto.protection` is allocation-free and uses fixed caller-owned records and
buffers. QUIC v1 and v2 Initial keys are derived from the original destination
connection ID. TLS supplies the traffic secret and negotiated cipher suite for
0-RTT, Handshake, and 1-RTT. QUIC derives `quic key`, `quic iv`, `quic hp`, and
`quic ku` material locally, with the version 2 labels selected automatically.
The supported suites are AES-128-GCM-SHA-256, AES-256-GCM-SHA-384, and
ChaCha20-Poly1305-SHA-256.

`seal_packet` copies an unprotected header, encrypts the payload with the exact
packet-number nonce, then applies header protection from the ciphertext sample.
`open_packet` removes header protection into caller scratch, reconstructs the
packet number, authenticates the complete ciphertext, and only then publishes
plaintext metadata. Authentication failure returns no packet number or header
length and zeroes the rejected plaintext span. Header scratch is unauthenticated
workspace and must not be consumed unless the operation succeeds. Reserved-bit
violations are reported only after authentication and likewise publish no frame
data.

Managed 1-RTT send and receive state uses `SendKeys` and `ReceiveKeys`. The send
path rejects repeated or decreasing packet numbers before touching output. The
first key update requires handshake confirmation. Later updates additionally
require an acknowledgment for a packet sent in the current phase. Header
protection keys remain unchanged across updates. The receive path keeps current
and prederived next keys, retains one previous generation for reordered packets,
and advances its generation only after successful packet authentication. There
is no caller-held candidate key token that can commit a later generation.
`open_receive_packet` reports the authenticated receive generation and whether it
advanced. The connection calls `respond_to_update` before sending its next packet
or an acknowledgment. That operation accepts only the same generation or exactly
one later generation, which makes response idempotence and consecutive-update
rejection explicit. After publishing an updated-phase packet that acknowledges
the exact triggering packet, the connection calls `confirm_update_response` with
that receive generation and triggering packet number. Until then, a consecutive
authenticated update is rejected without publishing plaintext or receive state.

`destroy`, `destroy_initial`, `destroy_send`, and `destroy_receive` zero all
secret, packet-key, IV, and header-key storage and make later operations fail as
discarded. Direct copies of secret-bearing records are unsupported. Retry tags
use the fixed RFC key and nonce for the selected QUIC version. Their pseudo-packet
workspace is caller-owned and bounded by the encoded Retry packet plus the
original destination connection ID.

## Recovery contracts

Recovery is allocation-free. Callers provide bounded storage for ACK ranges and
sent-packet history in each of the Initial, Handshake, and Application Data packet
number spaces. Exhausted history rejects a packet before publication. Exhausted
ACK range storage evicts the oldest ranges and advances a receive floor so an
evicted packet number can never be accepted again.

`recovery.init` binds the three sent-history buffers and validates the recovery
configuration. `recovery.ack.build` returns an ACK frame, the largest acknowledged
packet number, and a receive generation. A successful packet send is published with
`on_ack_sent` using that generation. A stale completion cannot clear ACK work that
arrived after the frame was built. The saved largest acknowledged value can later
be supplied to `on_ack_packet_acked` to release old receive ranges. ACK scheduling
is independent per packet number space and includes cumulative ECN counts.

Each sent packet carries an opaque owner chosen by the connection. ACK, loss, key
discard, and Retry return terminal owner events. PTO returns a non-owning hint and
never declares the hinted packet lost, because QUIC retransmits information rather
than packets. A zero-valued owner is valid and is distinguished with
`has_probe_owner`.

Loss timers are generation-tagged snapshots. Timeout calls using an obsolete
generation are rejected without changing state. RTT estimates are shared across
the connection while sent history, largest acknowledgments, loss time, and packet
numbers remain independent per space. Discarding Initial or Handshake keys releases
that space and resets PTO backoff. Retry releases all outstanding owners and resets
loss recovery without reusing packet numbers.

## Congestion contracts

Congestion state and bytes in flight are per network path and shared by all packet
number spaces on that path. `congestion.controller` provides NewReno and CUBIC
behind one bounded, allocation-free contract. Recovery remains authoritative for
connection-wide packet history. Each immutable terminal event carries an owner
that pins its exact path until completion. The connection dispatches ACK, loss,
discard, ECN, and persistent-congestion signals to that saved path's controller
and pacer even after migration.

Controller updates are transactional. Unknown events, impossible byte totals,
backward time, and arithmetic overflow leave the controller unchanged. ACKs are
applied packet by packet even when recovery returns them with losses in the same
batch. Loss response is therefore independent of event order and occurs at most
once per recovery epoch. Retry is an explicit signal because it can occur with no
outstanding owners and therefore with an empty event batch.

`controller.set_limited` records application- and flow-control-limited intervals
separately and removes those intervals from CUBIC's epoch clock. The connection
also supplies `growth_permitted` for each recovery batch after determining
whether the sender was using the available congestion window. Admission keeps
the encoded packet size used for congestion accounting separate from the stream
payload bytes used for flow control. A PTO probe can exceed the congestion window
through the explicit probe input. It still passes through the pacer.

`congestion.pacer` uses a token bucket capped at the standard initial congestion
window and a default rate of 1.25 times congestion window divided by smoothed RTT.
ACK-only packets bypass pacing and do not consume pacing budget. Every schedule is
generation tagged. Synchronizing RTT or congestion-window changes and applying a
PMTU reconfiguration preserve the one outstanding send schedule. Publishing or
cancelling settles only that exact token. A successful send is charged only by
`pacer.publish`, so a queued packet that is rebuilt, cancelled, or rejected does
not consume budget.

The connection driver serializes recovery, congestion, and pacing publication for
one path. After a controller or RTT update it calls `pacer.sync` before acting on
any queued pacing timer. Streams retain ownership of connection- and stream-level
flow-control credit. The driver combines that credit with `controller.admit`, then
asks the pacer to schedule the fully encoded packet size. This keeps stream
fairness, congestion blocking, flow-control blocking, PTO exemption, and pacing
as distinct decisions rather than collapsing them into one writable-byte count.

## Path contracts

The path manager is bounded and allocation-free. The caller supplies stable path,
challenge, response, and send-reservation slots. A path is identified by the full
local and peer IP and port pair. IPv6 scope IDs are part of identity. Handles and
all prepared actions carry a source tag, storage index, and generation, so a
released path or reused action slot cannot make a delayed completion valid.

`observe` accepts only an authenticated packet that the receive packet-number
tracker has classified as fresh. Spoofed and duplicate packets publish no path and
grant no amplification credit. Before handshake confirmation, a new peer address
is ignored. A client also ignores packets from a server address it has not first
created with `probe`, including a preferred address. A server creates a candidate
for an authenticated client address, but switches only on the highest-numbered
non-probing packet seen across candidate paths. Reordered traffic therefore cannot
roll migration backward. A port-only peer change on the same local address is
classified as NAT rebinding.

The local `allow_peer_active_migration` policy implements the
`disable_active_migration` transport parameter without disabling NAT rebinding.
The peer's corresponding policy prevents client probing from a new local address,
except for a peer-advertised preferred address. Active migration is client-only,
requires handshake confirmation, and selects only a validated candidate. A path
change reports whether the connection must rotate its destination connection ID,
reset ECN validation, reset congestion and RTT state, and validate the previous
path. Port-only rebinding can explicitly retain congestion and RTT state. Other
changes require fresh state. The driver preflights an unused destination
connection ID through the migration call. A migration that needs rotation remains
blocked and does not change selection until one is available.

Challenge data is supplied by the connection's cryptographic random provider and
must be unpredictable. Outstanding values are unique. Queue, prepare, cancel, and
publish are distinct operations. The validation deadline starts only when the
packet is published and is the configured factor times the larger PTO of the old
and new paths. Path reachability and MTU confirmation have distinct purposes, so
a failed prior-path revalidation invalidates that path while a failed MTU
confirmation leaves address ownership intact. A matching PATH_RESPONSE can arrive
on any path and validates the path on which its PATH_CHALLENGE was sent. A
challenge below 1200 bytes validates only address ownership. MTU validation needs
a padded challenge.

Every received PATH_CHALLENGE queues one copied response on its exact receive path,
including duplicates. The response preparation reports the path's amplification
and MTU bounds. It requests 1200-byte padding when permitted. On the selected path
it also reports `require_non_probing`, which tells the packet builder to compose a
PING or another non-probing frame as required by the forwarding-attack defense.
A server cannot reserve non-probing traffic on a new path until it has received
non-probing traffic there.

Server amplification accounting is independent per unvalidated path. A send first
reserves its fully encoded datagram size. Concurrent reservations cannot exceed
three times authenticated bytes received. Publication charges the path, while
cancellation returns the reservation. Once reserved, the exact path handle and
byte charge remain completion-owned across migration, path failure, and connection
close. Publication therefore remains valid until that send is published or
cancelled, while new reservations observe the current selected path and close
state. Probing work remains usable on a non-selected path. The driver calls frame
publication only after its containing datagram publication succeeds.

Congestion, pacing, ECN validation, and PMTU state belong to the path handle, while
QUIC packet-number spaces and recovery history remain connection-wide. The driver
saves the path handle in each recovery owner and applies late ACK or loss events to
that path even after migration. It applies an `Observation` reset signal before
sending on the newly selected path. Traffic from an old path never grows the new
path's congestion window or updates its RTT. If validation of an unvalidated
selected path fails, the manager returns the last validated fallback or reports
that path connectivity is lost.

DPLPMTUD probes have their own generation-tagged prepare, send, publish, cancel,
and terminal lifecycle. `reserve_mtu_send` binds the exact padded datagram size to
the MTU token. The probe cannot publish to recovery before that datagram publishes,
and it cannot cancel while the datagram is reserved or after it was sent. ACK
raises the path MTU. Repeated probe loss narrows the search bound without treating
ordinary loss as proof. Repeated qualifying large-packet loss falls back to 1200
and asks the driver to reconfigure congestion and pacing. An ICMP Packet Too Big
value is only accepted after the connection authenticates its quoted datagram,
and it remains a bounded search hint. Migration begins at the base MTU on the new
path.

`begin_close` stops new work and discards unowned queues. Prepared challenges,
responses, send reservations, and MTU probes remain completion-owned until they
publish, cancel, or become stale. `finish_close` refuses to invalidate storage
while any owner remains. Failed paths likewise cannot be released or restarted
until their owners drain. Restart increments the path generation before accepting
traffic again.

## Stream contracts

The stream manager is allocation-free. The caller supplies stable stream slots,
per-stream send and receive rings, byte state, and transmission-attempt records.
Initialization rejects any advertised receive window that exceeds those physical
bounds. Local and peer bidirectional and unidirectional stream limits are tracked
independently. An incoming frame that implicitly opens peer streams preflights the
entire range before publishing any stream or consuming flow-control credit.

Handles and transmission attempts carry a source tag, storage index, and
generation. Reusing a slot therefore cannot make an old application or recovery
token valid. `write` copies bytes into a bounded ring and charges connection and
stream credit exactly once when the bytes are accepted. Its result separately
reports connection, stream, and storage backpressure. `prepare` reserves a stable
borrowed range without mutating retransmission state. The connection either calls
`cancel_prepared` or copies the range into a packet and calls `publish`.
Publication transfers the attempt token to recovery. Each ACK or loss is returned
exactly once through `on_terminal`. Probe attempts can duplicate an in-flight
range, and the ring remains pinned until every duplicate terminates.

Receive processing charges only increases in a stream's highest offset. Duplicate
and reordered bytes do not consume connection credit twice. Conflicting overlap,
flow-control violations, stream exhaustion, invalid direction, and inconsistent
final sizes publish no state. `read` copies only the contiguous prefix and reports
the current MAX_DATA and MAX_STREAM_DATA values without changing either.

Delivery and flow-control credit are separate operations. `read` moves bytes into
caller storage and adds them to the stream's outstanding uncredited total; it
returns no window. `credit` returns exactly the bytes whose caller ownership has
ended and rejects any amount above that outstanding total. A peer therefore cannot
be invited to send more because the driver handed bytes over, only because the
caller released them. This is what lets a caller hold delivered bytes — a
QPACK-blocked field section, an application-held DATA payload — without the
receive window being sized against the driver's ring instead of against what the
application actually holds. Cancelling a receive side, acknowledging a reset, and
releasing a stream each reconcile the outstanding total exactly once, so
abandoning a stream returns its window rather than leaking it. RESET_STREAM,
STOP_SENDING, application cancellation, and FIN each retain their distinct
terminal and retransmission ownership. Delayed frames for a released stream are
recognized from the cumulative stream counters and discarded instead of being
misclassified as frames that exceed the advertised stream limit.
Frame-level flow-control entry points implement the RFC stream-creation rules for
MAX_STREAM_DATA and STREAM_DATA_BLOCKED and return the current exact limit for a
driver response without exposing private lookup state.
Consumed receive credit is queued as generation-owned MAX_DATA,
MAX_STREAM_DATA, and MAX_STREAMS work. Cancellation returns the exact maximum to
the queue, loss retransmits it, and only acknowledgment advances the advertised
limit. A zero peer send limit remains zero until authenticated peer transport
parameters are bound exactly once.

The manager is serialized by the connection driver. `begin_close` prevents new
application work and cancels unsent work, while published and prepared attempt
tokens remain valid. Recovery completes published attempts and the packet builder
cancels prepared attempts before `finish_close` can invalidate storage. This is a
two-phase ownership boundary, not a best-effort drain.

## Datagram contracts

RFC 9221 DATAGRAM support is negotiated with `max_datagram_frame_size`. Disabled
mode needs no queue storage. Enabled mode uses caller-owned fixed-capacity send and
receive queues and copies every payload at admission, so application buffers can
be released immediately. Send publication frees a datagram only after its frame
has been copied into a successfully published packet. DATAGRAM frames are never
given retransmission ownership.

The receive queue reports capacity before copying when it is full. The connection
drops that DATAGRAM without closing, as required for an unreliable extension, and
charges the peer's negotiated limit against the complete encoded frame size.
Delivery borrows the queue's copied payload until
`release`. Two-phase close preserves delivered receive payloads and prepared send
payloads until their owners release or cancel them. The DATAGRAM form without a
Length field consumes the remainder of a QUIC packet and must therefore be
selected only for the final frame. The length-bearing form can be composed with
later frames. The connection core always emits the length-bearing form, so
required QUIC padding is never interpreted as application payload.

## Connection core contracts

`connection.core` is allocation-free and serialized. `Core` contains public
protocol state. `Secrets` contains the TLS adapter, packet keys, and secret
plaintext scratch. Every operation takes both records explicitly, so secret-welded
state is never erased through a generic public pointer. Both records and all
caller-supplied storage keep fixed addresses until `finish_close` succeeds.
Every aggregate helper uses pointer-output `initialize` operations. They validate
inclusive pointer ranges, checked array products, and pairwise disjoint output,
configuration, and owned-storage regions before clearing or publishing anything.
Core initialization additionally validates one combined ownership set containing
Core, Secrets, handshake, CID, path, stream, DATAGRAM, and every nested backing
array. A mixed secret/public record is anchored through its first public field
before its complete range is admitted. Reinitializing a live object is rejected
without changing its prior state.

Every refusal is attributed. `InitResult.error` remains the wire-facing transport
error, and `InitResult.reason` names the check that rejected: a capacity relation,
owned storage ranges aliasing each other, the two secret plaintext buffers
aliasing, a borrowed configuration range aliasing storage or a component, the
combined component set aliasing, a malformed provider record, provider secrets
aliasing the plaintext buffers, a state precondition, connection ID or path
identity, local transport parameters, recovery or acknowledgement state, a
refused manager lease, Initial key derivation, path configuration, or the
provider refusing to start. For the ownership reasons `reason_kind` distinguishes
a malformed list, a malformed range, and an overlapping pair, and `reason_first`
and `reason_second` carry the range indices, so a caller that wired one buffer
into two roles is told which two rather than left to bisect its own storage.

Client and server initialization binds the initial connection IDs and path,
derives Initial keys, starts TLS with the exact ALPN, server name, role, QUIC
version, and encoded local transport parameters, and initializes independent
packet-number and recovery spaces. The client validates Version Negotiation and
Retry identity before restarting. Restart releases every prepared and published
owner, resets the required packet-number spaces, rotates the Retry destination
connection ID, preserves the original destination identity, rederives Initial
keys, and restarts TLS with an explicit reason. Stateless server preflight parses
and validates Initial packets before connection allocation. Listener admission
charges connection and peer capacity before token validation or state allocation.
The listener exclusively leases its admission and token managers until close.
`initialize_result` records those leases and its pending storage independently
and returns a generation-tagged `LeaseHandle`. A caller whose enclosing server
transaction is not published can pass that handle to `abort_initialize`.
Initialization abort and normal close attempt both manager lease legs, retain
only refusals, and expose every attempted and retained leg.
`retry_initialization_cleanup` accepts the same handle and touches only retained
legs. Pending storage remains generation stamped until both manager leases have
been released, so neither the Listener nor its storage can be reused early.
Every successful preflight returns an `Acceptance` that owns its admission charge
and, for Retry, its replay reservation through one pending slot. `commit` and
`cancel` attempt both cleanup legs even if one fails. Their cleanup result names
which legs were attempted, their exact subsystem status and error, and which
ownership remains. A retained slot enters cleanup state and cannot be reused.
The socket owner calls `retry_cleanup` with the same generation-tagged
`Acceptance`; retries touch only retained legs, and the slot is released only
after both complete.
The core transactionally leases handshake, CID, path, stream, and DATAGRAM
managers before the first provider callback and releases every acquired lease on
failure. Protocol-side mutations require the matching lease-scoped entry point,
while application stream and DATAGRAM operations retain their documented public
surface. A second connection owner cannot mutate a leased manager.
The peer's sequence-zero stateless reset token is installed separately from later
NEW_CONNECTION_ID tokens and participates in collision and reset matching.

The TLS adapter is a strict event and ownership boundary. The provider receives
contiguous CRYPTO input with its encryption level, offset, and monotonic time. It
publishes bounded CRYPTO output, directional traffic-secret generations, peer
transport parameters, early-data disposition, peer-authentication disposition,
handshake completion, and terminal alerts. Each borrowed event remains provider
owned until `complete_event`. Each prepared CRYPTO range is cancelled or
published, then remains recovery-owned until ACK, loss, key discard, Retry, or
terminal connection drain. `poll` lets an asynchronous provider advance without
inventing network input. Retry and Version Negotiation are explicit provider
restart events rather than implicit fallback behavior.

`connection.handshake.initialize_tls_client` binds a caller-owned
`tls.client.Client` directly to
that adapter. The binding is typed because a TLS client contains welded secret
state and cannot safely pass through an untyped callback context. Its ownership
descriptor includes the entropy provider's public and secret context sizes. The
binding validates the client record, every nested writable TLS buffer, immutable
configuration anchor, persistent TLS secret, and entropy context against the
adapter and connection storage before initialization. It also validates
the exact SNI, single ALPN, QUIC transport-parameter extension, client role, and
QUIC version before starting. Certificate verification uses a separate Unix
verification time, while the optional handshake deadline and all connection
timers remain absolute monotonic nanoseconds. TLS Initial, Handshake, and
Application levels, all three TLS 1.3 suites, both directions, traffic-secret
generations, peer parameters, early-data disposition, authentication, completion,
and alerts map without inference. Provider failures retain their exact raw error
alongside the QUIC transport failure. TLS failures that own a terminal alert are
forwarded through the alert event before teardown.

The binding independently accounts for every accepted ingress and emitted egress
CRYPTO byte. Retry and Version Negotiation clear QUIC CRYPTO ownership, reset the
appropriate offsets, and require `mach-tls` to republish its retained ClientHello
at Initial offset zero. Packet loss and cancellation affect only QUIC's copied
CRYPTO ranges. They never invalidate a borrowed TLS event or cause TLS to
regenerate handshake state.

Authenticated datagrams are opened before frame state is published. Duplicate
packet numbers and unauthenticated paths publish no frame effects. The core
enforces per-path pre-authentication amplification limits, peer transport
parameters, stream and connection flow control, connection-ID limits, path
validation, congestion admission, pacing, DPLPMTUD, and packet-history capacity.
Generated datagrams have one opaque owner. `complete_send` either cancels the
entire preparation or atomically transfers its frame, path, pacing, and recovery
ownership after a full UDP send. RTT, congestion, or migration changes between
generation and completion do not invalidate that exact send transaction. ACK,
loss, Retry, key discard, and teardown settle each owner exactly once.

Timers are generation-tagged and cover idle timeout, closing, draining, recovery,
delayed ACK, and path validation. Graceful close can retransmit CONNECTION_CLOSE until
draining begins. Draining and abortive close reject all further receive and
non-close generation work. Both
paths first drain prepared and recovery-owned work. `finish_close` then destroys
the TLS provider and all packet keys, zeroes secret scratch, and invalidates CID
and path storage.

The core exposes direct transport-shaped `receive`, `generate`, `complete_send`,
`timer`, `on_timeout`, `begin_close`, `close_ready`, and `finish_close`
operations. It also exposes lease-safe path probing, validation work, active
migration, and authenticated Packet Too Big handling without releasing manager
ownership. A UDP or application driver owns the stable `Core` and `Secrets`
records and serializes those calls. This direct split is intentional: the driver's protocol
context is typed for exactly this reason, because a generic public context
cannot erase secret-welded state.

The adapter contract is covered by deterministic simulated providers and the real
`mach-tls` client provider. Client CRYPTO ownership, loss, Retry, Version
Negotiation, malformed-alert forwarding, deadlines, and destruction are exercised
against the exact pinned TLS client. The real `mach-tls` server handshake provider
exists: `connection.handshake.initialize_tls_server`, wrapped by
`connection.tls_server.initialize`, is selected by the production assembly. No
simulated or fallback provider is selected by the production client path.

What has *not* been demonstrated is interoperability against a major
third-party QUIC implementation. This repository ships no interop harness and
no `test/` tree, so every claim here rests on this library talking to itself
over real packet protection with real `mach-tls` on both ends. That is a
genuine end-to-end exercise of the stack and it is not the same thing as
proving wire compatibility with quiche, quic-go or ngtcp2. Issue #3 was closed
on its implementation criteria with that one left explicitly undemonstrated.

## Connection assembly

`connection.assembly` builds a connection and every manager it owns from one
`Config`. The consumer declares a single `Connection`, supplies its identity,
endpoints, limits and an initialized `mach-tls` engine, and calls `init_client`
or `init_server`. It imports nothing from packet, recovery, path or stream: the
record embeds its own storage at the capacities named by the module's public
`val`s, so a caller sizes nothing and there is no per-component storage record to
assemble.

The reason this belongs in the library rather than in each consumer is that the
core requires twelve exact equalities between the encoded local transport
parameters and the manager configurations those parameters describe — the
connection-level and stream-level data limits, the stream counts, the active
connection ID limit, the idle timeout in milliseconds against the same timeout in
nanoseconds, the DATAGRAM frame size, and the migration flag against the path
manager's own. The assembly derives the manager configurations and the encoded
parameters from the same record, so they cannot disagree. `encode_parameters`
exposes those bytes before the connection exists, because the TLS engine has to
carry them as its `quic_transport_parameters` extension; init re-derives them
from the same `Config` rather than accepting a copy.

A refusal reports the stage that rejected, and a refusal from the core carries
the core's own `InitReason` and the offending ownership range indices.

The default assembly profile reserves sixteen stream records and thirty-two
partial-work attempts. Its named HTTP/3 contract admits three local critical
unidirectional streams, three peer critical unidirectional streams, and eight
concurrent request streams. The same `STREAM_CAPACITY`, `STREAM_STRIDE`, and
`STREAM_WINDOW` values size both manager storage and the limits accepted by
`encode_parameters`.

A server passes the complete result from `connection.listener.commit` through
`apply_server_acceptance` before encoding parameters or calling `init_server`.
That single transaction preserves the received Initial destination used for
Initial keys, the original destination carried in the server transport
parameters, the client Initial source used as the peer destination, and the
optional Retry source. Address validation alone does not imply Retry.

The socket owner inventories routing IDs through `routing_snapshot`, `route_at`,
and `route_valid` on the assembly. Entries contain copied ID bytes plus source,
index, sequence, and generation. Publication happens only after driver
initialization. Retirement happens inside the serialized production binding
close callback. The current production core supports one stable sequence-zero
local routing ID. The inventory is deliberately bounded and generation-tagged
so later issuance can extend that contract without exposing CID-manager or
packet internals to the socket multiplexer.

Before that lookup, `connection.listener.classify_datagram` validates the
visible header invariants and copies the destination ID into its result. It
identifies a v1 or v2 Initial admission candidate, an unsupported nonzero
version that may receive Version Negotiation, and traffic that must already
have a route. Short headers take the socket owner's fixed local ID length.
Malformed, truncated, zero-length, and oversized datagrams return
`DATAGRAM_MALFORMED`; the result retains no input pointer. Retry construction is
also copying: `set_retry_source` copies caller bytes into the `listener.ConnectionId`
held by `Request`, so a socket owner never constructs a packet-layer ID or keeps
its source storage alive through `preflight`.

## Scheduling boundary

The division of labour is not symmetric and is worth stating outright.

**This library owns** the connection state machine, packet protection, recovery,
congestion control, path validation, streams, DATAGRAMs, the TLS adapter, and —
through `connection.assembly` — the construction of all of them from one
configuration.

**The consumer owns** the socket, the clock and the pump. It decides when to call
`generate` and where to send the bytes, when a send completed or failed, when a
timer fired, and when a received datagram arrives. It also owns the `Core` and
`Secrets` records themselves, at fixed addresses, with `Secrets` in secret-welded
storage.

`transport.Driver[T]` sits between the two. `transport.binding` supplies the
production `Protocol[Binding]` over a real `Core` and `Secrets`, and the assembly
constructs the driver over it, so an owner pumps datagrams through
`transport.generate`, `complete_send` and `receive_datagram` and reaches streams
and DATAGRAMs through the driver's public handles.

`release_stream` reports `STATUS_BLOCKED` while either stream direction or
recovery-owned work is unsettled. A stale generation remains `STATUS_STALE`, and
an actual transport failure remains `STATUS_ERROR`, so HTTP/3 consumers do not
need stream-manager error constants.

The protocol context is typed rather than an untyped `ptr`, and that is a
correctness requirement rather than a convenience. Every connection operation
takes the public record and the secret-welded `Secrets` together, and mach
refuses to erase a secret-welded pointer to `ptr` — as it refuses `usize` to
`*Secrets` and `*Secrets` to `*u8`. A vtable with an opaque context can therefore
only ever be implemented by a test double whose context holds no secrets, which
is exactly what the tree contained before. `Protocol[T]` carries `context: *T`
and a `context_range` entry, because the same rule stops the driver taking the
context's byte range by casting it; the provider answers for its own memory the
way `handshake.provider_ranges` already does.

Two consequences are worth stating. The driver's own extent is anchored on a
public field rather than cast, since a `Driver[T]` over a secret context inherits
the weld. And the cancellation scope's callback is handed an untyped `ptr` by
`std.sync.cancel`, so it cannot reach the protocol at all: it records the
cancellation and the owner's next call performs the close, on the thread that
owns the protocol. `cancel_connection` stays synchronous, because the owner calls
it with the driver already typed.

## Connection driver contracts

`transport.Driver` is the version-neutral client and server application boundary. HTTP/3 can
open, accept, read, credit, write, finish, cancel, inspect, and release streams through
driver-owned public handles. It can send and receive QUIC DATAGRAM values and
inspect connection state without importing packet, crypto, recovery, congestion,
path, or stream implementation modules. A connection owner adapts the core's
direct serialized operations to its UDP scheduling boundary while retaining
`Secrets` in secret-welded storage.

The driver, its stream and DATAGRAM managers, protocol context, cancellation
scope, output slots, and every buffer referenced by an active output token have
fixed caller-owned addresses. They are not moved or reclaimed before
`finish_close` succeeds. The driver allocates nothing. Every public handle and
generated-datagram token carries a source, index, and generation. Capacity
exhaustion is reported before the protocol generator runs, and invalid, stale,
early, oversized, or backward-time operations publish no ownership change.
The caller assigns a nonzero source unique among simultaneously live drivers.

Incoming UDP payloads are borrowed only for the synchronous `receive_datagram`
callback. `receive_native` maps a completed `std.net.async.types.Packet` into the
same contract, including destination-address and interface metadata. Stream writes
and application DATAGRAM sends copy their inputs before returning. Stream reads
copy into application storage and return no flow-control credit; `credit_stream`
returns it once the caller has finished with those exact bytes. Received application DATAGRAM views remain borrowed
until their exact `DatagramToken` is released.

`generate` writes one protected QUIC datagram into caller storage and transfers
that buffer to its generation-tagged token. The caller may submit it with any
descendant of the connection cancellation scope through `submit_native`, use
another UDP adapter, or cancel it before submission. Exactly one successful
`complete_send`, `complete_native`, or `cancel_send` returns buffer ownership and
settles the protocol core's opaque recovery owner. UDP success is atomic and must
report the full datagram length. Failures, cancellation, and timeout report zero
bytes. Duplicate and foreign completions are stale and cannot settle a reused
slot. Native completion routing additionally verifies the mach-std runtime token,
so a delayed completion cannot target a later generation.

Timers are absolute monotonic deadlines carrying the driver source and protocol
generation. `on_timeout` revalidates both the deadline and generation before
advancing driver time. Early and obsolete observations do not affect later work.
Protocol callbacks are invoked under the connection lock and cannot reenter the
same driver. Same-thread reentry is rejected before lock acquisition. Immutable
driver anchors and lifecycle state are snapshotted around each callback, and
unauthorized callback mutation is restored and reported as a protocol error.
Callbacks must be transactional on non-OK returns. Successful generation
owns exactly one opaque send owner until its terminal callback.

The connection cancellation scope may be a child of a process or listener scope.
Cancellation and deadline propagation begin abortive close under the same lock as
input, output completion, timers, and application operations. Graceful close stops
new application work while continuing protocol input, timed work, and final
generated datagrams. Abortive close stops new generation. In both modes, existing
output tokens and delivered application DATAGRAM views retain their storage until
terminal completion or release.

Close is two-phase. `begin_close` borrows its reason only for the protocol callback,
which must copy anything it needs. `close_ready` preflights protocol ownership and
`finish_close` is idempotent after readiness. The driver then detaches cancellation
and invalidates stream and DATAGRAM storage only after all generated datagrams,
stream attempts, prepared DATAGRAM sends, and delivered DATAGRAM views have drained.
The initiating close cause and a later abortive terminal cause are preserved
separately.

`connection.assembly.release_closed` is the terminal transaction that makes a
finished fixed connection record reusable. It refuses without mutation until the
driver is closed, cancellation is detached, routing is retired, the core and TLS
provider are destroyed, and every manager lease and application borrower is gone.
Success removes retained protocol and configuration references while preserving
route epochs and generated-datagram slot generations. A second call after success
is idempotent. The next `init_client` or `init_server` may use the same assembly
address with a newly initialized TLS provider and cancellation scope, and delayed
routes or transport tokens from its prior use remain stale.

Initialization has the same ownership boundary. A failed `init_client` or
`init_server` retires any route that was staged internally, releases core leases,
detaches the handshake adapter without destroying the caller's TLS provider, and
closes every manager initialized by that attempt. `reusable` confirms the complete
rollback before a bounded owner returns the fixed record to its free list.

## Development

Dependencies use exact Git tags or commit pins. The temporary `mach-tls` commit
pin remains until its client handshake is released as a tag.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to Mach's default `out/` directory.
