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
- `congestion` owns send allowance independently of recovery policy.
- `stream` owns per-stream flow control and lifecycle state.
- `transport` composes the parts into a connection without owning HTTP semantics.

HTTP/3 will consume QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer. QPACK and HTTP/3 frame
processing will be added with the HTTP/3 engine once the transport is implemented.

The remaining connection, protection, congestion, stream, and transport engine
work is tracked separately from these completed wire and recovery primitives.

## Recovery contracts

Recovery is allocation-free. Callers provide bounded storage for ACK ranges and
sent-packet history in each of the Initial, Handshake, and Application Data packet
number spaces. Exhausted history rejects a packet before publication. Exhausted
ACK range storage evicts the oldest ranges and advances a receive floor so an
evicted packet number can never be accepted again.

`recovery.ack.build` returns an ACK frame, the largest acknowledged packet number,
and a receive generation. A successful packet send is published with
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

## Development

Dependencies use pinned Git tags.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to Mach's default `out/` directory.
