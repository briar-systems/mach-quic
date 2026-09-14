# quic.stream.stream

## val ROLE_CLIENT

```mach
pub val ROLE_CLIENT: u8 = 1
```

## val ROLE_SERVER

```mach
pub val ROLE_SERVER: u8 = 2
```

## val DIRECTION_BIDIRECTIONAL

```mach
pub val DIRECTION_BIDIRECTIONAL: u8 = 1
```

## val DIRECTION_UNIDIRECTIONAL

```mach
pub val DIRECTION_UNIDIRECTIONAL: u8 = 2
```

## val SEND_STREAM

```mach
pub val SEND_STREAM: u8 = 1
```

## val SEND_RESET

```mach
pub val SEND_RESET: u8 = 2
```

## val SEND_STOP

```mach
pub val SEND_STOP: u8 = 3
```

## val SEND_MAX_DATA

```mach
pub val SEND_MAX_DATA: u8 = 4
```

## val SEND_MAX_STREAM_DATA

```mach
pub val SEND_MAX_STREAM_DATA: u8 = 5
```

## val SEND_MAX_STREAMS_BIDI

```mach
pub val SEND_MAX_STREAMS_BIDI: u8 = 6
```

## val SEND_MAX_STREAMS_UNI

```mach
pub val SEND_MAX_STREAMS_UNI: u8 = 7
```

## val TERMINAL_ACKED

```mach
pub val TERMINAL_ACKED: u8 = 1
```

## val TERMINAL_LOST

```mach
pub val TERMINAL_LOST: u8 = 2
```

## val STATUS_OK

```mach
pub val STATUS_OK: u8 = 1
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY: u8 = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: u8 = 3
```

## val STATUS_RESET

```mach
pub val STATUS_RESET: u8 = 4
```

## val STATUS_FINISHED

```mach
pub val STATUS_FINISHED: u8 = 5
```

## val STATUS_CANCELLED

```mach
pub val STATUS_CANCELLED: u8 = 6
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: u8 = 7
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: u8 = 8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE: u8 = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE: u8 = 1
```

## val ERROR_STREAM_LIMIT

```mach
pub val ERROR_STREAM_LIMIT: u8 = 2
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: u8 = 3
```

## val ERROR_DIRECTION

```mach
pub val ERROR_DIRECTION: u8 = 4
```

## val ERROR_FLOW_CONTROL

```mach
pub val ERROR_FLOW_CONTROL: u8 = 5
```

## val ERROR_FINAL_SIZE

```mach
pub val ERROR_FINAL_SIZE: u8 = 6
```

## val ERROR_DATA_CONFLICT

```mach
pub val ERROR_DATA_CONFLICT: u8 = 7
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: u8 = 8
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: u8 = 9
```

## val ERROR_CANCELLED

```mach
pub val ERROR_CANCELLED: u8 = 10
```

## rec Config

```mach
pub rec Config;
```

## rec Stream

```mach
pub rec Stream;
```

## rec Attempt

```mach
pub rec Attempt;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Manager

```mach
pub rec Manager;
```

## rec Handle

```mach
pub rec Handle;
```

## rec AttemptToken

```mach
pub rec AttemptToken;
```

## rec CreateResult

```mach
pub rec CreateResult;
```

## rec WriteResult

```mach
pub rec WriteResult;
```

## rec ReadResult

```mach
pub rec ReadResult;
```

## rec ReceiveResult

```mach
pub rec ReceiveResult;
```

## rec Prepared

```mach
pub rec Prepared;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun initiated_by_server

```mach
pub fun initiated_by_server(id: u64) bool;
```

## fun unidirectional

```mach
pub fun unidirectional(id: u64) bool;
```

## fun initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage) bool;
```

## fun lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool;
```

