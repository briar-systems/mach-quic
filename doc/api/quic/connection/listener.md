# quic.connection.listener

## def Action

```mach
pub def Action: u8
```

## val ACTION_ACCEPT

```mach
pub val ACTION_ACCEPT: Action = 1
```

## val ACTION_RETRY

```mach
pub val ACTION_RETRY: Action = 2
```

## val ACTION_VERSION_NEGOTIATION

```mach
pub val ACTION_VERSION_NEGOTIATION: Action = 3
```

## val ACTION_DROP

```mach
pub val ACTION_DROP: Action = 4
```

## val ACTION_BLOCKED

```mach
pub val ACTION_BLOCKED: Action = 5
```

## val ACTION_ERROR

```mach
pub val ACTION_ERROR: Action = 6
```

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE: Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE: Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG: Error = 2
```

## val ERROR_BUFFER

```mach
pub val ERROR_BUFFER: Error = 3
```

## val ERROR_PACKET

```mach
pub val ERROR_PACKET: Error = 4
```

## val ERROR_VERSION

```mach
pub val ERROR_VERSION: Error = 5
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: Error = 6
```

## val ERROR_IDENTITY

```mach
pub val ERROR_IDENTITY: Error = 7
```

## val ERROR_ADMISSION

```mach
pub val ERROR_ADMISSION: Error = 8
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: Error = 9
```

## val ERROR_CRYPTO

```mach
pub val ERROR_CRYPTO: Error = 10
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT: Error = 11
```

## val ERROR_TOKEN_HANDLE

```mach
pub val ERROR_TOKEN_HANDLE: Error = 12
```

## val PENDING_FREE

```mach
pub val PENDING_FREE: u8 = 0
```

## val PENDING_RESERVED

```mach
pub val PENDING_RESERVED: u8 = 1
```

## rec Config

```mach
pub rec Config;
```

## rec Pending

```mach
pub rec Pending;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Listener

```mach
pub rec Listener;
```

## rec Request

```mach
pub rec Request;
```

## rec Acceptance

```mach
pub rec Acceptance;
```

## rec Result

```mach
pub rec Result;
```

## rec Accepted

```mach
pub rec Accepted;
```

## fun initialize

```mach
pub fun initialize(listener: *Listener, config: Config, storage: Storage,
admission_manager: *admission.Manager,
token_manager: *token.Manager) bool;
```

## fun issue_address_token

```mach
pub fun issue_address_token(listener: *Listener, peer: ip.Endpoint,
now_ns: u64, nonce: u64, output: *u8,
capacity: usize) token.Result;
```

## fun preflight

```mach
pub fun preflight(listener: *Listener, request: *Request) Result;
```

## fun commit

```mach
pub fun commit(listener: *Listener, value: Acceptance) Accepted;
```

## fun cancel

```mach
pub fun cancel(listener: *Listener, value: Acceptance) Result;
```

## fun release_connection

```mach
pub fun release_connection(listener: *Listener, charge: admission.Charge) Result;
```

## fun begin_close

```mach
pub fun begin_close(listener: *Listener) bool;
```

## fun finish_close

```mach
pub fun finish_close(listener: *Listener) bool;
```

