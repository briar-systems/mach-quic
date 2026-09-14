# tls.config

## rec ProtocolName

```mach
pub rec ProtocolName;
```

## rec Limits

```mach
pub rec Limits;
```

## rec ClientConfig

```mach
pub rec ClientConfig;
```

## rec ServerConfig

```mach
pub rec ServerConfig;
```

client authentication policy belongs to the published credential generation,
so the listener configuration deliberately does not restate it

## fun production_limits

```mach
pub fun production_limits() Limits;
```