## fun release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool;
```

## fun open

```mach
pub fun open(manager: *Manager, direction: u8) CreateResult;
```

## fun accept

```mach
pub fun accept(manager: *Manager) CreateResult;
```

## fun update_max_data

```mach
pub fun update_max_data(manager: *Manager, maximum: u64) OperationResult;
```

## fun apply_peer_limits

```mach
pub fun apply_peer_limits(manager: *Manager, max_data: u64,
stream_data_bidi_local: u64,
stream_data_bidi_remote: u64,
stream_data_uni: u64, streams_bidi: u64,
streams_uni: u64) OperationResult;
```

binds the peer's authenticated initial transport limits exactly once

## fun update_max_stream_data

```mach
pub fun update_max_stream_data(manager: *Manager, value: Handle, maximum: u64) OperationResult;
```

## fun receive_max_stream_data

```mach
pub fun receive_max_stream_data(manager: *Manager, id: u64, maximum: u64) ReceiveResult;
```

## fun update_max_streams

```mach
pub fun update_max_streams(manager: *Manager, direction: u8, maximum: u64) OperationResult;
```

## fun write

```mach
pub fun write(manager: *Manager, value: Handle, data: *u8, length: usize) WriteResult;
```

## fun finish

```mach
pub fun finish(manager: *Manager, value: Handle) OperationResult;
```

## fun cancel_send

```mach
pub fun cancel_send(manager: *Manager, value: Handle, error_code: u64) OperationResult;
```

## fun cancel_receive

```mach
pub fun cancel_receive(manager: *Manager, value: Handle, error_code: u64) OperationResult;
```

## fun prepare_control

```mach
pub fun prepare_control(manager: *Manager) Prepared;
```

## fun prepare

```mach
pub fun prepare(manager: *Manager, value: Handle, maximum_bytes: usize, probe: bool) Prepared;
```

## fun cancel_prepared

```mach
pub fun cancel_prepared(manager: *Manager, prepared: Prepared) OperationResult;
```

## fun publish

```mach
pub fun publish(manager: *Manager, prepared: Prepared) OperationResult;
```

## fun on_terminal

```mach
pub fun on_terminal(manager: *Manager, value: AttemptToken, terminal: u8) OperationResult;
```

## fun receive_stream_data_blocked

```mach
pub fun receive_stream_data_blocked(manager: *Manager, id: u64, maximum: u64) ReceiveResult;
```

## fun receive_data_blocked

```mach
pub fun receive_data_blocked(manager: *Manager, maximum: u64) OperationResult;
```

## fun receive_streams_blocked

```mach
pub fun receive_streams_blocked(manager: *Manager, direction: u8, maximum: u64) OperationResult;
```

## fun receive_stream

```mach
pub fun receive_stream(manager: *Manager, id: u64, offset: u64, data: *u8,
length: usize, fin: bool) ReceiveResult;
```

## fun receive_reset

```mach
pub fun receive_reset(manager: *Manager, id: u64, error_code: u64, final_size: u64) ReceiveResult;
```

## fun acknowledge_reset

```mach
pub fun acknowledge_reset(manager: *Manager, value: Handle) OperationResult;
```

## fun receive_stop

```mach
pub fun receive_stop(manager: *Manager, id: u64, error_code: u64) ReceiveResult;
```

## fun read

```mach
pub fun read(manager: *Manager, value: Handle, output: *u8, capacity: usize) ReadResult;
```

## fun credit

```mach
pub fun credit(manager: *Manager, value: Handle, count: u64) OperationResult;
```

## fun snapshot

```mach
pub fun snapshot(manager: *Manager, value: Handle) Snapshot;
```

## fun release

```mach
pub fun release(manager: *Manager, value: Handle) OperationResult;
```

## fun begin_close

```mach
pub fun begin_close(manager: *Manager) OperationResult;
```

## fun finish_close

```mach
pub fun finish_close(manager: *Manager) OperationResult;
```

## fun apply_peer_limits_scoped

```mach
pub fun apply_peer_limits_scoped(manager: *Manager, source: u64, max_data: u64,
stream_data_bidi_local: u64,
stream_data_bidi_remote: u64,
stream_data_uni: u64, streams_bidi: u64,
streams_uni: u64) OperationResult;
```

## fun update_max_data_scoped

```mach
pub fun update_max_data_scoped(manager: *Manager, source: u64,
maximum: u64) OperationResult;
```

## fun receive_max_stream_data_scoped

```mach
pub fun receive_max_stream_data_scoped(manager: *Manager, source: u64,
id: u64, maximum: u64) ReceiveResult;
```

## fun update_max_streams_scoped

```mach
pub fun update_max_streams_scoped(manager: *Manager, source: u64,
direction: u8, maximum: u64) OperationResult;
```

## fun prepare_control_scoped

```mach
pub fun prepare_control_scoped(manager: *Manager, source: u64) Prepared;
```

## fun prepare_scoped

```mach
pub fun prepare_scoped(manager: *Manager, source: u64, value: Handle,
maximum_bytes: usize, probe: bool) Prepared;
```

## fun cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(manager: *Manager, source: u64,
prepared: Prepared) OperationResult;
```

## fun publish_scoped

```mach
pub fun publish_scoped(manager: *Manager, source: u64,
prepared: Prepared) OperationResult;
```

## fun on_terminal_scoped

```mach
pub fun on_terminal_scoped(manager: *Manager, source: u64,
value: AttemptToken, terminal: u8) OperationResult;
```

## fun receive_stream_data_blocked_scoped

```mach
pub fun receive_stream_data_blocked_scoped(manager: *Manager, source: u64,
id: u64,
maximum: u64) ReceiveResult;
```

## fun receive_data_blocked_scoped

```mach
pub fun receive_data_blocked_scoped(manager: *Manager, source: u64,
maximum: u64) OperationResult;
```

## fun receive_streams_blocked_scoped

```mach
pub fun receive_streams_blocked_scoped(manager: *Manager, source: u64,
direction: u8,
maximum: u64) OperationResult;
```

## fun receive_stream_scoped

```mach
pub fun receive_stream_scoped(manager: *Manager, source: u64, id: u64,
offset: u64, data: *u8, length: usize,
fin: bool) ReceiveResult;
```

## fun receive_reset_scoped

```mach
pub fun receive_reset_scoped(manager: *Manager, source: u64, id: u64,
error_code: u64, final_size: u64) ReceiveResult;
```

## fun receive_stop_scoped

```mach
pub fun receive_stop_scoped(manager: *Manager, source: u64, id: u64,
error_code: u64) ReceiveResult;
```

## fun begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, source: u64) OperationResult;
```

## fun finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, source: u64) OperationResult;
```

