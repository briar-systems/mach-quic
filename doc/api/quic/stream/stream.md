[quic](../README.md) / [stream](README.md) / **stream**

# quic.stream.stream

Source: [`src/stream/stream.mach`](../../../../src/stream/stream.mach)

Uses types from [`quic.connection.ownership`](../connection/ownership.md), [`quic.packet.packet`](../packet/packet.md), [`quic.storage.chunks`](../storage/chunks.md), [`quic.storage.ranges`](../storage/ranges.md), [`quic.storage.source`](../storage/source.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |
| [`Stream`](#stream) | `rec` | laid out so RECORDS_PACKED records fit one chunk: flags share one run and nothing repeats a pointer its chunk already holds |
| [`Ready`](#ready) | `rec` |  |
| [`Buffer`](#buffer) | `rec` |  |
| [`Attempt`](#attempt) | `rec` |  |
| [`Storage`](#storage) | `rec` | streams, attempts: lent for the manager's lifetime, or nil to take them from                    the pool while they are in use chunks:            where every stream's bytes come from account:           whose budget they count against send_buffer_limit: bytes a stream may hold written and unacknowledged |
| [`Manager`](#manager) | `rec` |  |
| [`Handle`](#handle) | `rec` |  |
| [`AttemptToken`](#attempttoken) | `rec` |  |
| [`CreateResult`](#createresult) | `rec` |  |
| [`WriteResult`](#writeresult) | `rec` |  |
| [`ReadResult`](#readresult) | `rec` |  |
| [`ReceiveResult`](#receiveresult) | `rec` |  |
| [`Prepared`](#prepared) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |

| On `Storage` | |
| :--- | :--- |
| [`lent_records`](#lent_records) | the caller-lent record array, empty when records come from the pool |
| [`lent_attempts`](#lent_attempts) | the caller-lent attempt array, empty when attempts come from the pool |

| On `Manager` | |
| :--- | :--- |
| [`initialize`](#initialize), [`lease_core`](#lease_core), [`release_core`](#release_core) | |
| [`attempts_drained`](#attempts_drained) | whether no attempt is reserved or in flight |
| [`handle_at`](#handle_at) | the handle of the live stream at `index`, with source 0 when there is none |
| [`next_ready`](#next_ready) | hands the owner the oldest stream with news, O(1) |
| [`pending_news`](#pending_news) | whether next_ready or accept has anything to hand the owner, O(1): a stream with news it has not taken, or a peer stream it has not accepted |
| [`storage_released`](#storage_released) | the pool gave chunks back, so every stream a refused chunk stopped may write |
| [`open`](#open), [`accept`](#accept), [`update_max_data`](#update_max_data) | |
| [`apply_peer_limits`](#apply_peer_limits) | binds the peer's authenticated initial transport limits exactly once |
| [`update_max_stream_data`](#update_max_stream_data), [`receive_max_stream_data`](#receive_max_stream_data), [`update_max_streams`](#update_max_streams), [`write`](#write), [`finish`](#finish), [`cancel_send`](#cancel_send), [`cancel_receive`](#cancel_receive), [`prepare_control`](#prepare_control), [`prepare`](#prepare), [`cancel_prepared`](#cancel_prepared), [`publish`](#publish), [`on_terminal`](#on_terminal), [`receive_stream_data_blocked`](#receive_stream_data_blocked), [`receive_data_blocked`](#receive_data_blocked), [`receive_streams_blocked`](#receive_streams_blocked), [`receive_stream`](#receive_stream), [`receive_reset`](#receive_reset), [`acknowledge_reset`](#acknowledge_reset), [`receive_stop`](#receive_stop), [`read`](#read), [`credit`](#credit), [`snapshot`](#snapshot), [`release`](#release), [`begin_close`](#begin_close), [`finish_close`](#finish_close), [`apply_peer_limits_scoped`](#apply_peer_limits_scoped), [`update_max_data_scoped`](#update_max_data_scoped), [`receive_max_stream_data_scoped`](#receive_max_stream_data_scoped), [`update_max_streams_scoped`](#update_max_streams_scoped), [`prepare_control_scoped`](#prepare_control_scoped), [`prepare_scoped`](#prepare_scoped) | |
| [`peek_control_scoped`](#peek_control_scoped) | what prepare_control_scoped would answer, with no token and nothing changed |
| [`peek_scoped`](#peek_scoped) | what prepare_scoped would answer on `value`, with no token and nothing changed |
| [`attempts_held`](#attempts_held) | whether a prepare can claim an attempt without taking a chunk from the pool |
| [`cancel_prepared_scoped`](#cancel_prepared_scoped), [`publish_scoped`](#publish_scoped), [`on_terminal_scoped`](#on_terminal_scoped), [`receive_stream_data_blocked_scoped`](#receive_stream_data_blocked_scoped), [`receive_data_blocked_scoped`](#receive_data_blocked_scoped), [`receive_streams_blocked_scoped`](#receive_streams_blocked_scoped), [`receive_stream_scoped`](#receive_stream_scoped), [`receive_reset_scoped`](#receive_reset_scoped), [`receive_stop_scoped`](#receive_stop_scoped), [`begin_close_scoped`](#begin_close_scoped), [`finish_close_scoped`](#finish_close_scoped) | |

| Functions | |
| :--- | :--- |
| [`initiated_by_server`](#initiated_by_server), [`unidirectional`](#unidirectional) | |

| Constants | |
| :--- | :--- |
| [`ROLE_CLIENT`](#constants), [`ROLE_SERVER`](#constants), [`DIRECTION_BIDIRECTIONAL`](#constants), [`DIRECTION_UNIDIRECTIONAL`](#constants), [`SEND_STREAM`](#constants), [`SEND_RESET`](#constants), [`SEND_STOP`](#constants), [`SEND_MAX_DATA`](#constants), [`SEND_MAX_STREAM_DATA`](#constants), [`SEND_MAX_STREAMS_BIDI`](#constants), [`SEND_MAX_STREAMS_UNI`](#constants), [`TERMINAL_ACKED`](#constants), [`TERMINAL_LOST`](#constants), [`STATUS_OK`](#constants), [`STATUS_EMPTY`](#constants), [`STATUS_BLOCKED`](#constants), [`STATUS_RESET`](#constants), [`STATUS_FINISHED`](#constants), [`STATUS_CANCELLED`](#constants), [`STATUS_STALE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_STREAM_LIMIT`](#constants), [`ERROR_CAPACITY`](#constants), [`ERROR_DIRECTION`](#constants), [`ERROR_FLOW_CONTROL`](#constants), [`ERROR_FINAL_SIZE`](#constants), [`ERROR_DATA_CONFLICT`](#constants), [`ERROR_TOKEN`](#constants), [`ERROR_OVERFLOW`](#constants), [`ERROR_CANCELLED`](#constants) | |
| [`ERROR_STORAGE`](#constants) | a receive the connection cannot store right now: the caller refuses the packet unacknowledged and the peer retransmits it |
| [`RECORDS_PER_BLOCK`](#constants) | records and attempts left unlent are taken from the pool a chunk at a time |
| [`RECORDS_PACKED`](#constants) | the six h3 control streams an idle connection keeps open fit in one block |
| [`RECORD_BLOCKS`](#constants), [`ATTEMPTS_PER_BLOCK`](#constants) | |
| [`READY_READABLE`](#constants) | news an owner can act on for one stream |
| [`READY_WRITABLE`](#constants), [`READY_RESET`](#constants) | |

---

## Config

```mach
pub rec Config {
    source:                            u64;
    role:                              u8;
    local_bidirectional_limit:         u64;
    local_unidirectional_limit:        u64;
    peer_bidirectional_limit:          u64;
    peer_unidirectional_limit:         u64;
    send_max_data:                     u64;
    receive_max_data:                  u64;
    send_local_bidirectional_limit:    u64;
    send_peer_bidirectional_limit:     u64;
    send_unidirectional_limit:         u64;
    receive_local_bidirectional_limit: u64;
    receive_peer_bidirectional_limit:  u64;
    receive_unidirectional_limit:      u64;
}
```

## Stream

```mach
pub rec Stream {
    id:                      u64;
    generation:              u64;
    accept_sequence:         u64;
    send_base:               u64;
    send_write:              u64;
    send_limit:              u64;
    receive_read:            u64;
    receive_highest:         u64;
    receive_limit:           u64;
    receive_uncredited:      u64;
    final_size:              u64;
    active_attempts:         usize;
    send_error:              u64;
    receive_error:           u64;
    active:                  bool;
    local:                   bool;
    unidirectional:          bool;
    accepted:                bool;
    can_send:                bool;
    can_receive:             bool;
    send_finished:           bool;
    send_closed:             bool;
    send_cancelled:          bool;
    fin_pending:             bool;
    fin_acked:               bool;
    fin_inflight:            u8;
    reset_pending:           bool;
    reset_acked:             bool;
    reset_inflight:          u8;
    receive_closed:          bool;
    receive_cancelled:       bool;
    final_known:             bool;
    reset_received:          bool;
    stop_pending:            bool;
    stop_acked:              bool;
    stop_inflight:           u8;
    stop_received:           bool;
    max_stream_data_pending: bool;
    has_prepared:            bool;
    # news not yet handed to the owner, and the causes of the last short write
    ready_bits:         u8;
    blocked:            u8;
    receive_advertised: u64;
    # send: the chunks written and not yet acknowledged, and the acknowledged
    # intervals above send_base. receive: the chunks holding unread bytes, and
    # the intervals present above receive_read
    send:    Buffer;
    receive: Buffer;
    # the ready queue, oldest stream first, and the list of streams waiting on
    # connection credit or storage, which a single event can release together
    ready_prev:   usize;
    ready_next:   usize;
    blocked_prev: usize;
    blocked_next: usize;
}
```

laid out so RECORDS_PACKED records fit one chunk: flags share one run and
nothing repeats a pointer its chunk already holds

## Ready

```mach
pub rec Ready {
    status:   u8;
    handle:   Handle;
    readable: bool;
    writable: bool;
    reset:    bool;
}
```

## Buffer

```mach
pub rec Buffer {
    chunks: quic.storage.chunks.Chunks;
    ranges: quic.storage.ranges.RangeSet;
}
```

## Attempt

```mach
pub rec Attempt {
    generation:        u64;
    stream_index:      usize;
    stream_generation: u64;
    offset:            u64;
    length:            usize;
    maximum:           u64;
    chunk:             quic.storage.source.Ref;
    kind:              u8;
    state:             u8;
    fin:               bool;
}
```

## Storage

```mach
pub rec Storage {
    streams:           *Stream;
    stream_capacity:   usize;
    attempts:          *Attempt;
    attempt_capacity:  usize;
    chunks:            *quic.storage.source.Provider;
    account:           *quic.storage.source.Account;
    send_buffer_limit: usize;
}
```

streams, attempts: lent for the manager's lifetime, or nil to take them from
                   the pool while they are in use
chunks:            where every stream's bytes come from
account:           whose budget they count against
send_buffer_limit: bytes a stream may hold written and unacknowledged

### lent_records

```mach
pub fun lent_records(storage: Storage) quic.connection.ownership.Range
```

the caller-lent record array, empty when records come from the pool

### lent_attempts

```mach
pub fun lent_attempts(storage: Storage) quic.connection.ownership.Range
```

the caller-lent attempt array, empty when attempts come from the pool

## Manager

```mach
pub rec Manager {
    config:                      Config;
    storage:                     Storage;
    local_bidirectional_opened:  u64;
    local_unidirectional_opened: u64;
    peer_bidirectional_opened:   u64;
    peer_unidirectional_opened:  u64;
    send_committed:              u64;
    receive_committed:           u64;
    send_max_data:               u64;
    receive_max_data:            u64;
    receive_advertised:          u64;
    accept_sequence:             u64;
    active_streams:              usize;
    # peer streams accept has not returned yet
    unaccepted_streams:       usize;
    active_attempts:          usize;
    peer_limits_applied:      bool;
    max_data_pending:         bool;
    max_streams_bidi_pending: bool;
    max_streams_uni_pending:  bool;
    peer_bidi_advertised:     u64;
    peer_uni_advertised:      u64;
    control_prepared:         bool;
    # bumped whenever send work may have appeared outside a core call, so an
    # idle core notices without scanning
    send_revision: u64;
    ready_head:    usize;
    ready_tail:    usize;
    blocked_head:  usize;
    blocked_tail:  usize;
    # acknowledgements that could not be recorded, so their bytes go again
    ack_record_refusals: u64;
    # received frames refused for storage before their packet was acknowledged
    receive_storage_refusals: u64;
    # records and attempts taken from the pool, and how many are in use
    record_blocks: [RECORD_BLOCKS]quic.storage.chunks.Block;
    record_live:   [RECORD_BLOCKS]usize;
    attempt_block: quic.storage.chunks.Block;
    attempts_live: usize;
    # generations are the manager's, so a record or attempt taken again from a
    # fresh chunk never matches a token issued before
    stream_generation:  u64;
    attempt_generation: u64;
    core_lease:         u64;
    valid:              bool;
    closing:            bool;
    # the lent record and attempt ranges, fixed from initialize on
    owned: [2]quic.connection.ownership.Range;
}
```

### initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage) bool
```

### lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool
```

### release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool
```

### attempts_drained

```mach
pub fun attempts_drained(manager: *Manager) bool
```

whether no attempt is reserved or in flight

### handle_at

```mach
pub fun handle_at(manager: *Manager, index: usize) Handle
```

the handle of the live stream at `index`, with source 0 when there is none

### next_ready

```mach
pub fun next_ready(manager: *Manager) Ready
```

hands the owner the oldest stream with news, O(1)

### pending_news

```mach
pub fun pending_news(manager: *Manager) bool
```

whether next_ready or accept has anything to hand the owner, O(1): a stream
with news it has not taken, or a peer stream it has not accepted. it changes
nothing

### storage_released

```mach
pub fun storage_released(manager: *Manager)
```

the pool gave chunks back, so every stream a refused chunk stopped may write

### open

```mach
pub fun open(manager: *Manager, direction: u8) CreateResult
```

### accept

```mach
pub fun accept(manager: *Manager) CreateResult
```

### update_max_data

```mach
pub fun update_max_data(manager: *Manager, maximum: u64) OperationResult
```

### apply_peer_limits

```mach
pub fun apply_peer_limits(manager: *Manager, max_data: u64,
    stream_data_bidi_local: u64,
    stream_data_bidi_remote: u64,
    stream_data_uni: u64, streams_bidi: u64,
    streams_uni: u64) OperationResult
```

binds the peer's authenticated initial transport limits exactly once

### update_max_stream_data

```mach
pub fun update_max_stream_data(manager: *Manager, value: Handle, maximum: u64) OperationResult
```

### receive_max_stream_data

```mach
pub fun receive_max_stream_data(manager: *Manager, id: u64, maximum: u64) ReceiveResult
```

### update_max_streams

```mach
pub fun update_max_streams(manager: *Manager, direction: u8, maximum: u64) OperationResult
```

### write

```mach
pub fun write(manager: *Manager, value: Handle, data: *u8, length: usize) WriteResult
```

### finish

```mach
pub fun finish(manager: *Manager, value: Handle) OperationResult
```

### cancel_send

```mach
pub fun cancel_send(manager: *Manager, value: Handle, error_code: u64) OperationResult
```

### cancel_receive

```mach
pub fun cancel_receive(manager: *Manager, value: Handle, error_code: u64) OperationResult
```

### prepare_control

```mach
pub fun prepare_control(manager: *Manager) Prepared
```

### prepare

```mach
pub fun prepare(manager: *Manager, value: Handle, maximum_bytes: usize, probe: bool) Prepared
```

### cancel_prepared

```mach
pub fun cancel_prepared(manager: *Manager, prepared: Prepared) OperationResult
```

### publish

```mach
pub fun publish(manager: *Manager, prepared: Prepared) OperationResult
```

### on_terminal

```mach
pub fun on_terminal(manager: *Manager, value: AttemptToken, terminal: u8) OperationResult
```

### receive_stream_data_blocked

```mach
pub fun receive_stream_data_blocked(manager: *Manager, id: u64, maximum: u64) ReceiveResult
```

### receive_data_blocked

```mach
pub fun receive_data_blocked(manager: *Manager, maximum: u64) OperationResult
```

### receive_streams_blocked

```mach
pub fun receive_streams_blocked(manager: *Manager, direction: u8, maximum: u64) OperationResult
```

### receive_stream

```mach
pub fun receive_stream(manager: *Manager, id: u64, offset: u64, data: *u8,
    length: usize, fin: bool) ReceiveResult
```

### receive_reset

```mach
pub fun receive_reset(manager: *Manager, id: u64, error_code: u64, final_size: u64) ReceiveResult
```

### acknowledge_reset

```mach
pub fun acknowledge_reset(manager: *Manager, value: Handle) OperationResult
```

### receive_stop

```mach
pub fun receive_stop(manager: *Manager, id: u64, error_code: u64) ReceiveResult
```

### read

```mach
pub fun read(manager: *Manager, value: Handle, output: *u8, capacity: usize) ReadResult
```

### credit

```mach
pub fun credit(manager: *Manager, value: Handle, count: u64) OperationResult
```

### snapshot

```mach
pub fun snapshot(manager: *Manager, value: Handle) Snapshot
```

### release

```mach
pub fun release(manager: *Manager, value: Handle) OperationResult
```

### begin_close

```mach
pub fun begin_close(manager: *Manager) OperationResult
```

### finish_close

```mach
pub fun finish_close(manager: *Manager) OperationResult
```

### apply_peer_limits_scoped

```mach
pub fun apply_peer_limits_scoped(manager: *Manager, source: u64, max_data: u64,
    stream_data_bidi_local: u64,
    stream_data_bidi_remote: u64,
    stream_data_uni: u64, streams_bidi: u64,
    streams_uni: u64) OperationResult
```

### update_max_data_scoped

```mach
pub fun update_max_data_scoped(manager: *Manager, source: u64,
    maximum: u64) OperationResult
```

### receive_max_stream_data_scoped

```mach
pub fun receive_max_stream_data_scoped(manager: *Manager, source: u64,
    id: u64, maximum: u64) ReceiveResult
```

### update_max_streams_scoped

```mach
pub fun update_max_streams_scoped(manager: *Manager, source: u64,
    direction: u8, maximum: u64) OperationResult
```

### prepare_control_scoped

```mach
pub fun prepare_control_scoped(manager: *Manager, source: u64) Prepared
```

### prepare_scoped

```mach
pub fun prepare_scoped(manager: *Manager, source: u64, value: Handle,
    maximum_bytes: usize, probe: bool) Prepared
```

### peek_control_scoped

```mach
pub fun peek_control_scoped(manager: *Manager, source: u64) Prepared
```

what prepare_control_scoped would answer, with no token and nothing
changed. it assumes the attempt's chunk is granted, see attempts_held

### peek_scoped

```mach
pub fun peek_scoped(manager: *Manager, source: u64, value: Handle,
    maximum_bytes: usize, probe: bool) Prepared
```

what prepare_scoped would answer on `value`, with no token and nothing
changed. it assumes the attempt's chunk is granted, see attempts_held

### attempts_held

```mach
pub fun attempts_held(manager: *Manager) bool
```

whether a prepare can claim an attempt without taking a chunk from the pool

### cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(manager: *Manager, source: u64,
    prepared: Prepared) OperationResult
```

### publish_scoped

```mach
pub fun publish_scoped(manager: *Manager, source: u64,
    prepared: Prepared) OperationResult
```

### on_terminal_scoped

```mach
pub fun on_terminal_scoped(manager: *Manager, source: u64,
    value: AttemptToken, terminal: u8) OperationResult
```

### receive_stream_data_blocked_scoped

```mach
pub fun receive_stream_data_blocked_scoped(manager: *Manager, source: u64,
    id: u64,
    maximum: u64) ReceiveResult
```

### receive_data_blocked_scoped

```mach
pub fun receive_data_blocked_scoped(manager: *Manager, source: u64,
    maximum: u64) OperationResult
```

### receive_streams_blocked_scoped

```mach
pub fun receive_streams_blocked_scoped(manager: *Manager, source: u64,
    direction: u8,
    maximum: u64) OperationResult
```

### receive_stream_scoped

```mach
pub fun receive_stream_scoped(manager: *Manager, source: u64, id: u64,
    offset: u64, data: *u8, length: usize,
    fin: bool) ReceiveResult
```

### receive_reset_scoped

```mach
pub fun receive_reset_scoped(manager: *Manager, source: u64, id: u64,
    error_code: u64, final_size: u64) ReceiveResult
```

### receive_stop_scoped

```mach
pub fun receive_stop_scoped(manager: *Manager, source: u64, id: u64,
    error_code: u64) ReceiveResult
```

### begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, source: u64) OperationResult
```

### finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, source: u64) OperationResult
```

## Handle

```mach
pub rec Handle {
    source:     u64;
    index:      usize;
    generation: u64;
    id:         u64;
}
```

## AttemptToken

```mach
pub rec AttemptToken {
    source:     u64;
    index:      usize;
    generation: u64;
}
```

## CreateResult

```mach
pub rec CreateResult {
    status:               u8;
    error:                u8;
    handle:               Handle;
    stream_limit_blocked: bool;
    storage_blocked:      bool;
}
```

## WriteResult

```mach
pub rec WriteResult {
    status:             u8;
    error:              u8;
    count:              usize;
    connection_blocked: bool;
    stream_blocked:     bool;
    storage_blocked:    bool;
}
```

## ReadResult

```mach
pub rec ReadResult {
    status:                  u8;
    error:                   u8;
    count:                   usize;
    final_size:              u64;
    application_error:       u64;
    receive_max_data:        u64;
    receive_max_stream_data: u64;
    receive_uncredited:      u64;
    fin:                     bool;
}
```

## ReceiveResult

```mach
pub rec ReceiveResult {
    ok:                      bool;
    error:                   u8;
    handle:                  Handle;
    new_streams:             usize;
    connection_delta:        u64;
    receive_max_stream_data: u64;
    closed:                  bool;
}
```

## Prepared

```mach
pub rec Prepared {
    ok:                bool;
    status:            u8;
    error:             u8;
    token:             AttemptToken;
    handle:            Handle;
    data:              quic.packet.packet.Span;
    offset:            u64;
    final_size:        u64;
    application_error: u64;
    maximum:           u64;
    kind:              u8;
    fin:               bool;
}
```

## OperationResult

```mach
pub rec OperationResult {
    status:                  u8;
    error:                   u8;
    receive_max_data:        u64;
    receive_max_stream_data: u64;
    peer_max_streams:        u64;
}
```

## Snapshot

```mach
pub rec Snapshot {
    ok:                 bool;
    error:              u8;
    id:                 u64;
    send_offset:        u64;
    receive_offset:     u64;
    final_size:         u64;
    send_error:         u64;
    receive_error:      u64;
    send_closed:        bool;
    receive_closed:     bool;
    send_cancelled:     bool;
    receive_cancelled:  bool;
    final_known:        bool;
    receive_uncredited: u64;
}
```

## Functions

### initiated_by_server

```mach
pub fun initiated_by_server(id: u64) bool
```

### unidirectional

```mach
pub fun unidirectional(id: u64) bool
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ROLE_CLIENT` | `u8` | `1` |  |
| `ROLE_SERVER` | `u8` | `2` |  |
| `DIRECTION_BIDIRECTIONAL` | `u8` | `1` |  |
| `DIRECTION_UNIDIRECTIONAL` | `u8` | `2` |  |
| `SEND_STREAM` | `u8` | `1` |  |
| `SEND_RESET` | `u8` | `2` |  |
| `SEND_STOP` | `u8` | `3` |  |
| `SEND_MAX_DATA` | `u8` | `4` |  |
| `SEND_MAX_STREAM_DATA` | `u8` | `5` |  |
| `SEND_MAX_STREAMS_BIDI` | `u8` | `6` |  |
| `SEND_MAX_STREAMS_UNI` | `u8` | `7` |  |
| `TERMINAL_ACKED` | `u8` | `1` |  |
| `TERMINAL_LOST` | `u8` | `2` |  |
| `STATUS_OK` | `u8` | `1` |  |
| `STATUS_EMPTY` | `u8` | `2` |  |
| `STATUS_BLOCKED` | `u8` | `3` |  |
| `STATUS_RESET` | `u8` | `4` |  |
| `STATUS_FINISHED` | `u8` | `5` |  |
| `STATUS_CANCELLED` | `u8` | `6` |  |
| `STATUS_STALE` | `u8` | `7` |  |
| `STATUS_ERROR` | `u8` | `8` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_STREAM_LIMIT` | `u8` | `2` |  |
| `ERROR_CAPACITY` | `u8` | `3` |  |
| `ERROR_DIRECTION` | `u8` | `4` |  |
| `ERROR_FLOW_CONTROL` | `u8` | `5` |  |
| `ERROR_FINAL_SIZE` | `u8` | `6` |  |
| `ERROR_DATA_CONFLICT` | `u8` | `7` |  |
| `ERROR_TOKEN` | `u8` | `8` |  |
| `ERROR_OVERFLOW` | `u8` | `9` |  |
| `ERROR_CANCELLED` | `u8` | `10` |  |
| `ERROR_STORAGE` | `u8` | `11` | a receive the connection cannot store right now: the caller refuses the packet unacknowledged and the peer retransmits it |
| `RECORDS_PER_BLOCK` | `usize` | `supply.BYTES / $size_of(Stream)` | records and attempts left unlent are taken from the pool a chunk at a time |
| `RECORDS_PACKED` | `usize` | `6` | the six h3 control streams an idle connection keeps open fit in one block |
| `RECORD_BLOCKS` | `usize` | `8` |  |
| `ATTEMPTS_PER_BLOCK` | `usize` | `supply.BYTES / $size_of(Attempt)` |  |
| `READY_READABLE` | `u8` | `1` | news an owner can act on for one stream |
| `READY_WRITABLE` | `u8` | `2` |  |
| `READY_RESET` | `u8` | `4` |  |

