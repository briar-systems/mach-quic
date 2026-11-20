[quic](../README.md) / **connection**

# quic.connection

| Module | |
| :--- | :--- |
| [`admission`](admission.md) | server connection admission charged before expensive allocation |
| [`assembly`](assembly.md) | assembles a connection core and every manager it owns from one configuration |
| [`assembly_live`](assembly_live.md) | a real client and a real server, assembled from configuration and driven to a completed handshake and an exchanged stream over real packet protection |
| [`cid`](cid.md) | bounded connection id lifecycle |
| [`core`](core.md) | serialized QUIC connection engine with split public and secret state |
| [`core_simulated`](core_simulated.md) |  |
| [`credentials_simulated`](credentials_simulated.md) | the ed25519 test chain shared by every binding that needs a real mach-tls peer |
| [`handshake`](handshake.md) | production-shaped tls handshake adapter for quic crypto streams |
| [`handshake_simulated`](handshake_simulated.md) |  |
| [`listener`](listener.md) | stateless server preflight and pre-allocation admission |
| [`negotiation`](negotiation.md) | client version negotiation and Retry restart lifecycle |
| [`ownership`](ownership.md) | checked physical ownership ranges |
| [`scratch`](scratch.md) | the buffers a connection needs only while one of its calls runs |
| [`tls_client`](tls_client.md) | typed mach-tls client binding for quic handshake ownership |
| [`tls_server`](tls_server.md) | typed mach-tls server binding driven against a real mach-tls client |
| [`token`](token.md) | authenticated address and retry tokens with owned replay protection |

