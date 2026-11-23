# quic

Version 0.26.0.

| Artifact | Kind | Entry |
| :--- | :--- | :--- |
| `quic` | `static` | [`quic.lib.quic`](lib/quic.md) |
| `tests` | `static` | `quic.lib.tests` |

| Directory | |
| :--- | :--- |
| [`congestion/`](congestion/README.md) |  |
| [`connection/`](connection/README.md) |  |
| [`crypto/`](crypto/README.md) |  |
| [`frame/`](frame/README.md) |  |
| [`lib/`](lib/README.md) |  |
| [`packet/`](packet/README.md) |  |
| [`path/`](path/README.md) |  |
| [`recovery/`](recovery/README.md) |  |
| [`storage/`](storage/README.md) |  |
| [`stream/`](stream/README.md) |  |
| [`transport/`](transport/README.md) | bounded public quic connection driver |
| [`wire/`](wire/README.md) |  |

| Module | |
| :--- | :--- |
| [`clock`](clock.md) | the boundary between std's monotonic clock and quic's internal time |
| [`transport`](transport.md) | bounded public quic connection driver |
| [`transport_parameters`](transport_parameters.md) |  |

Depends on `std`, `crypto`, `tls`, `pki`.
