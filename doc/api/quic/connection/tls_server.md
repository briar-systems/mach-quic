[quic](../README.md) / [connection](README.md) / **tls_server**

# quic.connection.tls_server

typed mach-tls server binding driven against a real mach-tls client

Source: [`src/connection/tls_server.mach`](../../../../src/connection/tls_server.mach)

Uses types from [`quic.connection.handshake`](handshake.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |

| On `Config` | |
| :--- | :--- |
| [`initialize`](#initialize) | |

---

## Config

```mach
pub rec Config {
    deadline_ns:                 u64;
    entropy_context_size:        usize;
    entropy_secret_context_size: usize;
}
```

### initialize

```mach
pub fun initialize(adapter: *quic.connection.handshake.Adapter,
    adapter_config: quic.connection.handshake.Config,
    storage: quic.connection.handshake.Storage, value: *tls.server.Handshake,
    lease: tls.buffer.Lease, configuration: Config) bool
```

