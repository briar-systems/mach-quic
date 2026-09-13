# tls.engine

## def Level

```mach
pub def Level: u8
```

## val INITIAL

```mach
pub val INITIAL: Level = 1
```

## val HANDSHAKE

```mach
pub val HANDSHAKE: Level = 2
```

## val APPLICATION

```mach
pub val APPLICATION: Level = 3
```

## def Direction

```mach
pub def Direction: u8
```

## val SEND

```mach
pub val SEND: Direction = 1
```

## val RECEIVE

```mach
pub val RECEIVE: Direction = 2
```

## def EventKind

```mach
pub def EventKind: u8
```

## val CRYPTO

```mach
pub val CRYPTO: EventKind = 1
```

## val TRAFFIC_SECRET

```mach
pub val TRAFFIC_SECRET: EventKind = 2
```

## val PEER_PARAMETERS

```mach
pub val PEER_PARAMETERS: EventKind = 3
```

## val EARLY_DATA

```mach
pub val EARLY_DATA: EventKind = 4
```

## val AUTHENTICATION

```mach
pub val AUTHENTICATION: EventKind = 5
```

## val HANDSHAKE_COMPLETE

```mach
pub val HANDSHAKE_COMPLETE: EventKind = 6
```

## val ALERT

```mach
pub val ALERT: EventKind = 7
```

## val CHANGE_CIPHER_SPEC

```mach
pub val CHANGE_CIPHER_SPEC: EventKind = 8
```

tls 1.2 announces each key change with its own record

## def Status

```mach
pub def Status: u8
```

## val OK

```mach
pub val OK: Status = 1
```

## val MORE

```mach
pub val MORE: Status = 2
```

## val BLOCKED

```mach
pub val BLOCKED: Status = 3
```

## val COMPLETE

```mach
pub val COMPLETE: Status = 4
```

## val FAILED

```mach
pub val FAILED: Status = 5
```

## val CLOSED

```mach
pub val CLOSED: Status = 6
```

## def Role

```mach
pub def Role: u8
```

## val CLIENT

```mach
pub val CLIENT: Role = 1
```

## val SERVER

```mach
pub val SERVER: Role = 2
```

## val TLS12_CLIENT

```mach
pub val TLS12_CLIENT: Role = 3
```

## val TLS12_SERVER

```mach
pub val TLS12_SERVER: Role = 4
```

## fun is_client

```mach
pub fun is_client(role: Role) bool;
```

## fun is_tls12

```mach
pub fun is_tls12(role: Role) bool;
```

## val EARLY_NOT_OFFERED

```mach
pub val EARLY_NOT_OFFERED: u8 = 1
```

## val EARLY_ACCEPTED

```mach
pub val EARLY_ACCEPTED: u8 = 2
```

## val EARLY_REJECTED

```mach
pub val EARLY_REJECTED: u8 = 3
```

## val AUTHENTICATED

```mach
pub val AUTHENTICATED: u8 = 1
```

## val AUTHENTICATION_FAILED

```mach
pub val AUTHENTICATION_FAILED: u8 = 2
```

## val MAX_TRAFFIC_KEY

```mach
pub val MAX_TRAFFIC_KEY: usize = 32
```

## val TRAFFIC_IV_SIZE

```mach
pub val TRAFFIC_IV_SIZE: usize = 12
```

## rec Result

```mach
pub rec Result;
```

## rec Event

```mach
pub rec Event;
```

event data and secrets remain borrowed until complete_event

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun result

```mach
pub fun result(status: Status, failure: error.Error, consumed: usize,
required: usize) Result;
```

## fun empty_event

```mach
pub fun empty_event() Event;
```

every field is assigned by name: an empty record literal is not trusted to
clear secret-welded members

## fun empty_snapshot

```mach
pub fun empty_snapshot() Snapshot;
```

## fun valid_level

```mach
pub fun valid_level(level: Level) bool;
```

## fun next_generation

```mach
pub fun next_generation(value: u64) u64;
```

## fun alert_for

```mach
pub fun alert_for(failure: error.Error) record.AlertDescription;
```

one protocol alert per failure, shared by every role and version

