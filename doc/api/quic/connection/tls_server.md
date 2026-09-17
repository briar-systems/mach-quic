# quic.connection.tls_server

## rec Config

```mach
pub rec Config;
```

## fun initialize

```mach
pub fun initialize(adapter: *handshake_api.Adapter,
adapter_config: handshake_api.Config,
storage: handshake_api.Storage, value: *server.Handshake,
lease: buffer.Lease, configuration: Config) bool;
```

