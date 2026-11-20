[quic](../README.md) / [stream](README.md) / **datagram**

# quic.stream.datagram

Source: [`src/stream/datagram.mach`](../../../../src/stream/datagram.mach)

Uses types from [`quic.connection.ownership`](../connection/ownership.md), [`quic.packet.packet`](../packet/packet.md), [`quic.storage.source`](../storage/source.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |
| [`Entry`](#entry) | `rec` | a queued datagram holds its payload in one chunk from the time it is queued until it is published, cancelled or released |
| [`Storage`](#storage) | `rec` | strides are the largest payload each direction accepts, at most supply.BYTES |
| [`Queue`](#queue) | `rec` |  |
| [`Token`](#token) | `rec` |  |
| [`QueueResult`](#queueresult) | `rec` |  |
| [`Prepared`](#prepared) | `rec` |  |
| [`Delivery`](#delivery) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |

| On `Storage` | |
| :--- | :--- |
| [`empty_storage`](#empty_storage) | every field is assigned by name: an empty record literal does not reliably clear one, and these become ownership ranges |

| On `Queue` | |
| :--- | :--- |
| [`initialize`](#initialize), [`lease_core`](#lease_core), [`release_core`](#release_core), [`enqueue`](#enqueue), [`prepare`](#prepare), [`cancel_prepared`](#cancel_prepared), [`publish`](#publish), [`bind_peer_limit`](#bind_peer_limit), [`cancel`](#cancel), [`receive`](#receive), [`next`](#next), [`release`](#release), [`begin_close`](#begin_close), [`finish_close`](#finish_close), [`prepare_scoped`](#prepare_scoped) | |
| [`peek_scoped`](#peek_scoped) | what prepare_scoped would answer, with nothing changed |
| [`cancel_prepared_scoped`](#cancel_prepared_scoped), [`publish_scoped`](#publish_scoped), [`receive_scoped`](#receive_scoped), [`bind_peer_limit_scoped`](#bind_peer_limit_scoped), [`begin_close_scoped`](#begin_close_scoped), [`finish_close_scoped`](#finish_close_scoped) | |

| Constants | |
| :--- | :--- |
| [`ENTRY_FREE`](#constants), [`ENTRY_QUEUED`](#constants), [`ENTRY_RESERVED`](#constants), [`ENTRY_DELIVERED`](#constants), [`STATUS_OK`](#constants), [`STATUS_EMPTY`](#constants), [`STATUS_STALE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_DISABLED`](#constants), [`ERROR_LIMIT`](#constants), [`ERROR_CAPACITY`](#constants), [`ERROR_TOKEN`](#constants), [`ERROR_OVERFLOW`](#constants) | |

---

## Config

```mach
pub rec Config {
    source:               u64;
    peer_max_frame_size:  usize;
    local_max_frame_size: usize;
    enabled:              bool;
}
```

## Entry

```mach
pub rec Entry {
    generation: u64;
    sequence:   u64;
    length:     usize;
    state:      u8;
    chunk:      quic.storage.source.Chunk;
}
```

a queued datagram holds its payload in one chunk from the time it is queued
until it is published, cancelled or released

## Storage

```mach
pub rec Storage {
    send_entries:     *Entry;
    send_capacity:    usize;
    send_stride:      usize;
    receive_entries:  *Entry;
    receive_capacity: usize;
    receive_stride:   usize;
    chunks:           *quic.storage.source.Provider;
    account:          *quic.storage.source.Account;
}
```

strides are the largest payload each direction accepts, at most supply.BYTES.
payload chunks come from `chunks`, charged to `account`

### empty_storage

```mach
pub fun empty_storage() Storage
```

every field is assigned by name: an empty record literal does not reliably
clear one, and these become ownership ranges

## Queue

```mach
pub rec Queue {
    config:        Config;
    storage:       Storage;
    next_sequence: u64;
    send_count:    usize;
    # bumped when a datagram is queued, so an idle core notices without scanning
    send_revision:    u64;
    receive_count:    usize;
    delivered_count:  usize;
    core_lease:       u64;
    peer_limit_bound: bool;
    valid:            bool;
    closing:          bool;
    # the lent send and receive entry ranges, fixed from initialize on
    owned: [2]quic.connection.ownership.Range;
}
```

### initialize

```mach
pub fun initialize(queue: *Queue, config: Config, storage: Storage) bool
```

### lease_core

```mach
pub fun lease_core(queue: *Queue, source: u64) bool
```

### release_core

```mach
pub fun release_core(queue: *Queue, source: u64) bool
```

### enqueue

```mach
pub fun enqueue(queue: *Queue, data: *u8, length: usize) QueueResult
```

### prepare

```mach
pub fun prepare(queue: *Queue, with_length: bool) Prepared
```

### cancel_prepared

```mach
pub fun cancel_prepared(queue: *Queue, prepared: Prepared) OperationResult
```

### publish

```mach
pub fun publish(queue: *Queue, prepared: Prepared) OperationResult
```

### bind_peer_limit

```mach
pub fun bind_peer_limit(queue: *Queue, maximum: usize) OperationResult
```

### cancel

```mach
pub fun cancel(queue: *Queue, value: Token) OperationResult
```

### receive

```mach
pub fun receive(queue: *Queue, data: *u8, length: usize, encoded_frame_size: usize) QueueResult
```

### next

```mach
pub fun next(queue: *Queue) Delivery
```

### release

```mach
pub fun release(queue: *Queue, value: Token) OperationResult
```

### begin_close

```mach
pub fun begin_close(queue: *Queue) OperationResult
```

### finish_close

```mach
pub fun finish_close(queue: *Queue) OperationResult
```

### prepare_scoped

```mach
pub fun prepare_scoped(queue: *Queue, source: u64,
    with_length: bool) Prepared
```

### peek_scoped

```mach
pub fun peek_scoped(queue: *Queue, source: u64, with_length: bool) Prepared
```

what prepare_scoped would answer, with nothing changed

### cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(queue: *Queue, source: u64,
    prepared: Prepared) OperationResult
```

### publish_scoped

```mach
pub fun publish_scoped(queue: *Queue, source: u64,
    prepared: Prepared) OperationResult
```

### receive_scoped

```mach
pub fun receive_scoped(queue: *Queue, source: u64, data: *u8,
    length: usize, encoded_frame_size: usize) QueueResult
```

### bind_peer_limit_scoped

```mach
pub fun bind_peer_limit_scoped(queue: *Queue, source: u64,
    maximum: usize) OperationResult
```

### begin_close_scoped

```mach
pub fun begin_close_scoped(queue: *Queue, source: u64) OperationResult
```

### finish_close_scoped

```mach
pub fun finish_close_scoped(queue: *Queue, source: u64) OperationResult
```

## Token

```mach
pub rec Token {
    source:     u64;
    index:      usize;
    generation: u64;
    receive:    bool;
}
```

## QueueResult

```mach
pub rec QueueResult {
    ok:     bool;
    status: u8;
    error:  u8;
    token:  Token;
}
```

## Prepared

```mach
pub rec Prepared {
    ok:          bool;
    status:      u8;
    error:       u8;
    token:       Token;
    data:        quic.packet.packet.Span;
    frame_size:  usize;
    with_length: bool;
}
```

## Delivery

```mach
pub rec Delivery {
    status: u8;
    error:  u8;
    token:  Token;
    data:   quic.packet.packet.Span;
}
```

## OperationResult

```mach
pub rec OperationResult {
    status: u8;
    error:  u8;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ENTRY_FREE` | `u8` | `0` |  |
| `ENTRY_QUEUED` | `u8` | `1` |  |
| `ENTRY_RESERVED` | `u8` | `2` |  |
| `ENTRY_DELIVERED` | `u8` | `3` |  |
| `STATUS_OK` | `u8` | `1` |  |
| `STATUS_EMPTY` | `u8` | `2` |  |
| `STATUS_STALE` | `u8` | `3` |  |
| `STATUS_ERROR` | `u8` | `4` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_DISABLED` | `u8` | `2` |  |
| `ERROR_LIMIT` | `u8` | `3` |  |
| `ERROR_CAPACITY` | `u8` | `4` |  |
| `ERROR_TOKEN` | `u8` | `5` |  |
| `ERROR_OVERFLOW` | `u8` | `6` |  |

