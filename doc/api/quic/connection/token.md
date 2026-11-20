[quic](../README.md) / [connection](README.md) / **token**

# quic.connection.token

authenticated address and retry tokens with owned replay protection

consumed retry nonces are remembered until their token could no longer
authenticate, in storage that grows with what is remembered

Source: [`src/connection/token.mach`](../../../../src/connection/token.mach)

Uses types from [`quic.connection.ownership`](ownership.md), [`quic.packet.packet`](../packet/packet.md), [`quic.storage.heap`](../storage/heap.md), [`quic.storage.index`](../storage/index.md), [`quic.storage.slots`](../storage/slots.md).

| Type | | |
| :--- | :--- | :--- |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`ReplayState`](#replaystate) | `def` |  |
| [`ReplaySlot`](#replayslot) | `rec` | an entry leaves the expiry heap and the index once its token has expired, but a reservation's owner still holds it until commit or cancel |
| [`Config`](#config) | `rec` | max_replay caps remembered nonces by count |
| [`Manager`](#manager) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |
| [`Reservation`](#reservation) | `rec` |  |
| [`Claims`](#claims) | `rec` |  |
| [`Result`](#result) | `rec` |  |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_STALE`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_ERROR`](#status) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_BUFFER`](#error), [`ERROR_FORMAT`](#error), [`ERROR_KEY`](#error), [`ERROR_AUTH`](#error), [`ERROR_EXPIRED`](#error), [`ERROR_ADDRESS`](#error), [`ERROR_REPLAY`](#error), [`ERROR_CAPACITY`](#error), [`ERROR_TOKEN`](#error), [`ERROR_TIME`](#error), [`ERROR_MEMORY`](#error) | |
| [`ERROR_REPLAY_FULL`](#error) | the replay store is at its bound |

| On `ReplayState` | |
| :--- | :--- |
| [`REPLAY_FREE`](#replaystate), [`REPLAY_RESERVED`](#replaystate), [`REPLAY_CONSUMED`](#replaystate) | |

| On `Manager` | |
| :--- | :--- |
| [`ranges`](#ranges) | writes the manager and every directory it owns |
| [`initialize`](#initialize) | replay storage draws on `backing` for the manager's whole life and is released to it by finish_close |
| [`lease_listener`](#lease_listener), [`release_listener`](#release_listener), [`rotate`](#rotate), [`rotate_scoped`](#rotate_scoped), [`seal`](#seal), [`seal_scoped`](#seal_scoped), [`open`](#open), [`open_scoped`](#open_scoped), [`commit`](#commit), [`commit_scoped`](#commit_scoped), [`cancel`](#cancel), [`cancel_scoped`](#cancel_scoped), [`begin_close`](#begin_close), [`finish_close`](#finish_close), [`snapshot`](#snapshot) | |

| Constants | |
| :--- | :--- |
| [`PURPOSE_RETRY`](#constants), [`PURPOSE_ADDRESS`](#constants), [`TOKEN_SIZE`](#constants), [`BODY_SIZE`](#constants), [`TAG_SIZE`](#constants), [`KEY_SIZE`](#constants) | |
| [`RANGE_COUNT`](#constants) | how many ranges `ranges` writes |

---

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_STALE` | `2` |  |
| `STATUS_BLOCKED` | `3` |  |
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
| `ERROR_BUFFER` | `3` |  |
| `ERROR_FORMAT` | `4` |  |
| `ERROR_KEY` | `5` |  |
| `ERROR_AUTH` | `6` |  |
| `ERROR_EXPIRED` | `7` |  |
| `ERROR_ADDRESS` | `8` |  |
| `ERROR_REPLAY` | `9` |  |
| `ERROR_CAPACITY` | `10` |  |
| `ERROR_TOKEN` | `11` |  |
| `ERROR_TIME` | `12` |  |
| `ERROR_MEMORY` | `13` |  |
| `ERROR_REPLAY_FULL` | `14` | the replay store is at its bound |

## ReplayState

```mach
pub def ReplayState: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `REPLAY_FREE` | `0` |  |
| `REPLAY_RESERVED` | `1` |  |
| `REPLAY_CONSUMED` | `2` |  |

## ReplaySlot

```mach
pub rec ReplaySlot {
    nonce:          u64;
    key_generation: u64;
    expires_at_ns:  u64;
    generation:     u64;
    hash:           u64;
    heap_position:  usize;
    state:          ReplayState;
}
```

an entry leaves the expiry heap and the index once its token has expired,
but a reservation's owner still holds it until commit or cancel

## Config

```mach
pub rec Config {
    source:          u64;
    retry_max_age:   std.chrono.duration.Duration;
    address_max_age: std.chrono.duration.Duration;
    max_replay:      usize;
}
```

max_replay caps remembered nonces by count. it is required: a peer that can
present many valid tokens must not be able to grow the store without limit

## Manager

```mach
pub rec Manager {
    config:              Config;
    backing:             *std.allocator.Allocator;
    replay:              quic.storage.slots.Slots[ReplaySlot];
    replay_index:        quic.storage.index.Index;
    expiry:              quic.storage.heap.Heap;
    hash_key:            std.crypto.hash.siphash.Key;
    current:             [32]^u8;
    previous:            [32]^u8;
    current_generation:  u64;
    previous_generation: u64;
    reserved:            usize;
    replay_full:         u64;
    generation:          u64;
    listener_lease:      u64;
    initialized:         bool;
    closing:             bool;
}
```

### ranges

```mach
pub fun ranges(manager: *Manager, output: *quic.connection.ownership.Range)
```

writes the manager and every directory it owns. directories move as they
grow, so the ranges hold only until the next retry token is opened

### initialize

```mach
pub fun initialize(manager: *Manager, config: Config,
    backing: *std.allocator.Allocator, generation: u64,
    key: crypto.contracts.SecretBytes) bool
```

replay storage draws on `backing` for the manager's whole life and is
released to it by finish_close

### lease_listener

```mach
pub fun lease_listener(manager: *Manager, source: u64) bool
```

### release_listener

```mach
pub fun release_listener(manager: *Manager, source: u64) bool
```

### rotate

```mach
pub fun rotate(manager: *Manager, generation: u64, key: crypto.contracts.SecretBytes) bool
```

### rotate_scoped

```mach
pub fun rotate_scoped(manager: *Manager, listener_source: u64, generation: u64,
    key: crypto.contracts.SecretBytes) bool
```

### seal

```mach
pub fun seal(manager: *Manager, purpose: u8, peer: std.net.ip.Endpoint,
    original_destination: quic.packet.packet.ConnectionId,
    retry_source: quic.packet.packet.ConnectionId, issued_at: std.chrono.time.Instant, nonce: u64,
    output: *u8, capacity: usize) Result
```

### seal_scoped

```mach
pub fun seal_scoped(manager: *Manager, listener_source: u64, purpose: u8,
    peer: std.net.ip.Endpoint, original_destination: quic.packet.packet.ConnectionId,
    retry_source: quic.packet.packet.ConnectionId, issued_at: std.chrono.time.Instant, nonce: u64,
    output: *u8, capacity: usize) Result
```

### open

```mach
pub fun open(manager: *Manager, input: *u8, length: usize,
    expected_peer: std.net.ip.Endpoint, now: std.chrono.time.Instant) Result
```

### open_scoped

```mach
pub fun open_scoped(manager: *Manager, listener_source: u64, input: *u8,
    length: usize, expected_peer: std.net.ip.Endpoint, now: std.chrono.time.Instant) Result
```

### commit

```mach
pub fun commit(manager: *Manager, reservation: Reservation) Result
```

### commit_scoped

```mach
pub fun commit_scoped(manager: *Manager, listener_source: u64,
    reservation: Reservation) Result
```

### cancel

```mach
pub fun cancel(manager: *Manager, reservation: Reservation) Result
```

### cancel_scoped

```mach
pub fun cancel_scoped(manager: *Manager, listener_source: u64,
    reservation: Reservation) Result
```

### begin_close

```mach
pub fun begin_close(manager: *Manager) bool
```

### finish_close

```mach
pub fun finish_close(manager: *Manager) bool
```

### snapshot

```mach
pub fun snapshot(manager: *Manager) Snapshot
```

## Snapshot

```mach
pub rec Snapshot {
    remembered:  usize;
    reserved:    usize;
    bytes:       usize;
    replay_full: u64;
    initialized: bool;
    closing:     bool;
}
```

## Reservation

```mach
pub rec Reservation {
    source:         u64;
    index:          usize;
    generation:     u64;
    nonce:          u64;
    key_generation: u64;
}
```

## Claims

```mach
pub rec Claims {
    purpose:              u8;
    issued_at_ns:         u64;
    nonce:                u64;
    peer:                 std.net.ip.Endpoint;
    original_destination: quic.packet.packet.ConnectionId;
    retry_source:         quic.packet.packet.ConnectionId;
    reservation:          Reservation;
}
```

## Result

```mach
pub rec Result {
    status: Status;
    error:  Error;
    count:  usize;
    claims: Claims;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `PURPOSE_RETRY` | `u8` | `1` |  |
| `PURPOSE_ADDRESS` | `u8` | `2` |  |
| `TOKEN_SIZE` | `usize` | `110` |  |
| `BODY_SIZE` | `usize` | `94` |  |
| `TAG_SIZE` | `usize` | `16` |  |
| `KEY_SIZE` | `usize` | `32` |  |
| `RANGE_COUNT` | `usize` | `4` | how many ranges `ranges` writes |

