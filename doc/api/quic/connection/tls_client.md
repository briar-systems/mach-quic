# quic.connection.tls_client

## rec Config

```mach
pub rec Config;
```

## val ERROR_TLS_BASE

```mach
pub val ERROR_TLS_BASE: u64 = handshake_api.PROVIDER_TLS_ERROR_BASE
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:   u64 = handshake_api.PROVIDER_BINDING_CONFIG
```

## val ERROR_LEVEL

```mach
pub val ERROR_LEVEL:    u64 = handshake_api.PROVIDER_BINDING_LEVEL
```

## val ERROR_OFFSET

```mach
pub val ERROR_OFFSET:   u64 = handshake_api.PROVIDER_BINDING_OFFSET
```

## val ERROR_TIME

```mach
pub val ERROR_TIME:     u64 = handshake_api.PROVIDER_BINDING_TIME
```

## val ERROR_DEADLINE

```mach
pub val ERROR_DEADLINE: u64 = handshake_api.PROVIDER_BINDING_DEADLINE
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:    u64 = handshake_api.PROVIDER_BINDING_STATE
```

## val ERROR_EVENT

```mach
pub val ERROR_EVENT:    u64 = handshake_api.PROVIDER_BINDING_EVENT
```

## fun initialize

```mach
pub fun initialize(adapter: *handshake_api.Adapter,
adapter_config: handshake_api.Config,
storage: handshake_api.Storage, value: *client.Handshake,
lease: buffer.Lease, configuration: Config) bool;
```

