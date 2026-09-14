# tls.handshake.negotiation

## rec Protocol

```mach
pub rec Protocol;
```

## rec Policy

```mach
pub rec Policy;
```

## rec Selection

```mach
pub rec Selection;
```

## fun negotiate

```mach
pub fun negotiate(value: *codec.ClientHello, policy: *Policy,
output: *Selection) error.Error;
```

## fun validate_server_selection

```mach
pub fun validate_server_selection(server: *codec.ServerHello,
client: *codec.ClientHello) error.Error;
```

