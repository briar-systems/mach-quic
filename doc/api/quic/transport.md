# quic.transport

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

## def ConnectionState

```mach
pub def ConnectionState: u8
```

## val NEW

```mach
pub val NEW: ConnectionState = 1
```

## val HANDSHAKING

```mach
pub val HANDSHAKING: ConnectionState = 2
```

## val ACTIVE

```mach
pub val ACTIVE: ConnectionState = 3
```

## val CLOSING

```mach
pub val CLOSING: ConnectionState = 4
```

## val DRAINING

```mach
pub val DRAINING: ConnectionState = 5
```

## val CLOSED

```mach
pub val CLOSED: ConnectionState = 6
```

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK: Status = 1
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY: Status = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: Status = 3
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: Status = 4
```

## val STATUS_CANCELLED

```mach
pub val STATUS_CANCELLED: Status = 5
```

## val STATUS_CLOSED

```mach
pub val STATUS_CLOSED: Status = 6
```

## val STATUS_EARLY

```mach
pub val STATUS_EARLY: Status = 7
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: Status = 8
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

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: Error = 3
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: Error = 4
```

## val ERROR_BUFFER

```mach
pub val ERROR_BUFFER: Error = 5
```

## val ERROR_TIME

```mach
pub val ERROR_TIME: Error = 6
```

## val ERROR_PROTOCOL

```mach
pub val ERROR_PROTOCOL: Error = 7
```

## val ERROR_STREAM

```mach
pub val ERROR_STREAM: Error = 8
```

## val ERROR_DATAGRAM

```mach
pub val ERROR_DATAGRAM: Error = 9
```

## val ERROR_CANCELLED

```mach
pub val ERROR_CANCELLED: Error = 10
```

## val ERROR_NATIVE

```mach
pub val ERROR_NATIVE: Error = 11
```

## def SendStatus

```mach
pub def SendStatus: u8
```

## val SEND_SENT

```mach
pub val SEND_SENT: SendStatus = 1
```

## val SEND_FAILED

```mach
pub val SEND_FAILED: SendStatus = 2
```

## val SEND_CANCELLED

```mach
pub val SEND_CANCELLED: SendStatus = 3
```

## val SEND_TIMED_OUT

```mach
pub val SEND_TIMED_OUT: SendStatus = 4
```

## def Direction

```mach
pub def Direction: u8
```

## val BIDIRECTIONAL

```mach
pub val BIDIRECTIONAL: Direction = 1
```

## val UNIDIRECTIONAL

```mach
pub val UNIDIRECTIONAL: Direction = 2
```

## rec View

```mach
pub rec View;
```

## rec Datagram

```mach
pub rec Datagram;
```

## rec Timer

```mach
pub rec Timer;
```

## rec CoreTimer

```mach
pub rec CoreTimer;
```

## rec CoreResult

```mach
pub rec CoreResult;
```

## rec CoreDatagram

```mach
pub rec CoreDatagram;
```

## def ReceiveFun

```mach
pub def ReceiveFun: fun(ptr, *Datagram) CoreResult
```

## def TimeoutFun

```mach
pub def TimeoutFun: fun(ptr, u64, u64) CoreResult
```

## def GenerateFun

```mach
pub def GenerateFun: fun(ptr, *u8, usize, u64) CoreDatagram
```

## def CompleteSendFun

```mach
pub def CompleteSendFun: fun(ptr, u64, SendStatus, usize, u64) CoreResult
```

## def BeginCloseFun

```mach
pub def BeginCloseFun: fun(ptr, bool, u64, *u8, usize, u64) CoreResult
```

## def CloseReadyFun

```mach
pub def CloseReadyFun: fun(ptr) bool
```

## def FinishCloseFun

```mach
pub def FinishCloseFun: fun(ptr) bool
```

## def TimerFun

```mach
pub def TimerFun: fun(ptr) CoreTimer
```

## rec Protocol

```mach
pub rec Protocol;
```

callbacks are serialized and may not call back into the same driver

## rec Token

```mach
pub rec Token;
```

## rec Generated

```mach
pub rec Generated;
```

## rec Completion

```mach
pub rec Completion;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## rec Stream

```mach
pub rec Stream;
```

## rec OpenResult

```mach
pub rec OpenResult;
```

## rec WriteResult

```mach
pub rec WriteResult;
```

## rec ReadResult

```mach
pub rec ReadResult;
```

## rec StreamSnapshot

```mach
pub rec StreamSnapshot;
```

## rec DatagramToken

```mach
pub rec DatagramToken;
```

## rec DatagramResult

```mach
pub rec DatagramResult;
```

## rec ReceivedDatagram

