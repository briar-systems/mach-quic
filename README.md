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
- `transport` composes the parts into a connection without owning HTTP semantics.

HTTP/3 will consume QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer. QPACK and HTTP/3 frame
processing will be added with the HTTP/3 engine once the transport is implemented.

The remaining connection, protection, path, and transport engine work is tracked
separately from these completed wire, recovery, congestion, stream, and datagram
primitives.

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

## Development

Dependencies use pinned Git tags.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to Mach's default `out/` directory.
