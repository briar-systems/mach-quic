# quic.connection.listener

## def Action

```mach
pub def Action: u8
```

## val ACTION_ACCEPT

```mach
pub val ACTION_ACCEPT:              Action = 1
```

## val ACTION_RETRY

```mach
pub val ACTION_RETRY:               Action = 2
```

## val ACTION_VERSION_NEGOTIATION

```mach
pub val ACTION_VERSION_NEGOTIATION: Action = 3
```

## val ACTION_DROP

```mach
pub val ACTION_DROP:                Action = 4
```

## val ACTION_BLOCKED

```mach
pub val ACTION_BLOCKED:             Action = 5
```

## val ACTION_ERROR

```mach
pub val ACTION_ERROR:               Action = 6
```

## val ACTION_REFUSE

```mach
pub val ACTION_REFUSE:              Action = 7
```

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:         Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:        Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:       Error = 2
```

## val ERROR_BUFFER

```mach
pub val ERROR_BUFFER:       Error = 3
```

## val ERROR_PACKET

```mach
pub val ERROR_PACKET:       Error = 4
```

## val ERROR_VERSION

```mach
pub val ERROR_VERSION:      Error = 5
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN:        Error = 6
```

## val ERROR_IDENTITY

```mach
pub val ERROR_IDENTITY:     Error = 7
```

## val ERROR_ADMISSION

```mach
pub val ERROR_ADMISSION:    Error = 8
```

## val ERROR_MEMORY

```mach
pub val ERROR_MEMORY:       Error = 9
```

## val ERROR_CRYPTO

```mach
pub val ERROR_CRYPTO:       Error = 10
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT:       Error = 11
```

## val ERROR_TOKEN_HANDLE

```mach
pub val ERROR_TOKEN_HANDLE: Error = 12
```

## val ERROR_CLEANUP

```mach
pub val ERROR_CLEANUP:      Error = 13
```

## val CONNECTION_ID_CAPACITY

```mach
pub val CONNECTION_ID_CAPACITY: usize = 20
```

## val MAX_DATAGRAM_LENGTH

```mach
pub val MAX_DATAGRAM_LENGTH:    usize = 65527
```

## def DatagramClass

```mach
pub def DatagramClass: u8
```

## val DATAGRAM_MALFORMED

```mach
pub val DATAGRAM_MALFORMED:   DatagramClass = 0
```

## val DATAGRAM_INITIAL

```mach
pub val DATAGRAM_INITIAL:     DatagramClass = 1
```

## val DATAGRAM_NEGOTIATE

```mach
pub val DATAGRAM_NEGOTIATE:   DatagramClass = 2
```

## val DATAGRAM_ESTABLISHED

```mach
pub val DATAGRAM_ESTABLISHED: DatagramClass = 3
```

## rec ConnectionId

```mach
pub rec ConnectionId;
```

## rec ClassifiedDatagram

```mach
pub rec ClassifiedDatagram;
```

## val PENDING_FREE

```mach
pub val PENDING_FREE:     u8 = 0
```

## val PENDING_RESERVED

```mach
pub val PENDING_RESERVED: u8 = 1
```

## val PENDING_CLEANUP

```mach
pub val PENDING_CLEANUP:  u8 = 2
```

## def CleanupStatus

```mach
pub def CleanupStatus: u8
```

## val CLEANUP_NONE

```mach
pub val CLEANUP_NONE:     CleanupStatus = 0
```

## val CLEANUP_COMPLETE

```mach
pub val CLEANUP_COMPLETE: CleanupStatus = 1
```

## val CLEANUP_RETAINED

```mach
pub val CLEANUP_RETAINED: CleanupStatus = 2
```

## val CLEANUP_INVALID

```mach
pub val CLEANUP_INVALID:  CleanupStatus = 3
```

## rec Config

```mach
pub rec Config;
```

## rec Pending

```mach
pub rec Pending;
```

## rec Listener

```mach
pub rec Listener;
```

## rec Request

```mach
pub rec Request;
```

## rec Acceptance

```mach
pub rec Acceptance;
```

## rec LeaseHandle

```mach
pub rec LeaseHandle;
```

## rec LeaseCleanupResult

```mach
pub rec LeaseCleanupResult;
```

## rec InitializeResult

```mach
pub rec InitializeResult;
```

## rec CleanupResult

```mach
pub rec CleanupResult;
```

## rec Result

```mach
pub rec Result;
```

## rec Accepted

```mach
pub rec Accepted;
```

## fun set_retry_source

```mach
pub fun set_retry_source(request: *Request, data: *u8,
length: usize) bool;
```

copies the retry source so the caller retains no storage through preflight

## fun initialize_result

```mach
pub fun initialize_result(listener: *Listener, config: Config,
backing: *allocator.Allocator, admission_manager: *admission.Manager,
token_manager: *token.Manager) InitializeResult;
```

pending initials draw on `backing` until the listener's storage leg is released

## fun initialize

```mach
pub fun initialize(listener: *Listener, config: Config,
backing: *allocator.Allocator, admission_manager: *admission.Manager,
token_manager: *token.Manager) bool;
```

## fun classify_datagram

```mach
pub fun classify_datagram(data: *u8, length: usize,
short_destination_length: usize) ClassifiedDatagram;
```

classifies one received datagram for a cid-indexed socket owner. every
published byte is copied, and the input is borrowed only for this call

## fun refuse

```mach
pub fun refuse(listener: *Listener, request: *Request, error_code: u64) Result;
```

answers an Initial with a CONNECTION_CLOSE under the Initial keys its
destination id derives and holds no state for it (RFC 9000 10.2.3). the ids
are echoed swapped so the client reads it as the server's first Initial, and
it is the same packet whether or not the Initial carries a Retry token, since
the client derives its keys from the destination id either way. it touches
no pending slot, charge or token, so it composes with whatever preflight
answered

## fun issue_address_token

```mach
pub fun issue_address_token(listener: *Listener, peer: ip.Endpoint,
now: time.Instant, nonce: u64, output: *u8,
capacity: usize) token.Result;
```

## fun preflight

```mach
pub fun preflight(listener: *Listener, request: *Request) Result;
```

## fun commit

```mach
pub fun commit(listener: *Listener, value: Acceptance) Accepted;
```

## fun cancel

```mach
pub fun cancel(listener: *Listener, value: Acceptance) Result;
```

## fun retry_cleanup

```mach
pub fun retry_cleanup(listener: *Listener, value: Acceptance) CleanupResult;
```

## fun release_connection

```mach
pub fun release_connection(listener: *Listener, charge: admission.Charge) Result;
```

## fun begin_close

```mach
pub fun begin_close(listener: *Listener) bool;
```

## fun abort_initialize

```mach
pub fun abort_initialize(listener: *Listener,
value: LeaseHandle) LeaseCleanupResult;
```

## fun retry_initialization_cleanup

```mach
pub fun retry_initialization_cleanup(listener: *Listener,
value: LeaseHandle) LeaseCleanupResult;
```

## fun initialization_cleanup

```mach
pub fun initialization_cleanup(listener: *Listener) LeaseCleanupResult;
```

## fun finish_close_result

```mach
pub fun finish_close_result(listener: *Listener) LeaseCleanupResult;
```

## fun finish_close

```mach
pub fun finish_close(listener: *Listener) bool;
```