```mach
pub rec ReceivedDatagram;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## rec Config

```mach
pub rec Config;
```

## rec SendSlot

```mach
pub rec SendSlot;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Driver

```mach
pub rec Driver;
```

## fun default_config

```mach
pub fun default_config(source: u64) Config;
```

## fun init_client

```mach
pub fun init_client(driver: *Driver, config: Config, protocol: Protocol,
streams: *stream_api.Manager, datagrams: *datagram_api.Queue,
scope: *cancel.Scope, storage: Storage) bool;
```

## fun init_server

```mach
pub fun init_server(driver: *Driver, config: Config, protocol: Protocol,
streams: *stream_api.Manager, datagrams: *datagram_api.Queue,
scope: *cancel.Scope, storage: Storage) bool;
```

## fun token_equal

```mach
pub fun token_equal(a: Token, b: Token) bool;
```

## fun receive_datagram

```mach
pub fun receive_datagram(driver: *Driver, input: *Datagram) OperationResult;
```

## fun receive_native

```mach
pub fun receive_native(driver: *Driver, packet: *net_types.Packet,
bound_local: ip.Endpoint, received_at_ns: u64, ecn: u8) OperationResult;
```

## fun timer

```mach
pub fun timer(driver: *Driver) Timer;
```

## fun on_timeout

```mach
pub fun on_timeout(driver: *Driver, value: Timer, now_ns: u64) OperationResult;
```

## fun generate

```mach
pub fun generate(driver: *Driver, scope: *cancel.Scope, buffer: *u8,
capacity: usize, now_ns: u64, context: usize) Generated;
```

## fun complete_send

```mach
pub fun complete_send(driver: *Driver, token: Token, send_status: SendStatus,
count: usize, now_ns: u64) Completion;
```

## fun cancel_send

```mach
pub fun cancel_send(driver: *Driver, token: Token, now_ns: u64) Completion;
```

## fun submit_native

```mach
pub fun submit_native(driver: *Driver, network: *net_async.Driver, socket: *udp.Socket,
scope: *cancel.Scope, token: Token) Result[io_runtime.Token, io_error.Error];
```

## fun complete_native

```mach
pub fun complete_native(driver: *Driver, native: *io_runtime.Completion,
now_ns: u64) Completion;
```

## fun operation_snapshot

```mach
pub fun operation_snapshot(driver: *Driver, token: Token) Generated;
```

## fun open_stream

```mach
pub fun open_stream(driver: *Driver, direction: Direction) OpenResult;
```

## fun accept_stream

```mach
pub fun accept_stream(driver: *Driver) OpenResult;
```

## fun write_stream

```mach
pub fun write_stream(driver: *Driver, value: Stream, data: *u8, length: usize) WriteResult;
```

## fun finish_stream

```mach
pub fun finish_stream(driver: *Driver, value: Stream) OperationResult;
```

## fun read_stream

```mach
pub fun read_stream(driver: *Driver, value: Stream, output: *u8, capacity: usize) ReadResult;
```

## fun credit_stream

```mach
pub fun credit_stream(driver: *Driver, value: Stream, count: u64) OperationResult;
```

## fun cancel_stream_send

```mach
pub fun cancel_stream_send(driver: *Driver, value: Stream, error_code: u64) OperationResult;
```

## fun cancel_stream_receive

```mach
pub fun cancel_stream_receive(driver: *Driver, value: Stream, error_code: u64) OperationResult;
```

## fun release_stream

```mach
pub fun release_stream(driver: *Driver, value: Stream) OperationResult;
```

## fun stream_snapshot

```mach
pub fun stream_snapshot(driver: *Driver, value: Stream) StreamSnapshot;
```

## fun send_datagram

```mach
pub fun send_datagram(driver: *Driver, data: *u8, length: usize) DatagramResult;
```

## fun cancel_datagram

```mach
pub fun cancel_datagram(driver: *Driver, value: DatagramToken) OperationResult;
```

## fun next_datagram

```mach
pub fun next_datagram(driver: *Driver) ReceivedDatagram;
```

## fun release_datagram

```mach
pub fun release_datagram(driver: *Driver, value: DatagramToken) OperationResult;
```

## fun begin_close

```mach
pub fun begin_close(driver: *Driver, application_error: u64, reason: *u8,
reason_length: usize, now_ns: u64) OperationResult;
```

## fun cancel_connection

```mach
pub fun cancel_connection(driver: *Driver) bool;
```

## fun finish_close

```mach
pub fun finish_close(driver: *Driver) OperationResult;
```

## fun snapshot

```mach
pub fun snapshot(driver: *Driver) Snapshot;
```

