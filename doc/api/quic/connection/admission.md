# quic.connection.admission

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK: Status = 1
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: Status = 2
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: Status = 3
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

## val ERROR_GLOBAL_LIMIT

```mach
pub val ERROR_GLOBAL_LIMIT: Error = 3
```

## val ERROR_PEER_LIMIT

```mach
pub val ERROR_PEER_LIMIT: Error = 4
```

## val ERROR_PEER_CAPACITY

```mach
pub val ERROR_PEER_CAPACITY: Error = 5
```

## val ERROR_CHARGE_CAPACITY

```mach
pub val ERROR_CHARGE_CAPACITY: Error = 6
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: Error = 7
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: Error = 8
```

## def ChargeState

```mach
pub def ChargeState: u8
```

## val CHARGE_FREE

```mach
pub val CHARGE_FREE: ChargeState = 0
```

## val CHARGE_RESERVED

```mach
pub val CHARGE_RESERVED: ChargeState = 1
```

## val CHARGE_COMMITTED

```mach
pub val CHARGE_COMMITTED: ChargeState = 2
```

## rec Config

```mach
pub rec Config;
```

## rec PeerKey

```mach
pub rec PeerKey;
```

peer quotas are keyed by address, not ephemeral source port

## rec PeerSlot

```mach
pub rec PeerSlot;
```

## rec ChargeSlot

```mach
pub rec ChargeSlot;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Manager

```mach
pub rec Manager;
```

## rec Charge

```mach
pub rec Charge;
```

## rec Result

```mach
pub rec Result;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun peer_key

```mach
pub fun peer_key(endpoint: ip.Endpoint) PeerKey;
```

## fun peer_equal

```mach
pub fun peer_equal(left: PeerKey, right: PeerKey) bool;
```

## fun initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage) bool;
```

## fun lease_listener

```mach
pub fun lease_listener(manager: *Manager, source: u64) bool;
```

## fun release_listener

```mach
pub fun release_listener(manager: *Manager, source: u64) bool;
```

## fun reserve

```mach
pub fun reserve(manager: *Manager, endpoint: ip.Endpoint) Result;
```

## fun reserve_scoped

```mach
pub fun reserve_scoped(manager: *Manager, listener_source: u64,
endpoint: ip.Endpoint) Result;
```

## fun commit

```mach
pub fun commit(manager: *Manager, charge: Charge) Result;
```

## fun commit_scoped

```mach
pub fun commit_scoped(manager: *Manager, listener_source: u64,
charge: Charge) Result;
```

## fun release

```mach
pub fun release(manager: *Manager, charge: Charge) Result;
```

## fun release_scoped

```mach
pub fun release_scoped(manager: *Manager, listener_source: u64,
charge: Charge) Result;
```

## fun begin_close

```mach
pub fun begin_close(manager: *Manager) bool;
```

## fun finish_close

```mach
pub fun finish_close(manager: *Manager) bool;
```

## fun snapshot

```mach
pub fun snapshot(manager: *Manager) Snapshot;
```

