# quic.stream.datagram

## val ENTRY_FREE

```mach
pub val ENTRY_FREE:      u8 = 0
```

## val ENTRY_QUEUED

```mach
pub val ENTRY_QUEUED:    u8 = 1
```

## val ENTRY_RESERVED

```mach
pub val ENTRY_RESERVED:  u8 = 2
```

## val ENTRY_DELIVERED

```mach
pub val ENTRY_DELIVERED: u8 = 3
```

## val STATUS_OK

```mach
pub val STATUS_OK:    u8 = 1
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY: u8 = 2
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: u8 = 3
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: u8 = 4
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:     u8 = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:    u8 = 1
```

## val ERROR_DISABLED

```mach
pub val ERROR_DISABLED: u8 = 2
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT:    u8 = 3
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: u8 = 4
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN:    u8 = 5
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: u8 = 6
```

## rec Config

```mach
pub rec Config;
```

## rec Entry

```mach
pub rec Entry;
```

a queued datagram holds its payload in one chunk from the time it is queued
until it is published, cancelled or released

## rec Storage

```mach
pub rec Storage;
```

strides are the largest payload each direction accepts, at most supply.BYTES.
payload chunks come from `chunks`, charged to `account`

## fun empty_storage

```mach
pub fun empty_storage() Storage;
```

every field is assigned by name: an empty record literal does not reliably
clear one, and these become ownership ranges

## rec Queue

```mach
pub rec Queue;
```

## rec Token

```mach
pub rec Token;
```

## rec QueueResult

```mach
pub rec QueueResult;
```

## rec Prepared

```mach
pub rec Prepared;
```

## rec Delivery

```mach
pub rec Delivery;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## fun initialize

```mach
pub fun initialize(queue: *Queue, config: Config, storage: Storage) bool;
```

## fun lease_core

```mach
pub fun lease_core(queue: *Queue, source: u64) bool;
```

## fun release_core

```mach
pub fun release_core(queue: *Queue, source: u64) bool;
```

## fun enqueue

```mach
pub fun enqueue(queue: *Queue, data: *u8, length: usize) QueueResult;
```

## fun prepare

```mach
pub fun prepare(queue: *Queue, with_length: bool) Prepared;
```

## fun cancel_prepared

```mach
pub fun cancel_prepared(queue: *Queue, prepared: Prepared) OperationResult;
```

## fun publish

```mach
pub fun publish(queue: *Queue, prepared: Prepared) OperationResult;
```

## fun bind_peer_limit

```mach
pub fun bind_peer_limit(queue: *Queue, maximum: usize) OperationResult;
```

## fun cancel

```mach
pub fun cancel(queue: *Queue, value: Token) OperationResult;
```

## fun receive

```mach
pub fun receive(queue: *Queue, data: *u8, length: usize, encoded_frame_size: usize) QueueResult;
```

## fun next

```mach
pub fun next(queue: *Queue) Delivery;
```

## fun release

```mach
pub fun release(queue: *Queue, value: Token) OperationResult;
```

## fun begin_close

```mach
pub fun begin_close(queue: *Queue) OperationResult;
```

## fun finish_close

```mach
pub fun finish_close(queue: *Queue) OperationResult;
```

## fun prepare_scoped

```mach
pub fun prepare_scoped(queue: *Queue, source: u64,
with_length: bool) Prepared;
```

## fun cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(queue: *Queue, source: u64,
prepared: Prepared) OperationResult;
```

## fun publish_scoped

```mach
pub fun publish_scoped(queue: *Queue, source: u64,
prepared: Prepared) OperationResult;
```

## fun receive_scoped

```mach
pub fun receive_scoped(queue: *Queue, source: u64, data: *u8,
length: usize, encoded_frame_size: usize) QueueResult;
```

## fun bind_peer_limit_scoped

```mach
pub fun bind_peer_limit_scoped(queue: *Queue, source: u64,
maximum: usize) OperationResult;
```

## fun begin_close_scoped

```mach
pub fun begin_close_scoped(queue: *Queue, source: u64) OperationResult;
```

## fun finish_close_scoped

```mach
pub fun finish_close_scoped(queue: *Queue, source: u64) OperationResult;
```

