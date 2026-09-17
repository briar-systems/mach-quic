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
pub val NEW:         ConnectionState = 1
```

## val HANDSHAKING

```mach
pub val HANDSHAKING: ConnectionState = 2
```

## val ACTIVE

```mach
pub val ACTIVE:      ConnectionState = 3
```

## val CLOSING

```mach
pub val CLOSING:     ConnectionState = 4
```

## val DRAINING

```mach
pub val DRAINING:    ConnectionState = 5
```

## val CLOSED

```mach
pub val CLOSED:      ConnectionState = 6
```

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK:        Status = 1
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY:     Status = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED:   Status = 3
```

## val STATUS_STALE

```mach
pub val STATUS_STALE:     Status = 4
```

## val STATUS_CANCELLED

```mach
pub val STATUS_CANCELLED: Status = 5
```

## val STATUS_CLOSED

```mach
pub val STATUS_CLOSED:    Status = 6
```

## val STATUS_EARLY

```mach
pub val STATUS_EARLY:     Status = 7
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR:     Status = 8
```

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:      Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:     Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:    Error = 2
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY:  Error = 3
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN:     Error = 4
```

## val ERROR_BUFFER

```mach
pub val ERROR_BUFFER:    Error = 5
```

## val ERROR_TIME

```mach
pub val ERROR_TIME:      Error = 6
```

## val ERROR_PROTOCOL

```mach
pub val ERROR_PROTOCOL:  Error = 7
```

## val ERROR_STREAM

```mach
pub val ERROR_STREAM:    Error = 8
```

## val ERROR_DATAGRAM

```mach
pub val ERROR_DATAGRAM:  Error = 9
```

## val ERROR_CANCELLED

```mach
pub val ERROR_CANCELLED: Error = 10
```

## val ERROR_NATIVE

```mach
pub val ERROR_NATIVE:    Error = 11
```

## def SendStatus

```mach
pub def SendStatus: u8
```

## val SEND_SENT

```mach
pub val SEND_SENT:      SendStatus = 1
```

## val SEND_FAILED

```mach
pub val SEND_FAILED:    SendStatus = 2
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
pub val BIDIRECTIONAL:  Direction = 1
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

a datagram the caller received, read at `received_at` on the monotonic clock

## rec CoreInput

```mach
pub rec CoreInput;
```

the same datagram as a protocol sees it, with time in clock nanoseconds

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

a protocol that refuses a call without changing any state reports
STATUS_ERROR with its current state and names the caller-facing error in
`refusal`. ERROR_NONE there means a protocol failure

## rec CoreDatagram

```mach
pub rec CoreDatagram;
```

## rec Protocol

```mach
pub rec Protocol[T];
```

callbacks are serialized and may not call back into the same driver.

the context is typed rather than an untyped `ptr`. a production protocol
reaches secret-welded state — every connection.core operation takes both the
public record and the Secrets — and mach refuses to erase a secret-welded
pointer to `ptr`, so a vtable with an opaque context can only ever be
implemented by a test double whose context holds no secrets.

`context_range` exists for the same reason: the context's byte range cannot be
taken by casting it, so the provider answers for its own memory, the way
handshake.provider_ranges already does

## rec Cancellation

```mach
pub rec Cancellation;
```

the scope's cancellation callback runs on a foreign thread and is handed an
untyped `ptr`, so it cannot reach a typed protocol at all. it records the
cancellation here and the owner's next call performs the close, on the thread
that owns the protocol. `cancel_connection` stays synchronous because the
owner calls it with the driver already typed

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

## rec ReadyStream

```mach
pub rec ReadyStream;
```

