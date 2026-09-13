# quic.connection.token

## val PURPOSE_RETRY

```mach
pub val PURPOSE_RETRY: u8 = 1
```

## val PURPOSE_ADDRESS

```mach
pub val PURPOSE_ADDRESS: u8 = 2
```

## val TOKEN_SIZE

```mach
pub val TOKEN_SIZE: usize = 110
```

## val BODY_SIZE

```mach
pub val BODY_SIZE: usize = 94
```

## val TAG_SIZE

```mach
pub val TAG_SIZE: usize = 16
```

## val KEY_SIZE

```mach
pub val KEY_SIZE: usize = 32
```

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK: Status = 1
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: Status = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: Status = 3
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: Status = 4
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

## val ERROR_FORMAT

```mach
pub val ERROR_FORMAT: Error = 4
```

## val ERROR_KEY

```mach
pub val ERROR_KEY: Error = 5
```

## val ERROR_AUTH

```mach
pub val ERROR_AUTH: Error = 6
```

## val ERROR_EXPIRED

```mach
pub val ERROR_EXPIRED: Error = 7
```

## val ERROR_ADDRESS

```mach
pub val ERROR_ADDRESS: Error = 8
```

## val ERROR_REPLAY

```mach
pub val ERROR_REPLAY: Error = 9
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: Error = 10
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: Error = 11
```

## val ERROR_TIME

```mach
pub val ERROR_TIME: Error = 12
```

## def ReplayState

```mach
pub def ReplayState: u8
```

## val REPLAY_FREE

```mach
pub val REPLAY_FREE: ReplayState = 0
```

## val REPLAY_RESERVED

```mach
pub val REPLAY_RESERVED: ReplayState = 1
```

## val REPLAY_CONSUMED

```mach
pub val REPLAY_CONSUMED: ReplayState = 2
```

## rec ReplaySlot

```mach
pub rec ReplaySlot;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Config

```mach
pub rec Config;
```

## rec Manager

```mach
pub rec Manager;
```

## rec Reservation

```mach
pub rec Reservation;
```

## rec Claims

```mach
pub rec Claims;
```

## rec Result

```mach
pub rec Result;
```

## fun initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage,
generation: u64, key: contracts.SecretBytes) bool;
```

## fun lease_listener

```mach
pub fun lease_listener(manager: *Manager, source: u64) bool;
```

## fun release_listener

```mach
pub fun release_listener(manager: *Manager, source: u64) bool;
```

## fun rotate

```mach
pub fun rotate(manager: *Manager, generation: u64, key: contracts.SecretBytes) bool;
```

## fun rotate_scoped

```mach
pub fun rotate_scoped(manager: *Manager, listener_source: u64, generation: u64,
key: contracts.SecretBytes) bool;
```

## fun seal

```mach
pub fun seal(manager: *Manager, purpose: u8, peer: ip.Endpoint,
original_destination: packet.ConnectionId,
retry_source: packet.ConnectionId, issued_at_ns: u64, nonce: u64,
output: *u8, capacity: usize) Result;
```

## fun seal_scoped

```mach
pub fun seal_scoped(manager: *Manager, listener_source: u64, purpose: u8,
peer: ip.Endpoint, original_destination: packet.ConnectionId,
retry_source: packet.ConnectionId, issued_at_ns: u64, nonce: u64,
output: *u8, capacity: usize) Result;
```

## fun open

```mach
pub fun open(manager: *Manager, input: *u8, length: usize,
expected_peer: ip.Endpoint, now_ns: u64) Result;
```

## fun open_scoped

```mach
pub fun open_scoped(manager: *Manager, listener_source: u64, input: *u8,
length: usize, expected_peer: ip.Endpoint, now_ns: u64) Result;
```

## fun commit

```mach
pub fun commit(manager: *Manager, reservation: Reservation) Result;
```

## fun commit_scoped

```mach
pub fun commit_scoped(manager: *Manager, listener_source: u64,
reservation: Reservation) Result;
```

## fun cancel

```mach
pub fun cancel(manager: *Manager, reservation: Reservation) Result;
```

## fun cancel_scoped

```mach
pub fun cancel_scoped(manager: *Manager, listener_source: u64,
reservation: Reservation) Result;
```

## fun begin_close

```mach
pub fun begin_close(manager: *Manager) bool;
```

## fun finish_close

```mach
pub fun finish_close(manager: *Manager) bool;
```

