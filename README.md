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
output. Protocol varints accept the non-minimal encodings required by RFC 9000.
The standalone varint reader also provides canonical validation where a consumer
needs it.

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
- `recovery` owns acknowledgement, loss detection, RTT, and probe state.
- `congestion` owns send allowance independently of recovery policy.
- `stream` owns per-stream flow control and lifecycle state.
- `transport` composes the parts into a connection without owning HTTP semantics.

HTTP/3 will consume QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer. QPACK and HTTP/3 frame
processing will be added with the HTTP/3 engine once the transport is implemented.

The remaining connection, recovery, protection, stream, and transport engine work
is tracked separately from these completed wire primitives.

## Development

Dependencies use pinned Git tags.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to Mach's default `out/` directory.