a stream with news for its owner. readable: bytes or a fin can be read.
writable: a short write may now make progress. reset: the peer reset the
stream or asked it to stop sending

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
pub rec Driver[T];
```

## fun default_config

```mach
pub fun default_config(source: u64) Config;
```

## fun init_client

```mach
pub fun init_client[T](driver: *Driver[T], config: Config, protocol: Protocol[T],
streams: *stream_api.Manager, datagrams: *datagram_api.Queue,
scope: *cancel.Scope, storage: Storage) bool;
```

## fun init_server

```mach
pub fun init_server[T](driver: *Driver[T], config: Config, protocol: Protocol[T],
streams: *stream_api.Manager, datagrams: *datagram_api.Queue,
scope: *cancel.Scope, storage: Storage) bool;
```

## fun token_equal

```mach
pub fun token_equal(a: Token, b: Token) bool;
```

## fun receive_datagram

```mach
pub fun receive_datagram[T](driver: *Driver[T], input: *Datagram) OperationResult;
```

## fun receive_native

```mach
pub fun receive_native[T](driver: *Driver[T], packet: *net_types.Packet,
bound_local: ip.Endpoint, received_at: time.Instant, ecn: u8) OperationResult;
```

## fun timer

```mach
pub fun timer[T](driver: *Driver[T]) Timer;
```

## fun on_timeout

```mach
pub fun on_timeout[T](driver: *Driver[T], value: Timer, now: time.Instant) OperationResult;
```

## fun generate

```mach
pub fun generate[T](driver: *Driver[T], scope: *cancel.Scope, buffer: *u8,
capacity: usize, now: time.Instant, context: usize) Generated;
```

## fun complete_send

```mach
pub fun complete_send[T](driver: *Driver[T], token: Token, send_status: SendStatus,
count: usize, now: time.Instant) Completion;
```

settles a datagram the caller sent through its own adapter. one that went
out whole is SEND_SENT with its full length, even if the operation was
cancelled or timed out afterwards, since the peer may acknowledge it

## fun cancel_send

```mach
pub fun cancel_send[T](driver: *Driver[T], token: Token, now: time.Instant) Completion;
```

## fun submit_native

```mach
pub fun submit_native[T](driver: *Driver[T], network: *net_async.Driver, socket: *udp.Socket,
scope: *cancel.Scope, token: Token) res[io_runtime.Token, io_error.Error];
```

## fun complete_native

```mach
pub fun complete_native[T](driver: *Driver[T], native: *io_runtime.Completion,
now: time.Instant) Completion;
```

## fun operation_snapshot

```mach
pub fun operation_snapshot[T](driver: *Driver[T], token: Token) Generated;
```

## fun open_stream

```mach
pub fun open_stream[T](driver: *Driver[T], direction: Direction) OpenResult;
```

## fun ready_stream

```mach
pub fun ready_stream[T](driver: *Driver[T]) ReadyStream;
```

the oldest stream with news since it was last reported, O(1). reports may
repeat or be spurious, never lost. a peer stream is reported only once
accept_stream has returned it

## fun storage_ready

```mach
pub fun storage_ready[T](driver: *Driver[T]);
```

the connection's buffer source woke this connection's account: writes it
refused for storage are reported writable again, and the core retries
whatever it was refused, including a tls call waiting for memory. the caller
then drives the connection as for any other input

## fun accept_stream

```mach
pub fun accept_stream[T](driver: *Driver[T]) OpenResult;
```

## fun write_stream

```mach
pub fun write_stream[T](driver: *Driver[T], value: Stream, data: *u8, length: usize) WriteResult;
```

## fun finish_stream

```mach
pub fun finish_stream[T](driver: *Driver[T], value: Stream) OperationResult;
```

## fun read_stream

```mach
pub fun read_stream[T](driver: *Driver[T], value: Stream, output: *u8, capacity: usize) ReadResult;
```

## fun credit_stream

```mach
pub fun credit_stream[T](driver: *Driver[T], value: Stream, count: u64) OperationResult;
```

## fun cancel_stream_send

```mach
pub fun cancel_stream_send[T](driver: *Driver[T], value: Stream, error_code: u64) OperationResult;
```

## fun cancel_stream_receive

```mach
pub fun cancel_stream_receive[T](driver: *Driver[T], value: Stream, error_code: u64) OperationResult;
```

## fun release_stream

```mach
pub fun release_stream[T](driver: *Driver[T], value: Stream) OperationResult;
```

## fun stream_snapshot

```mach
pub fun stream_snapshot[T](driver: *Driver[T], value: Stream) StreamSnapshot;
```

## fun send_datagram

```mach
pub fun send_datagram[T](driver: *Driver[T], data: *u8, length: usize) DatagramResult;
```

## fun cancel_datagram

```mach
pub fun cancel_datagram[T](driver: *Driver[T], value: DatagramToken) OperationResult;
```

## fun next_datagram

```mach
pub fun next_datagram[T](driver: *Driver[T]) ReceivedDatagram;
```

## fun release_datagram

```mach
pub fun release_datagram[T](driver: *Driver[T], value: DatagramToken) OperationResult;
```

## fun begin_close

```mach
pub fun begin_close[T](driver: *Driver[T], application_error: u64, reason: *u8,
reason_length: usize, now: time.Instant) OperationResult;
```

## fun cancel_connection

```mach
pub fun cancel_connection[T](driver: *Driver[T]) bool;
```

## fun finish_close

```mach
pub fun finish_close[T](driver: *Driver[T]) OperationResult;
```

## fun release_ready

```mach
pub fun release_ready[T](driver: *Driver[T]) bool;
```

a successfully released driver is the only uninitialized terminal state for
which release is idempotent. send-slot generations remain caller-owned so a
delayed token cannot target the next initialization of the same record

## fun release_closed

```mach
pub fun release_closed[T](driver: *Driver[T]) OperationResult;
```

## fun snapshot

```mach
pub fun snapshot[T](driver: *Driver[T]) Snapshot;
```

