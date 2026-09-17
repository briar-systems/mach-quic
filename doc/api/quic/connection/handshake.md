# quic.connection.handshake

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

## def Level

```mach
pub def Level: u8
```

## val INITIAL

```mach
pub val INITIAL:     Level = 1
```

## val EARLY

```mach
pub val EARLY:       Level = 2
```

## val HANDSHAKE

```mach
pub val HANDSHAKE:   Level = 3
```

## val APPLICATION

```mach
pub val APPLICATION: Level = 4
```

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK:      Status = 1
```

## val STATUS_MORE

```mach
pub val STATUS_MORE:    Status = 2
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY:   Status = 3
```

## val STATUS_STALE

```mach
pub val STATUS_STALE:   Status = 4
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: Status = 5
```

## val STATUS_CLOSED

```mach
pub val STATUS_CLOSED:  Status = 6
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR:   Status = 7
```

## val STATUS_WAITING

```mach
pub val STATUS_WAITING: Status = 8
```

a provider refused for memory and consumed nothing. the adapter repeats the
same call once the connection's account wakes

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:       Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:      Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:     Error = 2
```

## val ERROR_BUFFER

```mach
pub val ERROR_BUFFER:     Error = 3
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT:      Error = 4
```

## val ERROR_OFFSET

```mach
pub val ERROR_OFFSET:     Error = 5
```

## val ERROR_CONFLICT

```mach
pub val ERROR_CONFLICT:   Error = 6
```

## val ERROR_PROVIDER

```mach
pub val ERROR_PROVIDER:   Error = 7
```

## val ERROR_EVENT

```mach
pub val ERROR_EVENT:      Error = 8
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN:      Error = 9
```

## val ERROR_SECRET

```mach
pub val ERROR_SECRET:     Error = 10
```

## val ERROR_TRANSITION

```mach
pub val ERROR_TRANSITION: Error = 11
```

## val ERROR_REJECTED

```mach
pub val ERROR_REJECTED:   Error = 12
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW:   Error = 13
```

## val ERROR_STORAGE

```mach
pub val ERROR_STORAGE: Error = 14
```

a crypto frame the adapter could not store, refused with nothing changed so
its packet goes unacknowledged and the peer sends it again

## val RECEIVE_RANGE_CAP

```mach
pub val RECEIVE_RANGE_CAP: usize = 32
```

intervals a level may hold out of order before a fragmenting frame is refused

## val PROVIDER_TLS_ERROR_BASE

```mach
pub val PROVIDER_TLS_ERROR_BASE:   u64 = 0x10000
```

## val PROVIDER_BINDING_CONFIG

```mach
pub val PROVIDER_BINDING_CONFIG:   u64 = 0x20001
```

## val PROVIDER_BINDING_LEVEL

```mach
pub val PROVIDER_BINDING_LEVEL:    u64 = 0x20002
```

## val PROVIDER_BINDING_OFFSET

```mach
pub val PROVIDER_BINDING_OFFSET:   u64 = 0x20003
```

## val PROVIDER_BINDING_TIME

```mach
pub val PROVIDER_BINDING_TIME:     u64 = 0x20004
```

## val PROVIDER_BINDING_DEADLINE

```mach
pub val PROVIDER_BINDING_DEADLINE: u64 = 0x20005
```

## val PROVIDER_BINDING_STATE

```mach
pub val PROVIDER_BINDING_STATE:    u64 = 0x20006
```

## val PROVIDER_BINDING_EVENT

```mach
pub val PROVIDER_BINDING_EVENT:    u64 = 0x20007
```

## def EventKind

```mach
pub def EventKind: u8
```

## val EVENT_CRYPTO

```mach
pub val EVENT_CRYPTO:                    EventKind = 1
```

## val EVENT_TRAFFIC_SECRET

```mach
pub val EVENT_TRAFFIC_SECRET:            EventKind = 2
```

## val EVENT_PEER_TRANSPORT_PARAMETERS

```mach
pub val EVENT_PEER_TRANSPORT_PARAMETERS: EventKind = 3
```

## val EVENT_EARLY_DATA

```mach
pub val EVENT_EARLY_DATA:                EventKind = 4
```

## val EVENT_AUTHENTICATION

```mach
pub val EVENT_AUTHENTICATION:            EventKind = 5
```

## val EVENT_HANDSHAKE_COMPLETE

```mach
pub val EVENT_HANDSHAKE_COMPLETE:        EventKind = 6
```

## val EVENT_ALERT

```mach
pub val EVENT_ALERT:                     EventKind = 7
```

## val DIRECTION_SEND

```mach
pub val DIRECTION_SEND:    u8 = 1
```

## val DIRECTION_RECEIVE

```mach
pub val DIRECTION_RECEIVE: u8 = 2
```

## val EARLY_NOT_OFFERED

```mach
pub val EARLY_NOT_OFFERED: u8 = 1
```

## val EARLY_ACCEPTED

```mach
pub val EARLY_ACCEPTED:    u8 = 2
```

## val EARLY_REJECTED

