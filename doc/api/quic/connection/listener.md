[quic](../README.md) / [connection](README.md) / **listener**

# quic.connection.listener

stateless server preflight and pre-allocation admission

pending initials live in a directory that grows with what is in flight and
is released with the listener

Source: [`src/connection/listener.mach`](../../../../src/connection/listener.mach)

Uses types from [`quic.connection.admission`](admission.md), [`quic.connection.token`](token.md), [`quic.packet.packet`](../packet/packet.md), [`quic.storage.slots`](../storage/slots.md).

| Type | | |
| :--- | :--- | :--- |
| [`Action`](#action) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`DatagramClass`](#datagramclass) | `def` |  |
| [`ConnectionId`](#connectionid) | `rec` |  |
| [`ClassifiedDatagram`](#classifieddatagram) | `rec` | one received datagram as the socket owner sees it before admission |
| [`CleanupStatus`](#cleanupstatus) | `def` |  |
| [`Config`](#config) | `rec` |  |
| [`Pending`](#pending) | `rec` |  |
| [`Listener`](#listener) | `rec` |  |
| [`Request`](#request) | `rec` |  |
| [`Acceptance`](#acceptance) | `rec` |  |
| [`LeaseHandle`](#leasehandle) | `rec` |  |
| [`LeaseCleanupResult`](#leasecleanupresult) | `rec` |  |
| [`InitializeResult`](#initializeresult) | `rec` |  |
| [`CleanupResult`](#cleanupresult) | `rec` |  |
| [`Result`](#result) | `rec` |  |
| [`Accepted`](#accepted) | `rec` |  |

| On `Action` | |
| :--- | :--- |
| [`ACTION_ACCEPT`](#action), [`ACTION_RETRY`](#action), [`ACTION_VERSION_NEGOTIATION`](#action), [`ACTION_DROP`](#action), [`ACTION_BLOCKED`](#action), [`ACTION_ERROR`](#action), [`ACTION_REFUSE`](#action) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_BUFFER`](#error), [`ERROR_PACKET`](#error), [`ERROR_VERSION`](#error), [`ERROR_TOKEN`](#error), [`ERROR_IDENTITY`](#error), [`ERROR_ADMISSION`](#error), [`ERROR_MEMORY`](#error), [`ERROR_CRYPTO`](#error), [`ERROR_OUTPUT`](#error), [`ERROR_TOKEN_HANDLE`](#error), [`ERROR_CLEANUP`](#error) | |

| On `DatagramClass` | |
| :--- | :--- |
| [`DATAGRAM_MALFORMED`](#datagramclass), [`DATAGRAM_INITIAL`](#datagramclass), [`DATAGRAM_NEGOTIATE`](#datagramclass), [`DATAGRAM_ESTABLISHED`](#datagramclass) | |

| On `ClassifiedDatagram` | |
| :--- | :--- |
| [`classify_datagram`](#classify_datagram) | classifies one received datagram for a cid-indexed socket owner |

| On `CleanupStatus` | |
| :--- | :--- |
| [`CLEANUP_NONE`](#cleanupstatus), [`CLEANUP_COMPLETE`](#cleanupstatus), [`CLEANUP_RETAINED`](#cleanupstatus), [`CLEANUP_INVALID`](#cleanupstatus) | |

| On `Listener` | |
| :--- | :--- |
| [`initialize_result`](#initialize_result) | pending initials draw on `backing` until the listener's storage leg is released |
| [`initialize`](#initialize) | |
| [`refuse`](#refuse) | answers an Initial with a CONNECTION_CLOSE under the Initial keys its destination id derives and holds no state for it (RFC 9000 10.2.3) |
| [`issue_address_token`](#issue_address_token), [`preflight`](#preflight), [`commit`](#commit), [`cancel`](#cancel), [`retry_cleanup`](#retry_cleanup), [`release_connection`](#release_connection), [`begin_close`](#begin_close), [`abort_initialize`](#abort_initialize), [`retry_initialization_cleanup`](#retry_initialization_cleanup), [`initialization_cleanup`](#initialization_cleanup), [`finish_close_result`](#finish_close_result), [`finish_close`](#finish_close) | |

| On `Request` | |
| :--- | :--- |
| [`set_retry_source`](#set_retry_source) | copies the retry source so the caller retains no storage through preflight |

| Constants | |
| :--- | :--- |
| [`CONNECTION_ID_CAPACITY`](#constants), [`MAX_DATAGRAM_LENGTH`](#constants), [`PENDING_FREE`](#constants), [`PENDING_RESERVED`](#constants), [`PENDING_CLEANUP`](#constants) | |

---

## Action

```mach
pub def Action: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ACTION_ACCEPT` | `1` |  |
| `ACTION_RETRY` | `2` |  |
| `ACTION_VERSION_NEGOTIATION` | `3` |  |
| `ACTION_DROP` | `4` |  |
| `ACTION_BLOCKED` | `5` |  |
| `ACTION_ERROR` | `6` |  |
| `ACTION_REFUSE` | `7` |  |

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
| `ERROR_PACKET` | `4` |  |
| `ERROR_VERSION` | `5` |  |
| `ERROR_TOKEN` | `6` |  |
| `ERROR_IDENTITY` | `7` |  |
| `ERROR_ADMISSION` | `8` |  |
| `ERROR_MEMORY` | `9` |  |
| `ERROR_CRYPTO` | `10` |  |
| `ERROR_OUTPUT` | `11` |  |
| `ERROR_TOKEN_HANDLE` | `12` |  |
| `ERROR_CLEANUP` | `13` |  |

## DatagramClass

```mach
pub def DatagramClass: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `DATAGRAM_MALFORMED` | `0` |  |
| `DATAGRAM_INITIAL` | `1` |  |
| `DATAGRAM_NEGOTIATE` | `2` |  |
| `DATAGRAM_ESTABLISHED` | `3` |  |

## ConnectionId

```mach
pub rec ConnectionId {
    data:   [CONNECTION_ID_CAPACITY]u8;
    length: usize;
}
```

## ClassifiedDatagram

```mach
pub rec ClassifiedDatagram {
    class:        DatagramClass;
    destination:  ConnectionId;
    version:      u32;
    long_header:  bool;
    token_length: usize;
}
```

one received datagram as the socket owner sees it before admission.
token_length is the Initial's token length for DATAGRAM_INITIAL and 0
for every other class

### classify_datagram

```mach
pub fun classify_datagram(data: *u8, length: usize,
    short_destination_length: usize) ClassifiedDatagram
```

classifies one received datagram for a cid-indexed socket owner. every
published byte is copied, and the input is borrowed only for this call

## CleanupStatus

```mach
pub def CleanupStatus: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `CLEANUP_NONE` | `0` |  |
| `CLEANUP_COMPLETE` | `1` |  |
| `CLEANUP_RETAINED` | `2` |  |
| `CLEANUP_INVALID` | `3` |  |

## Config

```mach
pub rec Config {
    source:                  u64;
    supported_versions:      *u32;
    supported_version_count: usize;
    minimum_initial_size:    usize;
    require_retry:           bool;
}
```

## Pending

```mach
pub rec Pending {
    charge:               quic.connection.admission.Charge;
    replay:               quic.connection.token.Reservation;
    original_destination: quic.packet.packet.ConnectionId;
    initial_destination:  quic.packet.packet.ConnectionId;
    initial_source:       quic.packet.packet.ConnectionId;
    retry_source:         quic.packet.packet.ConnectionId;
    peer:                 std.net.ip.Endpoint;
    version:              u32;
    generation:           u64;
    state:                u8;
    owns_admission:       bool;
    owns_replay:          bool;
    peer_validated:       bool;
    retry_source_present: bool;
}
```

## Listener

```mach
pub rec Listener {
    config:               Config;
    backing:              *std.allocator.Allocator;
    pending:              quic.storage.slots.Slots[Pending];
    admission_manager:    *quic.connection.admission.Manager;
    token_manager:        *quic.connection.token.Manager;
    pending_generation:   u64;
    lease_generation:     u64;
    owns_storage:         bool;
    owns_admission_lease: bool;
    owns_token_lease:     bool;
    cleanup_pending:      bool;
    initialized:          bool;
    closing:              bool;
}
```

### initialize_result

```mach
pub fun initialize_result(listener: *Listener, config: Config,
    backing: *std.allocator.Allocator, admission_manager: *quic.connection.admission.Manager,
    token_manager: *quic.connection.token.Manager) InitializeResult
```

pending initials draw on `backing` until the listener's storage leg is released

### initialize

```mach
pub fun initialize(listener: *Listener, config: Config,
    backing: *std.allocator.Allocator, admission_manager: *quic.connection.admission.Manager,
    token_manager: *quic.connection.token.Manager) bool
```

### refuse

```mach
pub fun refuse(listener: *Listener, request: *Request, error_code: u64) Result
```

answers an Initial with a CONNECTION_CLOSE under the Initial keys its
destination id derives and holds no state for it (RFC 9000 10.2.3). the ids
are echoed swapped so the client reads it as the server's first Initial, and
it is the same packet whether or not the Initial carries a Retry token, since
the client derives its keys from the destination id either way. it touches
no pending slot, charge or token, so it composes with whatever preflight
answered

### issue_address_token

```mach
pub fun issue_address_token(listener: *Listener, peer: std.net.ip.Endpoint,
    now: std.chrono.time.Instant, nonce: u64, output: *u8,
    capacity: usize) quic.connection.token.Result
```

### preflight

```mach
pub fun preflight(listener: *Listener, request: *Request) Result
```

### commit

```mach
pub fun commit(listener: *Listener, value: Acceptance) Accepted
```

### cancel

```mach
pub fun cancel(listener: *Listener, value: Acceptance) Result
```

### retry_cleanup

```mach
pub fun retry_cleanup(listener: *Listener, value: Acceptance) CleanupResult
```

### release_connection

```mach
pub fun release_connection(listener: *Listener, charge: quic.connection.admission.Charge) Result
```

### begin_close

```mach
pub fun begin_close(listener: *Listener) bool
```

### abort_initialize

```mach
pub fun abort_initialize(listener: *Listener,
    value: LeaseHandle) LeaseCleanupResult
```

### retry_initialization_cleanup

```mach
pub fun retry_initialization_cleanup(listener: *Listener,
    value: LeaseHandle) LeaseCleanupResult
```

### initialization_cleanup

```mach
pub fun initialization_cleanup(listener: *Listener) LeaseCleanupResult
```

### finish_close_result

```mach
pub fun finish_close_result(listener: *Listener) LeaseCleanupResult
```

### finish_close

```mach
pub fun finish_close(listener: *Listener) bool
```

## Request

```mach
pub rec Request {
    peer:                     std.net.ip.Endpoint;
    data:                     *u8;
    length:                   usize;
    now:                      std.chrono.time.Instant;
    retry_source:             ConnectionId;
    retry_nonce:              u64;
    version_negotiation_bits: u8;
    output:                   *u8;
    output_capacity:          usize;
}
```

### set_retry_source

```mach
pub fun set_retry_source(request: *Request, data: *u8,
    length: usize) bool
```

copies the retry source so the caller retains no storage through preflight

## Acceptance

```mach
pub rec Acceptance {
    source:     u64;
    index:      usize;
    generation: u64;
}
```

## LeaseHandle

```mach
pub rec LeaseHandle {
    source:     u64;
    generation: u64;
}
```

## LeaseCleanupResult

```mach
pub rec LeaseCleanupResult {
    status:              CleanupStatus;
    handle:              LeaseHandle;
    admission_retained:  bool;
    token_retained:      bool;
    storage_retained:    bool;
    admission_attempted: bool;
    token_attempted:     bool;
    storage_attempted:   bool;
}
```

## InitializeResult

```mach
pub rec InitializeResult {
    ok:      bool;
    error:   Error;
    handle:  LeaseHandle;
    cleanup: LeaseCleanupResult;
}
```

## CleanupResult

```mach
pub rec CleanupResult {
    status:              CleanupStatus;
    acceptance:          Acceptance;
    admission_retained:  bool;
    replay_retained:     bool;
    admission_attempted: bool;
    replay_attempted:    bool;
    admission_status:    quic.connection.admission.Status;
    admission_error:     quic.connection.admission.Error;
    replay_status:       quic.connection.token.Status;
    replay_error:        quic.connection.token.Error;
}
```

## Result

```mach
pub rec Result {
    action:       Action;
    error:        Error;
    detail:       u64;
    acceptance:   Acceptance;
    output_count: usize;
    version:      u32;
    cleanup:      CleanupResult;
}
```

## Accepted

```mach
pub rec Accepted {
    action:               Action;
    error:                Error;
    detail:               u64;
    charge:               quic.connection.admission.Charge;
    original_destination: quic.packet.packet.ConnectionId;
    initial_destination:  quic.packet.packet.ConnectionId;
    initial_source:       quic.packet.packet.ConnectionId;
    retry_source:         quic.packet.packet.ConnectionId;
    peer:                 std.net.ip.Endpoint;
    version:              u32;
    peer_validated:       bool;
    retry_source_present: bool;
    cleanup:              CleanupResult;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `CONNECTION_ID_CAPACITY` | `usize` | `20` |  |
| `MAX_DATAGRAM_LENGTH` | `usize` | `65527` |  |
| `PENDING_FREE` | `u8` | `0` |  |
| `PENDING_RESERVED` | `u8` | `1` |  |
| `PENDING_CLEANUP` | `u8` | `2` |  |

