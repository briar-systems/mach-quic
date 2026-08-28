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
provider boundary remains responsible for header protection, packet protection,
Retry integrity generation and validation, and key lifecycle.

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
- `crypto` adapts handshake and packet protection supplied by `mach-crypto` and
  `mach-tls` without embedding an algorithm in the transport state machine.
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
- `transport` composes the parts into a connection without owning HTTP semantics.

HTTP/3 will consume QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer. QPACK and HTTP/3 frame
processing will be added with the HTTP/3 engine once the connection core is implemented.

The remaining handshake, connection-core, and packet-protection work is tracked
separately from the completed wire, recovery, congestion, path, stream, datagram,
and public driver layers.

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

Congestion state is per network path and shared by all packet number spaces on
that path. `congestion.controller` provides NewReno and CUBIC behind one bounded,
allocation-free contract. Recovery remains authoritative for packet history and
bytes in flight. Before an ACK, timeout, key discard, or Retry mutates recovery,
the connection saves the prior flight size. It then passes recovery's immutable
terminal event batch, that saved flight size, the current RTT, validated ECN
state with its triggering packet send time, and the persistent-congestion result
to `controller.on_recovery`.

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
generation tagged. Publishing, cancelling, synchronizing a changed RTT or window,
reconfiguring a PMTU or pacing policy, or resetting a path invalidates older
schedules. A successful send is charged
only by `pacer.publish`, so a queued packet that is rebuilt, cancelled, or rejected
does not consume budget.

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
cancellation returns the reservation. A failed path or connection close makes a
prepared publication stale and returns its reserved bytes. A non-probing
reservation likewise becomes stale if migration selects another path before the
datagram publishes. Probing work remains usable on a non-selected path. The driver
calls frame publication only after its containing datagram publication succeeds.

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
final sizes publish no state. `read` copies only the contiguous prefix and returns
the exact new MAX_DATA and MAX_STREAM_DATA values after consumption. RESET_STREAM,
STOP_SENDING, application cancellation, and FIN each retain their distinct
terminal and retransmission ownership. Delayed frames for a released stream are
recognized from the cumulative stream counters and discarded instead of being
misclassified as frames that exceed the advertised stream limit.
Frame-level flow-control entry points implement the RFC stream-creation rules for
MAX_STREAM_DATA and STREAM_DATA_BLOCKED and return the current exact limit for a
driver response without exposing private lookup state.

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

The receive queue rejects admission with an explicit capacity result before
copying when it is full. Delivery borrows the queue's copied payload until
`release`. Two-phase close preserves delivered receive payloads and prepared send
payloads until their owners release or cancel them. The DATAGRAM form without a
Length field consumes the remainder of a QUIC packet and must therefore be
selected only for the final frame. The length-bearing form can be composed with
later frames.

## Connection driver contracts

`transport.Driver` is the version-neutral client and server boundary. HTTP/3 can
open, accept, read, write, finish, cancel, inspect, and release streams through
driver-owned public handles. It can send and receive QUIC DATAGRAM values and
inspect connection state without importing packet, crypto, recovery, congestion,
path, or stream implementation modules. The future connection core plugs into the
serialized `Protocol` callback boundary behind this API.

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
copy into application storage. Received application DATAGRAM views remain borrowed
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
same driver. They must be transactional on non-OK returns. Successful generation
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

## Development

Dependencies use pinned Git tags.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to Mach's default `out/` directory.