```mach
pub val EARLY_REJECTED:    u8 = 3
```

## val AUTHENTICATED

```mach
pub val AUTHENTICATED:         u8 = 1
```

## val AUTHENTICATION_FAILED

```mach
pub val AUTHENTICATION_FAILED: u8 = 2
```

## val TERMINAL_ACKED

```mach
pub val TERMINAL_ACKED: u8 = 1
```

## val TERMINAL_LOST

```mach
pub val TERMINAL_LOST:  u8 = 2
```

## val RESTART_RETRY

```mach
pub val RESTART_RETRY:               u8 = 1
```

## val RESTART_VERSION_NEGOTIATION

```mach
pub val RESTART_VERSION_NEGOTIATION: u8 = 2
```

## val ATTEMPT_FREE

```mach
pub val ATTEMPT_FREE:      u8 = 0
```

## val ATTEMPT_PREPARED

```mach
pub val ATTEMPT_PREPARED:  u8 = 1
```

## val ATTEMPT_PUBLISHED

```mach
pub val ATTEMPT_PUBLISHED: u8 = 2
```

## rec View

```mach
pub rec View;
```

## rec SecretView

```mach
pub rec SecretView;
```

## rec Start

```mach
pub rec Start;
```

## rec ProviderResult

```mach
pub rec ProviderResult;
```

## rec ProviderEvent

```mach
pub rec ProviderEvent;
```

provider data and secrets remain borrowed until complete_event

## def StartFun

```mach
pub def StartFun:         fun(ptr, *^u8, *Start) ProviderResult
```

## def IngestFun

```mach
pub def IngestFun:        fun(ptr, *^u8, Level, u64, *u8, usize, u64) ProviderResult
```

## def RestartFun

```mach
pub def RestartFun:       fun(ptr, *^u8, u8, u32, u64) ProviderResult
```

## def PollFun

```mach
pub def PollFun:          fun(ptr, *^u8, u64) ProviderResult
```

## def NextEventFun

```mach
pub def NextEventFun:     fun(ptr, *^u8, *ProviderEvent) bool
```

## def CompleteEventFun

```mach
pub def CompleteEventFun: fun(ptr, *^u8, u64, bool) bool
```

## def CloseFun

```mach
pub def CloseFun:         fun(ptr, *^u8, u64, u64) ProviderResult
```

## def DestroyFun

```mach
pub def DestroyFun:       fun(ptr, *^u8) bool
```

## rec Protocol

```mach
pub rec Protocol;
```

## rec LevelState

```mach
pub rec LevelState;
```

receive_contiguous: bytes handed to the provider, whose chunks are released
send_acked:         the acknowledged prefix, whose chunks are released
discarded:          keys are gone, so the level stores nothing more

## rec Attempt

```mach
pub rec Attempt;
```

## rec Storage

```mach
pub rec Storage;
```

chunks:  where every level's crypto bytes come from
account: whose budget they count against

## rec Config

```mach
pub rec Config;
```

## rec Adapter

```mach
pub rec Adapter;
```

## rec EventToken

```mach
pub rec EventToken;
```

## rec Event

```mach
pub rec Event;
```

## rec AttemptToken

```mach
pub rec AttemptToken;
```

## rec Prepared

```mach
pub rec Prepared;
```

## rec Result

