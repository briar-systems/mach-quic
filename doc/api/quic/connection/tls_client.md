[quic](../README.md) / [connection](README.md) / **tls_client**

# quic.connection.tls_client

typed mach-tls client binding for quic handshake ownership

Source: [`src/connection/tls_client.mach`](../../../../src/connection/tls_client.mach)

Uses types from [`quic.connection.handshake`](handshake.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |

| On `Config` | |
| :--- | :--- |
| [`initialize`](#initialize) | |

| Constants | |
| :--- | :--- |
| [`ERROR_TLS_BASE`](#constants), [`ERROR_CONFIG`](#constants), [`ERROR_LEVEL`](#constants), [`ERROR_OFFSET`](#constants), [`ERROR_TIME`](#constants), [`ERROR_DEADLINE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_EVENT`](#constants) | |

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
    storage: quic.connection.handshake.Storage, value: *tls.client.Handshake,
    lease: tls.buffer.Lease, configuration: Config) bool
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ERROR_TLS_BASE` | `u64` | `handshake_api.PROVIDER_TLS_ERROR_BASE` |  |
| `ERROR_CONFIG` | `u64` | `handshake_api.PROVIDER_BINDING_CONFIG` |  |
| `ERROR_LEVEL` | `u64` | `handshake_api.PROVIDER_BINDING_LEVEL` |  |
| `ERROR_OFFSET` | `u64` | `handshake_api.PROVIDER_BINDING_OFFSET` |  |
| `ERROR_TIME` | `u64` | `handshake_api.PROVIDER_BINDING_TIME` |  |
| `ERROR_DEADLINE` | `u64` | `handshake_api.PROVIDER_BINDING_DEADLINE` |  |
| `ERROR_STATE` | `u64` | `handshake_api.PROVIDER_BINDING_STATE` |  |
| `ERROR_EVENT` | `u64` | `handshake_api.PROVIDER_BINDING_EVENT` |  |

