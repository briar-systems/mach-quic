# mach-quic

Lightweight QUIC transport contracts for Mach.

This repository currently defines packet, cryptographic integration, recovery,
congestion control, stream, and connection state boundaries. It is scaffolding,
not a working QUIC implementation. No packet protection or network traffic is
performed yet.

## Boundaries

- `packet` owns wire header and packet number metadata.
- `crypto` adapts handshake and packet protection supplied by `mach-crypto` and
  `mach-tls` without embedding an algorithm in the transport state machine.
- `recovery` owns acknowledgement, loss detection, RTT, and probe state.
- `congestion` owns send allowance independently of recovery policy.
- `stream` owns per-stream flow control and lifecycle state.
- `transport` composes the parts into a connection without owning HTTP semantics.

HTTP/3 will consume QUIC streams and the version-neutral message contracts from
`mach-http`. It does not belong in the QUIC transport layer. QPACK and HTTP/3 frame
processing will be added with the HTTP/3 engine once the transport is implemented.

The full production roadmap and validation requirements are tracked in Hedge.

## Development

Dependencies use local paths while the repositories are being developed together.

```sh
mach dep pull .
mach build .
mach test .
```

Build products are written to `../.mach-out/quic` so generated files stay outside
this repository.