```mach
pub rec Result;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun initialize

```mach
pub fun initialize(adapter: *Adapter, config: Config, storage: Storage,
protocol: Protocol) bool;
```

## fun lease_core

```mach
pub fun lease_core(adapter: *Adapter, source: u64) bool;
```

## fun release_core

```mach
pub fun release_core(adapter: *Adapter, source: u64) bool;
```

## fun abandon_core

```mach
pub fun abandon_core(adapter: *Adapter, source: u64) bool;
```

initialization rollback is private ownership, so no event may have escaped

## fun abandon_initialization

```mach
pub fun abandon_initialization(adapter: *Adapter) bool;
```

detaches an unexposed adapter. a tls engine it never started is left as it
was. one it started holds memory on the connection's account, which is about
to close, so it is destroyed and the caller initializes it again to reuse it

## fun initialize_tls_client

```mach
pub fun initialize_tls_client(adapter: *Adapter, config: Config, storage: Storage,
value: *tls_client_api.Handshake, lease: tls_buffer.Lease,
verification_time_unix: i64,
deadline_ns: u64,
entropy_context_size: usize,
entropy_secret_context_size: usize) bool;
```

## fun initialize_tls_server

```mach
pub fun initialize_tls_server(adapter: *Adapter, config: Config, storage: Storage,
value: *tls_server_api.Handshake, lease: tls_buffer.Lease,
verification_time_unix: i64,
deadline_ns: u64,
entropy_context_size: usize,
entropy_secret_context_size: usize) bool;
```

## val PROVIDER_RANGE_CAPACITY

```mach
pub val PROVIDER_RANGE_CAPACITY: usize = 3
```

## fun provider_ranges

```mach
pub fun provider_ranges(adapter: *Adapter, output: *ownership.Range,
capacity: usize) bool;
```

the adapter owns which provider is bound, so it answers every question about
that provider's memory itself; no caller reaches through to the binding

## fun provider_secrets_disjoint

```mach
pub fun provider_secrets_disjoint(adapter: *Adapter, data: *^u8,
length: usize) bool;
```

## fun start

```mach
pub fun start(adapter: *Adapter, value: *Start) Result;
```

## fun receive

```mach
pub fun receive(adapter: *Adapter, level: Level, offset: u64, data: *u8,
length: usize, now_ns: u64) Result;
```

## fun next_event

```mach
pub fun next_event(adapter: *Adapter) Event;
```

## fun complete_event

```mach
pub fun complete_event(adapter: *Adapter, token: EventToken, accepted: bool) Result;
```

## fun prepare

```mach
pub fun prepare(adapter: *Adapter, level: Level, maximum: usize) Prepared;
```

## fun prepare_probe

```mach
pub fun prepare_probe(adapter: *Adapter, level: Level,
maximum: usize) Prepared;
```

## fun cancel_prepared

```mach
pub fun cancel_prepared(adapter: *Adapter, token: AttemptToken) Result;
```

## fun publish

```mach
pub fun publish(adapter: *Adapter, token: AttemptToken) Result;
```

## fun on_terminal

```mach
pub fun on_terminal(adapter: *Adapter, token: AttemptToken, terminal: u8) Result;
```

## fun discard

```mach
pub fun discard(adapter: *Adapter, level: Level) Result;
```

releases a level's crypto storage once its keys are gone (rfc 9001 4.9).
its offsets stay, so nothing at the level can be taken again

## fun restart

```mach
pub fun restart(adapter: *Adapter, reason: u8, version: u32, now_ns: u64) Result;
```

## fun on_retry

```mach
pub fun on_retry(adapter: *Adapter, version: u32, now_ns: u64) Result;
```

## fun on_version_negotiation

```mach
pub fun on_version_negotiation(adapter: *Adapter, version: u32,
now_ns: u64) Result;
```

## fun poll

```mach
pub fun poll(adapter: *Adapter, now_ns: u64) Result;
```

## fun settle

```mach
pub fun settle(adapter: *Adapter) Result;
```

retires the handshake once it has nothing left to hand over, so only the
established core and none of the handshake's memory remains. STATUS_MORE
means not yet, and the caller asks again after the next poll

## fun settle_scoped

```mach
pub fun settle_scoped(adapter: *Adapter, source: u64) Result;
```

## fun close

```mach
pub fun close(adapter: *Adapter, alert: u64, now_ns: u64) Result;
```

## fun destroy

```mach
pub fun destroy(adapter: *Adapter) bool;
```

## fun start_scoped

```mach
pub fun start_scoped(adapter: *Adapter, source: u64, value: *Start) Result;
```

## fun receive_scoped

```mach
pub fun receive_scoped(adapter: *Adapter, source: u64, level: Level,
offset: u64, data: *u8, length: usize,
now_ns: u64) Result;
```

## fun next_event_scoped

```mach
pub fun next_event_scoped(adapter: *Adapter, source: u64) Event;
```

## fun complete_event_scoped

```mach
pub fun complete_event_scoped(adapter: *Adapter, source: u64,
token: EventToken, accepted: bool) Result;
```

## fun prepare_scoped

```mach
pub fun prepare_scoped(adapter: *Adapter, source: u64, level: Level,
maximum: usize) Prepared;
```

## fun prepare_probe_scoped

```mach
pub fun prepare_probe_scoped(adapter: *Adapter, source: u64, level: Level,
maximum: usize) Prepared;
```

## fun cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(adapter: *Adapter, source: u64,
token: AttemptToken) Result;
```

## fun publish_scoped

```mach
pub fun publish_scoped(adapter: *Adapter, source: u64,
token: AttemptToken) Result;
```

## fun on_terminal_scoped

```mach
pub fun on_terminal_scoped(adapter: *Adapter, source: u64,
token: AttemptToken, terminal: u8) Result;
```

## fun on_retry_scoped

```mach
pub fun on_retry_scoped(adapter: *Adapter, source: u64, version: u32,
now_ns: u64) Result;
```

## fun on_version_negotiation_scoped

```mach
pub fun on_version_negotiation_scoped(adapter: *Adapter, source: u64,
version: u32, now_ns: u64) Result;
```

## fun discard_scoped

```mach
pub fun discard_scoped(adapter: *Adapter, source: u64, level: Level) Result;
```

## fun poll_scoped

```mach
pub fun poll_scoped(adapter: *Adapter, source: u64, now_ns: u64) Result;
```

## fun close_scoped

```mach
pub fun close_scoped(adapter: *Adapter, source: u64, alert: u64,
now_ns: u64) Result;
```

## fun destroy_scoped

```mach
pub fun destroy_scoped(adapter: *Adapter, source: u64) bool;
```

## fun snapshot

```mach
pub fun snapshot(adapter: *Adapter) Snapshot;
```

