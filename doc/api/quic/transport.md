[quic](README.md) / **transport**

# quic.transport

bounded public quic connection driver

Source: [`src/transport.mach`](../../../src/transport.mach)

Uses types from [`quic.connection.ownership`](connection/ownership.md), [`quic.stream.datagram`](stream/datagram.md), [`quic.stream.stream`](stream/stream.md).

| Type | | |
| :--- | :--- | :--- |
| [`Role`](#role) | `def` |  |
| [`ConnectionState`](#connectionstate) | `def` |  |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`SendStatus`](#sendstatus) | `def` |  |
| [`Direction`](#direction) | `def` |  |
| [`View`](#view) | `rec` |  |
| [`Datagram`](#datagram) | `rec` | a datagram the caller received, read at `received_at` on the monotonic clock |
| [`CoreInput`](#coreinput) | `rec` | the same datagram as a protocol sees it, with time in clock nanoseconds |
| [`Timer`](#timer) | `rec` |  |
| [`CoreTimer`](#coretimer) | `rec` |  |
| [`CoreResult`](#coreresult) | `rec` | a protocol that refuses a call without changing any state reports STATUS_ERROR with its current state and names the caller-facing error in `refusal` |
| [`CoreDatagram`](#coredatagram) | `rec` |  |
| [`Protocol`](#protocol) | `rec` | callbacks are serialized and may not call back into the same driver |
| [`Cancellation`](#cancellation) | `rec` | the scope's cancellation callback runs on a foreign thread and is handed an untyped `ptr`, so it cannot reach a typed protocol at all |
| [`Token`](#token) | `rec` |  |
| [`Generated`](#generated) | `rec` |  |
| [`Completion`](#completion) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |
| [`Stream`](#stream) | `rec` |  |
| [`ReadyStream`](#readystream) | `rec` | a stream with news for its owner |
| [`OpenResult`](#openresult) | `rec` |  |
| [`WriteResult`](#writeresult) | `rec` |  |
| [`ReadResult`](#readresult) | `rec` |  |
| [`StreamSnapshot`](#streamsnapshot) | `rec` |  |
| [`DatagramToken`](#datagramtoken) | `rec` |  |
| [`DatagramResult`](#datagramresult) | `rec` |  |
| [`ReceivedDatagram`](#receiveddatagram) | `rec` |  |
| [`Snapshot`](#snapshot) | `rec` |  |
| [`Config`](#config) | `rec` |  |
| [`SendSlot`](#sendslot) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`Driver`](#driver) | `rec` |  |

| On `Role` | |
| :--- | :--- |
| [`CLIENT`](#role), [`SERVER`](#role) | |

| On `ConnectionState` | |
| :--- | :--- |
| [`NEW`](#connectionstate), [`HANDSHAKING`](#connectionstate), [`ACTIVE`](#connectionstate), [`CLOSING`](#connectionstate), [`DRAINING`](#connectionstate), [`CLOSED`](#connectionstate) | |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_EMPTY`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_STALE`](#status), [`STATUS_CANCELLED`](#status), [`STATUS_CLOSED`](#status), [`STATUS_EARLY`](#status), [`STATUS_ERROR`](#status) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_CAPACITY`](#error), [`ERROR_TOKEN`](#error), [`ERROR_BUFFER`](#error), [`ERROR_TIME`](#error), [`ERROR_PROTOCOL`](#error), [`ERROR_STREAM`](#error), [`ERROR_DATAGRAM`](#error), [`ERROR_CANCELLED`](#error), [`ERROR_NATIVE`](#error) | |

| On `SendStatus` | |
| :--- | :--- |
| [`SEND_SENT`](#sendstatus), [`SEND_FAILED`](#sendstatus), [`SEND_CANCELLED`](#sendstatus), [`SEND_TIMED_OUT`](#sendstatus) | |

| On `Direction` | |
| :--- | :--- |
| [`BIDIRECTIONAL`](#direction), [`UNIDIRECTIONAL`](#direction) | |

| On `Token` | |
| :--- | :--- |
| [`token_equal`](#token_equal) | |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config) | |

| On `Driver` | |
| :--- | :--- |
| [`init_client`](#init_client), [`init_server`](#init_server), [`receive_datagram`](#receive_datagram), [`receive_native`](#receive_native), [`timer`](#timer-1), [`on_timeout`](#on_timeout), [`generate`](#generate) | |
| [`complete_send`](#complete_send) | settles a datagram the caller sent through its own adapter |
| [`cancel_send`](#cancel_send), [`submit_native`](#submit_native), [`complete_native`](#complete_native), [`operation_snapshot`](#operation_snapshot), [`open_stream`](#open_stream) | |
| [`ready_stream`](#ready_stream) | the oldest stream with news since it was last reported, O(1) |
| [`storage_ready`](#storage_ready) | the connection's buffer source woke this connection's account: writes it refused for storage are reported writable again, and the core retries whatever it was refused, including a tls call waiting for memory |
| [`accept_stream`](#accept_stream), [`write_stream`](#write_stream), [`finish_stream`](#finish_stream), [`read_stream`](#read_stream), [`credit_stream`](#credit_stream), [`cancel_stream_send`](#cancel_stream_send), [`cancel_stream_receive`](#cancel_stream_receive), [`release_stream`](#release_stream), [`stream_snapshot`](#stream_snapshot), [`send_datagram`](#send_datagram), [`cancel_datagram`](#cancel_datagram), [`next_datagram`](#next_datagram), [`release_datagram`](#release_datagram), [`begin_close`](#begin_close), [`cancel_connection`](#cancel_connection), [`finish_close`](#finish_close) | |
| [`release_ready`](#release_ready) | a successfully released driver is the only uninitialized terminal state for which release is idempotent |
| [`release_closed`](#release_closed), [`snapshot`](#snapshot-1) | |
| [`pending_output`](#pending_output) | whether generate at `now` would produce a datagram, answered with nothing changed and nothing allocated, for a buffer of at least the connection's maximum UDP payload |
| [`pending_stream_news`](#pending_stream_news) | whether ready_stream or accept_stream has anything to hand the owner: a stream with data, a fin, a reset or a flow-control opening it has not taken, or a peer stream it has not accepted |

---

## Role

```mach
pub def Role: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `CLIENT` | `1` |  |
| `SERVER` | `2` |  |

## ConnectionState

```mach
pub def ConnectionState: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `NEW` | `1` |  |
| `HANDSHAKING` | `2` |  |
| `ACTIVE` | `3` |  |
| `CLOSING` | `4` |  |
| `DRAINING` | `5` |  |
| `CLOSED` | `6` |  |

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_EMPTY` | `2` |  |
| `STATUS_BLOCKED` | `3` |  |
| `STATUS_STALE` | `4` |  |
| `STATUS_CANCELLED` | `5` |  |
| `STATUS_CLOSED` | `6` |  |
| `STATUS_EARLY` | `7` |  |
| `STATUS_ERROR` | `8` |  |

## Error

```mach
pub def Error: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ERROR_NONE` | `0` |  |
| `ERROR_STATE` | `1` |  |
| `ERROR_CONFIG` | `2` |  |
| `ERROR_CAPACITY` | `3` |  |
| `ERROR_TOKEN` | `4` |  |
| `ERROR_BUFFER` | `5` |  |
| `ERROR_TIME` | `6` |  |
| `ERROR_PROTOCOL` | `7` |  |
| `ERROR_STREAM` | `8` |  |
| `ERROR_DATAGRAM` | `9` |  |
| `ERROR_CANCELLED` | `10` |  |
| `ERROR_NATIVE` | `11` |  |

## SendStatus

```mach
pub def SendStatus: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `SEND_SENT` | `1` |  |
| `SEND_FAILED` | `2` |  |
| `SEND_CANCELLED` | `3` |  |
| `SEND_TIMED_OUT` | `4` |  |

## Direction

```mach
pub def Direction: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `BIDIRECTIONAL` | `1` |  |
| `UNIDIRECTIONAL` | `2` |  |

## View

```mach
pub rec View { data: *u8; length: usize; }
```

## Datagram

```mach
pub rec Datagram {
    local:       std.net.ip.Endpoint;
    peer:        std.net.ip.Endpoint;
    data:        *u8;
    length:      usize;
    received_at: std.chrono.time.Instant;
    ecn:         u8;
}
```

a datagram the caller received, read at `received_at` on the monotonic clock

## CoreInput

```mach
pub rec CoreInput {
    local:          std.net.ip.Endpoint;
    peer:           std.net.ip.Endpoint;
    data:           *u8;
    length:         usize;
    received_at_ns: u64;
    ecn:            u8;
}
```

the same datagram as a protocol sees it, with time in clock nanoseconds

## Timer

```mach
pub rec Timer     { source: u64; deadline: std.chrono.time.Instant; generation: u64; armed: bool; }
```

## CoreTimer

```mach
pub rec CoreTimer { deadline_ns: u64; generation: u64; armed: bool; }
```

## CoreResult

```mach
pub rec CoreResult {
    status:         Status;
    error:          u64;
    provider_error: u64;
    state:          ConnectionState;
    refusal:        Error;
}
```

a protocol that refuses a call without changing any state reports
STATUS_ERROR with its current state and names the caller-facing error in
`refusal`. ERROR_NONE there means a protocol failure

## CoreDatagram

```mach
pub rec CoreDatagram {
    status:                Status;
    error:                 u64;
    provider_error:        u64;
    state:                 ConnectionState;
    local:                 std.net.ip.Endpoint;
    peer:                  std.net.ip.Endpoint;
    local_destination:     std.net.ip.Addr;
    interface_index:       u32;
    count:                 usize;
    owner:                 u64;
    ecn:                   u8;
    has_local_destination: bool;
    refusal:               Error;
}
```

## Protocol

```mach
pub rec Protocol[T] {
    context:       *T;
    context_range: fun(*T) quic.connection.ownership.Range;
    receive:       fun(*T, *CoreInput) CoreResult;
    timeout:       fun(*T, u64, u64) CoreResult;
    generate:      fun(*T, *u8, usize, u64) CoreDatagram;
    complete_send: fun(*T, u64, SendStatus, usize, u64) CoreResult;
    begin_close:   fun(*T, bool, u64, *u8, usize, u64) CoreResult;
    close_ready:   fun(*T) bool;
    finish_close:  fun(*T) bool;
    timer:         fun(*T) CoreTimer;
    # the connection's account woke. memory the core was refused is tried again
    storage_ready: fun(*T);
    # whether the next generate at this instant would produce a datagram, with
    # nothing changed. see pending_output
    pending_output: fun(*T, u64) bool;
}
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

## Cancellation

```mach
pub rec Cancellation {
    registration: std.sync.cancel.Registration;
    pending:      i64;
    reason:       i64;
    attached:     bool;
}
```

the scope's cancellation callback runs on a foreign thread and is handed an
untyped `ptr`, so it cannot reach a typed protocol at all. it records the
cancellation here and the owner's next call performs the close, on the thread
that owns the protocol. `cancel_connection` stays synchronous because the
owner calls it with the driver already typed

## Token

```mach
pub rec Token { source: u64; index: u32; generation: u64; }
```

### token_equal

```mach
pub fun token_equal(a: Token, b: Token) bool
```

## Generated

```mach
pub rec Generated {
    status:                Status;
    error:                 Error;
    protocol_error:        u64;
    provider_error:        u64;
    token:                 Token;
    local:                 std.net.ip.Endpoint;
    peer:                  std.net.ip.Endpoint;
    local_destination:     std.net.ip.Addr;
    interface_index:       u32;
    buffer:                *u8;
    count:                 usize;
    context:               usize;
    ecn:                   u8;
    has_local_destination: bool;
}
```

## Completion

```mach
pub rec Completion {
    status:         Status;
    error:          Error;
    protocol_error: u64;
    provider_error: u64;
    token:          Token;
    send_status:    SendStatus;
    count:          usize;
    context:        usize;
}
```

## OperationResult

```mach
pub rec OperationResult {
    status:         Status;
    error:          Error;
    protocol_error: u64;
    provider_error: u64;
    state:          ConnectionState;
}
```

## Stream

```mach
pub rec Stream { source: u64; index: usize; generation: u64; id: u64; }
```

## ReadyStream

```mach
pub rec ReadyStream {
    status:   Status;
    error:    Error;
    stream:   Stream;
    readable: bool;
    writable: bool;
    reset:    bool;
}
```

a stream with news for its owner. readable: bytes or a fin can be read.
writable: a short write may now make progress. reset: the peer reset the
stream or asked it to stop sending

## OpenResult

```mach
pub rec OpenResult {
    status:               Status;
    error:                Error;
    detail:               u8;
    stream:               Stream;
    stream_limit_blocked: bool;
    storage_blocked:      bool;
}
```

## WriteResult

```mach
pub rec WriteResult {
    status:             Status;
    error:              Error;
    detail:             u8;
    count:              usize;
    connection_blocked: bool;
    stream_blocked:     bool;
    storage_blocked:    bool;
}
```

## ReadResult

```mach
pub rec ReadResult {
    status:                  Status;
    error:                   Error;
    detail:                  u8;
    count:                   usize;
    final_size:              u64;
    application_error:       u64;
    receive_max_data:        u64;
    receive_max_stream_data: u64;
    receive_uncredited:      u64;
    fin:                     bool;
}
```

## StreamSnapshot

```mach
pub rec StreamSnapshot {
    status:             Status;
    error:              Error;
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

## DatagramToken

```mach
pub rec DatagramToken { source: u64; index: usize; generation: u64; }
```

## DatagramResult

```mach
pub rec DatagramResult {
    status: Status;
    error:  Error;
    detail: u8;
    token:  DatagramToken;
}
```

## ReceivedDatagram

```mach
pub rec ReceivedDatagram {
    status: Status;
    error:  Error;
    detail: u8;
    token:  DatagramToken;
    data:   View;
}
```

## Snapshot

```mach
pub rec Snapshot {
    source:              u64;
    role:                Role;
    state:               ConnectionState;
    close_mode:          std.io.lifecycle.Mode;
    close_cause:         std.io.lifecycle.Cause;
    terminal_cause:      std.io.lifecycle.Cause;
    cancellation_reason: std.sync.cancel.Reason;
    application_error:   u64;
    active_streams:      usize;
    pending_sends:       usize;
    queued_datagrams:    usize;
    received_datagrams:  usize;
    initialized:         bool;
}
```

## Config

```mach
pub rec Config { source: u64; max_udp_payload: usize; max_close_reason: usize; }
```

### default_config

```mach
pub fun default_config(source: u64) Config
```

## SendSlot

```mach
pub rec SendSlot {
    state:        u8;
    generation:   u64;
    token:        Token;
    buffer:       *u8;
    capacity:     usize;
    length:       usize;
    context:      usize;
    owner:        u64;
    packet:       std.net.async.types.Packet;
    native_token: std.io.runtime.Token;
    # the buffer's range, set when the slot is claimed
    range: quic.connection.ownership.Range;
}
```

## Storage

```mach
pub rec Storage { sends: *SendSlot; send_capacity: usize; }
```

## Driver

```mach
pub rec Driver[T] {
    cancellation:        Cancellation;
    config:              Config;
    protocol:            Protocol[T];
    streams:             *quic.stream.stream.Manager;
    datagrams:           *quic.stream.datagram.Queue;
    operation_scope:     *std.sync.cancel.Scope;
    storage:             Storage;
    state:               ConnectionState;
    role:                Role;
    next_slot:           usize;
    pending_sends:       usize;
    cancellation_calls:  usize;
    last_now_ns:         u64;
    application_error:   u64;
    close_mode:          std.io.lifecycle.Mode;
    close_cause:         std.io.lifecycle.Cause;
    terminal_cause:      std.io.lifecycle.Cause;
    cancellation_reason: std.sync.cancel.Reason;
    callback_owner:      std.sync.thread.Token;
    lock:                std.sync.mutex.Mutex;
    initialized:         bool;
    released:            bool;
    closing:             bool;
    # fill_owned's ranges, the scope's emptied once finish_close hands it back
    owned: [OWNED_RANGES]quic.connection.ownership.Range;
}
```

### init_client

```mach
pub fun init_client[T](driver: *Driver[T], config: Config, protocol: Protocol[T],
    streams: *quic.stream.stream.Manager, datagrams: *quic.stream.datagram.Queue,
    scope: *std.sync.cancel.Scope, storage: Storage) bool
```

### init_server

```mach
pub fun init_server[T](driver: *Driver[T], config: Config, protocol: Protocol[T],
    streams: *quic.stream.stream.Manager, datagrams: *quic.stream.datagram.Queue,
    scope: *std.sync.cancel.Scope, storage: Storage) bool
```

### receive_datagram

```mach
pub fun receive_datagram[T](driver: *Driver[T], input: *Datagram) OperationResult
```

### receive_native

```mach
pub fun receive_native[T](driver: *Driver[T], packet: *std.net.async.types.Packet,
    bound_local: std.net.ip.Endpoint, received_at: std.chrono.time.Instant, ecn: u8) OperationResult
```

### timer

```mach
pub fun timer[T](driver: *Driver[T]) Timer
```

### on_timeout

```mach
pub fun on_timeout[T](driver: *Driver[T], value: Timer, now: std.chrono.time.Instant) OperationResult
```

### generate

```mach
pub fun generate[T](driver: *Driver[T], scope: *std.sync.cancel.Scope, buffer: *u8,
    capacity: usize, now: std.chrono.time.Instant, context: usize) Generated
```

### complete_send

```mach
pub fun complete_send[T](driver: *Driver[T], token: Token, send_status: SendStatus,
    count: usize, now: std.chrono.time.Instant) Completion
```

settles a datagram the caller sent through its own adapter. one that went
out whole is SEND_SENT with its full length, even if the operation was
cancelled or timed out afterwards, since the peer may acknowledge it

### cancel_send

```mach
pub fun cancel_send[T](driver: *Driver[T], token: Token, now: std.chrono.time.Instant) Completion
```

### submit_native

```mach
pub fun submit_native[T](driver: *Driver[T], network: *std.net.async.Driver, socket: *std.net.udp.Socket,
    scope: *std.sync.cancel.Scope, token: Token) res[std.io.runtime.Token, std.io.error.Error]
```

### complete_native

```mach
pub fun complete_native[T](driver: *Driver[T], native: *std.io.runtime.Completion,
    now: std.chrono.time.Instant) Completion
```

### operation_snapshot

```mach
pub fun operation_snapshot[T](driver: *Driver[T], token: Token) Generated
```

### open_stream

```mach
pub fun open_stream[T](driver: *Driver[T], direction: Direction) OpenResult
```

### ready_stream

```mach
pub fun ready_stream[T](driver: *Driver[T]) ReadyStream
```

the oldest stream with news since it was last reported, O(1). reports may
repeat or be spurious, never lost. a peer stream is reported only once
accept_stream has returned it

### storage_ready

```mach
pub fun storage_ready[T](driver: *Driver[T])
```

the connection's buffer source woke this connection's account: writes it
refused for storage are reported writable again, and the core retries
whatever it was refused, including a tls call waiting for memory. the caller
then drives the connection as for any other input

### accept_stream

```mach
pub fun accept_stream[T](driver: *Driver[T]) OpenResult
```

### write_stream

```mach
pub fun write_stream[T](driver: *Driver[T], value: Stream, data: *u8, length: usize) WriteResult
```

### finish_stream

```mach
pub fun finish_stream[T](driver: *Driver[T], value: Stream) OperationResult
```

### read_stream

```mach
pub fun read_stream[T](driver: *Driver[T], value: Stream, output: *u8, capacity: usize) ReadResult
```

### credit_stream

```mach
pub fun credit_stream[T](driver: *Driver[T], value: Stream, count: u64) OperationResult
```

### cancel_stream_send

```mach
pub fun cancel_stream_send[T](driver: *Driver[T], value: Stream, error_code: u64) OperationResult
```

### cancel_stream_receive

```mach
pub fun cancel_stream_receive[T](driver: *Driver[T], value: Stream, error_code: u64) OperationResult
```

### release_stream

```mach
pub fun release_stream[T](driver: *Driver[T], value: Stream) OperationResult
```

### stream_snapshot

```mach
pub fun stream_snapshot[T](driver: *Driver[T], value: Stream) StreamSnapshot
```

### send_datagram

```mach
pub fun send_datagram[T](driver: *Driver[T], data: *u8, length: usize) DatagramResult
```

### cancel_datagram

```mach
pub fun cancel_datagram[T](driver: *Driver[T], value: DatagramToken) OperationResult
```

### next_datagram

```mach
pub fun next_datagram[T](driver: *Driver[T]) ReceivedDatagram
```

### release_datagram

```mach
pub fun release_datagram[T](driver: *Driver[T], value: DatagramToken) OperationResult
```

### begin_close

```mach
pub fun begin_close[T](driver: *Driver[T], application_error: u64, reason: *u8,
    reason_length: usize, now: std.chrono.time.Instant) OperationResult
```

### cancel_connection

```mach
pub fun cancel_connection[T](driver: *Driver[T]) bool
```

### finish_close

```mach
pub fun finish_close[T](driver: *Driver[T]) OperationResult
```

### release_ready

```mach
pub fun release_ready[T](driver: *Driver[T]) bool
```

a successfully released driver is the only uninitialized terminal state for
which release is idempotent. send-slot generations remain caller-owned so a
delayed token cannot target the next initialization of the same record

### release_closed

```mach
pub fun release_closed[T](driver: *Driver[T]) OperationResult
```

### snapshot

```mach
pub fun snapshot[T](driver: *Driver[T]) Snapshot
```

### pending_output

```mach
pub fun pending_output[T](driver: *Driver[T], now: std.chrono.time.Instant) bool
```

whether generate at `now` would produce a datagram, answered with nothing
changed and nothing allocated, for a buffer of at least the connection's
maximum UDP payload. a host's audit uses it to find a connection that holds
output nobody will generate.

false for a closed or abortively closing driver, a scope no longer active,
a time before the driver's last call, or no free send slot, where generate
answers without a datagram. true for a cancellation recorded but not yet
applied: the next call applies it, an abortive close the host must give the
connection a turn for, though the generate that applies it sends nothing.
otherwise the protocol answers, and connection.core's answer is exact but
for its two documented edges, pending handshake work and a standing pool
refusal

### pending_stream_news

```mach
pub fun pending_stream_news[T](driver: *Driver[T]) bool
```

whether ready_stream or accept_stream has anything to hand the owner: a
stream with data, a fin, a reset or a flow-control opening it has not taken,
or a peer stream it has not accepted. O(1), with nothing changed

