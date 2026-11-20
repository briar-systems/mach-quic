[quic](../README.md) / [connection](README.md) / **admission**

# quic.connection.admission

server connection admission charged before expensive allocation

peers and charges live in directories that grow with what is admitted.
connection limits are policy counts, and an absent limit is unbounded

Source: [`src/connection/admission.mach`](../../../../src/connection/admission.mach)

Uses types from [`quic.connection.ownership`](ownership.md), [`quic.storage.index`](../storage/index.md), [`quic.storage.slots`](../storage/slots.md).

| Type | | |
| :--- | :--- | :--- |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`ChargeState`](#chargestate) | `def` |  |
| [`Config`](#config) | `rec` |  |
| [`PeerKey`](#peerkey) | `rec` | peer quotas are keyed by address, not ephemeral source port |
| [`PeerSlot`](#peerslot) | `rec` |  |
| [`ChargeSlot`](#chargeslot) | `rec` |  |
| [`Manager`](#manager) | `rec` |  |
| [`Charge`](#charge) | `rec` |  |
| [`Result`](#result) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_STALE`](#status), [`STATUS_ERROR`](#status) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_GLOBAL_LIMIT`](#error), [`ERROR_PEER_LIMIT`](#error), [`ERROR_MEMORY`](#error), [`ERROR_TOKEN`](#error), [`ERROR_OVERFLOW`](#error) | |

| On `ChargeState` | |
| :--- | :--- |
| [`CHARGE_FREE`](#chargestate), [`CHARGE_RESERVED`](#chargestate), [`CHARGE_COMMITTED`](#chargestate) | |

| On `PeerKey` | |
| :--- | :--- |
| [`peer_key`](#peer_key), [`peer_equal`](#peer_equal) | |

| On `Manager` | |
| :--- | :--- |
| [`ranges`](#ranges) | writes the manager and every directory it owns |
| [`initialize`](#initialize) | growth draws on `backing` for the manager's whole life, and storage is released to it by finish_close |
| [`lease_listener`](#lease_listener), [`release_listener`](#release_listener), [`reserve`](#reserve), [`reserve_scoped`](#reserve_scoped), [`commit`](#commit), [`commit_scoped`](#commit_scoped), [`release`](#release), [`release_scoped`](#release_scoped), [`begin_close`](#begin_close) | |
| [`finish_close`](#finish_close) | releases every directory |
| [`snapshot`](#snapshot) | |

| Constants | |
| :--- | :--- |
| [`RANGE_COUNT`](#constants) | how many ranges `ranges` writes |

---

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_BLOCKED` | `2` |  |
| `STATUS_STALE` | `3` |  |
| `STATUS_ERROR` | `4` |  |

## Error

```mach
pub def Error: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ERROR_NONE` | `0` |  |
| `ERROR_STATE` | `1` |  |
| `ERROR_CONFIG` | `2` |  |
| `ERROR_GLOBAL_LIMIT` | `3` |  |
| `ERROR_PEER_LIMIT` | `4` |  |
| `ERROR_MEMORY` | `5` |  |
| `ERROR_TOKEN` | `6` |  |
| `ERROR_OVERFLOW` | `7` |  |

## ChargeState

```mach
pub def ChargeState: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `CHARGE_FREE` | `0` |  |
| `CHARGE_RESERVED` | `1` |  |
| `CHARGE_COMMITTED` | `2` |  |

## Config

```mach
pub rec Config {
    source:                   u64;
    max_connections:          opt[usize];
    max_connections_per_peer: opt[usize];
}
```

## PeerKey

```mach
pub rec PeerKey {
    address: [16]u8;
    scope:   u32;
    is_v6:   bool;
}
```

peer quotas are keyed by address, not ephemeral source port

### peer_key

```mach
pub fun peer_key(endpoint: std.net.ip.Endpoint) PeerKey
```

### peer_equal

```mach
pub fun peer_equal(left: PeerKey, right: PeerKey) bool
```

## PeerSlot

```mach
pub rec PeerSlot {
    key:    PeerKey;
    hash:   u64;
    active: usize;
}
```

## ChargeSlot

```mach
pub rec ChargeSlot {
    peer_index: usize;
    generation: u64;
    state:      ChargeState;
}
```

## Manager

```mach
pub rec Manager {
    config:         Config;
    backing:        *std.allocator.Allocator;
    peers:          quic.storage.slots.Slots[PeerSlot];
    peer_index:     quic.storage.index.Index;
    charges:        quic.storage.slots.Slots[ChargeSlot];
    hash_key:       std.crypto.hash.siphash.Key;
    active:         usize;
    reserved:       usize;
    generation:     u64;
    listener_lease: u64;
    initialized:    bool;
    closing:        bool;
}
```

### ranges

```mach
pub fun ranges(manager: *Manager, output: *quic.connection.ownership.Range)
```

writes the manager and every directory it owns. directories move as they
grow, so the ranges hold only until the next admission

### initialize

```mach
pub fun initialize(manager: *Manager, config: Config,
    backing: *std.allocator.Allocator) bool
```

growth draws on `backing` for the manager's whole life, and storage is
released to it by finish_close

### lease_listener

```mach
pub fun lease_listener(manager: *Manager, source: u64) bool
```

### release_listener

```mach
pub fun release_listener(manager: *Manager, source: u64) bool
```

### reserve

```mach
pub fun reserve(manager: *Manager, endpoint: std.net.ip.Endpoint) Result
```

### reserve_scoped

```mach
pub fun reserve_scoped(manager: *Manager, listener_source: u64,
    endpoint: std.net.ip.Endpoint) Result
```

### commit

```mach
pub fun commit(manager: *Manager, charge: Charge) Result
```

### commit_scoped

```mach
pub fun commit_scoped(manager: *Manager, listener_source: u64,
    charge: Charge) Result
```

### release

```mach
pub fun release(manager: *Manager, charge: Charge) Result
```

### release_scoped

```mach
pub fun release_scoped(manager: *Manager, listener_source: u64,
    charge: Charge) Result
```

### begin_close

```mach
pub fun begin_close(manager: *Manager) bool
```

### finish_close

```mach
pub fun finish_close(manager: *Manager) bool
```

releases every directory. a refused release keeps the manager closing with
what it still holds, and a later call retries only that

### snapshot

```mach
pub fun snapshot(manager: *Manager) Snapshot
```

## Charge

```mach
pub rec Charge {
    source:     u64;
    index:      usize;
    generation: u64;
}
```

## Result

```mach
pub rec Result {
    status: Status;
    error:  Error;
    charge: Charge;
}
```

## Snapshot

```mach
pub rec Snapshot {
    active:      usize;
    reserved:    usize;
    peers:       usize;
    bytes:       usize;
    initialized: bool;
    closing:     bool;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `RANGE_COUNT` | `usize` | `4` | how many ranges `ranges` writes |

