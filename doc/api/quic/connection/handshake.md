[quic](../README.md) / [connection](README.md) / **handshake**

# quic.connection.handshake

production-shaped tls handshake adapter for quic crypto streams

Source: [`src/connection/handshake.mach`](../../../../src/connection/handshake.mach)

Uses types from [`quic.connection.ownership`](ownership.md), [`quic.crypto.protection`](../crypto/protection.md), [`quic.storage.chunks`](../storage/chunks.md), [`quic.storage.ranges`](../storage/ranges.md), [`quic.storage.source`](../storage/source.md).

| Type | | |
| :--- | :--- | :--- |
| [`Role`](#role) | `def` |  |
| [`Level`](#level) | `def` |  |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`EventKind`](#eventkind) | `def` |  |
| [`View`](#view) | `rec` |  |
| [`SecretView`](#secretview) | `rec` |  |
| [`Start`](#start) | `rec` |  |
| [`ProviderResult`](#providerresult) | `rec` |  |
| [`ProviderEvent`](#providerevent) | `rec` | provider data and secrets remain borrowed until complete_event |
| [`StartFun`](#startfun) | `def` |  |
| [`IngestFun`](#ingestfun) | `def` |  |
| [`RestartFun`](#restartfun) | `def` |  |
| [`PollFun`](#pollfun) | `def` |  |
| [`NextEventFun`](#nexteventfun) | `def` |  |
| [`CompleteEventFun`](#completeeventfun) | `def` |  |
| [`CloseFun`](#closefun) | `def` |  |
| [`DestroyFun`](#destroyfun) | `def` |  |
| [`Protocol`](#protocol) | `rec` |  |
| [`LevelState`](#levelstate) | `rec` | receive_contiguous: bytes handed to the provider, whose chunks are released send_acked:         the acknowledged prefix, whose chunks are released discarded:          keys are gone, so the level stores nothing more |
| [`Attempt`](#attempt) | `rec` |  |
| [`Storage`](#storage) | `rec` | chunks:  where every level's crypto bytes come from account: whose budget they count against |
| [`Config`](#config) | `rec` |  |
| [`Adapter`](#adapter) | `rec` |  |
| [`EventToken`](#eventtoken) | `rec` |  |
| [`Event`](#event) | `rec` |  |
| [`AttemptToken`](#attempttoken) | `rec` |  |
| [`Prepared`](#prepared) | `rec` |  |
| [`Result`](#result) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |

| On `Role` | |
| :--- | :--- |
| [`CLIENT`](#role), [`SERVER`](#role) | |

| On `Level` | |
| :--- | :--- |
| [`INITIAL`](#level), [`EARLY`](#level), [`HANDSHAKE`](#level), [`APPLICATION`](#level) | |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_MORE`](#status), [`STATUS_EMPTY`](#status), [`STATUS_STALE`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_CLOSED`](#status), [`STATUS_ERROR`](#status) | |
| [`STATUS_WAITING`](#status) | a provider refused for memory and consumed nothing |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_BUFFER`](#error), [`ERROR_LIMIT`](#error), [`ERROR_OFFSET`](#error), [`ERROR_CONFLICT`](#error), [`ERROR_PROVIDER`](#error), [`ERROR_EVENT`](#error), [`ERROR_TOKEN`](#error), [`ERROR_SECRET`](#error), [`ERROR_TRANSITION`](#error), [`ERROR_REJECTED`](#error), [`ERROR_OVERFLOW`](#error) | |
| [`ERROR_STORAGE`](#error) | a crypto frame the adapter could not store, refused with nothing changed so its packet goes unacknowledged and the peer sends it again |

| On `EventKind` | |
| :--- | :--- |
| [`EVENT_CRYPTO`](#eventkind), [`EVENT_TRAFFIC_SECRET`](#eventkind), [`EVENT_PEER_TRANSPORT_PARAMETERS`](#eventkind), [`EVENT_EARLY_DATA`](#eventkind), [`EVENT_AUTHENTICATION`](#eventkind), [`EVENT_HANDSHAKE_COMPLETE`](#eventkind), [`EVENT_ALERT`](#eventkind) | |

| On `Adapter` | |
| :--- | :--- |
| [`initialize`](#initialize), [`lease_core`](#lease_core), [`release_core`](#release_core) | |
| [`abandon_core`](#abandon_core) | initialization rollback is private ownership, so no event may have escaped |
| [`abandon_initialization`](#abandon_initialization) | detaches an unexposed adapter |
| [`initialize_tls_client`](#initialize_tls_client), [`initialize_tls_server`](#initialize_tls_server) | |
| [`provider_ranges`](#provider_ranges) | the adapter owns which provider is bound, so it answers every question about that provider's memory itself; no caller reaches through to the binding |
| [`provider_secrets_disjoint`](#provider_secrets_disjoint), [`start`](#start-1), [`receive`](#receive), [`next_event`](#next_event), [`complete_event`](#complete_event), [`prepare`](#prepare), [`prepare_probe`](#prepare_probe), [`cancel_prepared`](#cancel_prepared), [`publish`](#publish), [`on_terminal`](#on_terminal) | |
| [`discard`](#discard) | releases a level's crypto storage once its keys are gone (rfc 9001 4.9) |
| [`restart`](#restart), [`on_retry`](#on_retry), [`on_version_negotiation`](#on_version_negotiation), [`poll`](#poll) | |
| [`settle`](#settle) | retires the handshake once it has nothing left to hand over, so only the established core and none of the handshake's memory remains |
| [`settle_scoped`](#settle_scoped), [`close`](#close), [`destroy`](#destroy), [`start_scoped`](#start_scoped), [`receive_scoped`](#receive_scoped), [`next_event_scoped`](#next_event_scoped), [`complete_event_scoped`](#complete_event_scoped), [`prepare_scoped`](#prepare_scoped), [`prepare_probe_scoped`](#prepare_probe_scoped) | |
| [`peek_scoped`](#peek_scoped) | what prepare_scoped, or prepare_probe_scoped when `probe`, would answer at `level`, with nothing changed |
| [`cancel_prepared_scoped`](#cancel_prepared_scoped), [`publish_scoped`](#publish_scoped), [`on_terminal_scoped`](#on_terminal_scoped), [`on_retry_scoped`](#on_retry_scoped), [`on_version_negotiation_scoped`](#on_version_negotiation_scoped), [`discard_scoped`](#discard_scoped), [`poll_scoped`](#poll_scoped), [`close_scoped`](#close_scoped), [`destroy_scoped`](#destroy_scoped), [`snapshot`](#snapshot) | |

| Constants | |
| :--- | :--- |
| [`RECEIVE_RANGE_CAP`](#constants) | intervals a level may hold out of order before a fragmenting frame is refused |
| [`PROVIDER_TLS_ERROR_BASE`](#constants), [`PROVIDER_BINDING_CONFIG`](#constants), [`PROVIDER_BINDING_LEVEL`](#constants), [`PROVIDER_BINDING_OFFSET`](#constants), [`PROVIDER_BINDING_TIME`](#constants), [`PROVIDER_BINDING_DEADLINE`](#constants), [`PROVIDER_BINDING_STATE`](#constants), [`PROVIDER_BINDING_EVENT`](#constants), [`DIRECTION_SEND`](#constants), [`DIRECTION_RECEIVE`](#constants), [`EARLY_NOT_OFFERED`](#constants), [`EARLY_ACCEPTED`](#constants), [`EARLY_REJECTED`](#constants), [`AUTHENTICATED`](#constants), [`AUTHENTICATION_FAILED`](#constants), [`TERMINAL_ACKED`](#constants), [`TERMINAL_LOST`](#constants), [`RESTART_RETRY`](#constants), [`RESTART_VERSION_NEGOTIATION`](#constants), [`ATTEMPT_FREE`](#constants), [`ATTEMPT_PREPARED`](#constants), [`ATTEMPT_PUBLISHED`](#constants), [`PROVIDER_RANGE_CAPACITY`](#constants) | |

---

## Role

```mach
pub def Role: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `CLIENT` | `1` |  |
| `SERVER` | `2` |  |

## Level

```mach
pub def Level: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `INITIAL` | `1` |  |
| `EARLY` | `2` |  |
| `HANDSHAKE` | `3` |  |
| `APPLICATION` | `4` |  |

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_MORE` | `2` |  |
| `STATUS_EMPTY` | `3` |  |
| `STATUS_STALE` | `4` |  |
| `STATUS_BLOCKED` | `5` |  |
| `STATUS_CLOSED` | `6` |  |
| `STATUS_ERROR` | `7` |  |
| `STATUS_WAITING` | `8` | a provider refused for memory and consumed nothing |

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
| `ERROR_LIMIT` | `4` |  |
| `ERROR_OFFSET` | `5` |  |
| `ERROR_CONFLICT` | `6` |  |
| `ERROR_PROVIDER` | `7` |  |
| `ERROR_EVENT` | `8` |  |
| `ERROR_TOKEN` | `9` |  |
| `ERROR_SECRET` | `10` |  |
| `ERROR_TRANSITION` | `11` |  |
| `ERROR_REJECTED` | `12` |  |
| `ERROR_OVERFLOW` | `13` |  |
| `ERROR_STORAGE` | `14` | a crypto frame the adapter could not store, refused with nothing changed so its packet goes unacknowledged and the peer sends it again |

## EventKind

```mach
pub def EventKind: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `EVENT_CRYPTO` | `1` |  |
| `EVENT_TRAFFIC_SECRET` | `2` |  |
| `EVENT_PEER_TRANSPORT_PARAMETERS` | `3` |  |
| `EVENT_EARLY_DATA` | `4` |  |
| `EVENT_AUTHENTICATION` | `5` |  |
| `EVENT_HANDSHAKE_COMPLETE` | `6` |  |
| `EVENT_ALERT` | `7` |  |

## View

```mach
pub rec View       { data: *u8; length: usize; }
```

## SecretView

```mach
pub rec SecretView { data: *^u8; length: usize; }
```

## Start

```mach
pub rec Start {
    role:                       Role;
    version:                    u32;
    server_name:                View;
    alpn:                       View;
    local_transport_parameters: View;
    now_ns:                     u64;
    enable_early_data:          bool;
}
```

## ProviderResult

```mach
pub rec ProviderResult {
    status: Status;
    error:  u64;
}
```

## ProviderEvent

```mach
pub rec ProviderEvent {
    token:       u64;
    kind:        EventKind;
    level:       Level;
    direction:   u8;
    algorithm:   quic.crypto.protection.Algorithm;
    generation:  u64;
    offset:      u64;
    data:        View;
    secret:      SecretView;
    disposition: u8;
    alert:       u64;
}
```

provider data and secrets remain borrowed until complete_event

## StartFun

```mach
pub def StartFun:         fun(ptr, *^u8, *Start) ProviderResult
```

## IngestFun

```mach
pub def IngestFun:        fun(ptr, *^u8, Level, u64, *u8, usize, u64) ProviderResult
```

## RestartFun

```mach
pub def RestartFun:       fun(ptr, *^u8, u8, u32, u64) ProviderResult
```

## PollFun

```mach
pub def PollFun:          fun(ptr, *^u8, u64) ProviderResult
```

## NextEventFun

```mach
pub def NextEventFun:     fun(ptr, *^u8, *ProviderEvent) bool
```

## CompleteEventFun

```mach
pub def CompleteEventFun: fun(ptr, *^u8, u64, bool) bool
```

## CloseFun

```mach
pub def CloseFun:         fun(ptr, *^u8, u64, u64) ProviderResult
```

## DestroyFun

```mach
pub def DestroyFun:       fun(ptr, *^u8) bool
```

## Protocol

```mach
pub rec Protocol {
    context:             ptr;
    context_size:        usize;
    secret_context:      *^u8;
    secret_context_size: usize;
    start:               StartFun;
    ingest:              IngestFun;
    restart:             RestartFun;
    poll:                PollFun;
    next_event:          NextEventFun;
    complete_event:      CompleteEventFun;
    close:               CloseFun;
    destroy:             DestroyFun;
    initialized:         bool;
}
```

## LevelState

```mach
pub rec LevelState {
    receive_contiguous: u64;
    send_length:        u64;
    send_acked:         u64;
    discarded:          bool;
    receive:            quic.storage.chunks.Chunks;
    present:            quic.storage.ranges.RangeSet;
    send:               quic.storage.chunks.Chunks;
    acked:              quic.storage.ranges.RangeSet;
}
```

receive_contiguous: bytes handed to the provider, whose chunks are released
send_acked:         the acknowledged prefix, whose chunks are released
discarded:          keys are gone, so the level stores nothing more

## Attempt

```mach
pub rec Attempt {
    offset:     u64;
    length:     usize;
    generation: u64;
    chunk:      quic.storage.source.Ref;
    level:      Level;
    state:      u8;
}
```

## Storage

```mach
pub rec Storage {
    attempts:         *Attempt;
    attempt_capacity: usize;
    chunks:           *quic.storage.source.Provider;
    account:          *quic.storage.source.Account;
}
```

chunks:  where every level's crypto bytes come from
account: whose budget they count against

## Config

```mach
pub rec Config {
    source:               u64;
    max_crypto_per_level: usize;
    max_event_data:       usize;
    max_peer_identity:    usize;
}
```

## Adapter

```mach
pub rec Adapter {
    config:                          Config;
    storage:                         Storage;
    protocol:                        Protocol;
    levels:                          [4]LevelState;
    secret_generation:               [8]u64;
    event:                           ProviderEvent;
    tls_client:                      *tls.client.Handshake;
    tls_server:                      *tls.server.Handshake;
    tls_deadline_ns:                 u64;
    tls_entropy_context_size:        usize;
    tls_entropy_secret_context_size: usize;
    tls_last_now_ns:                 u64;
    tls_receive_offsets:             [3]u64;
    tls_send_offsets:                [3]u64;
    tls_active_token:                u64;
    tls_active_length:               usize;
    tls_active_level:                tls.engine.Level;
    tls_active_kind:                 tls.engine.EventKind;
    tls_error:                       u64;
    event_generation:                u64;
    event_active:                    bool;
    peer_parameters_received:        bool;
    early_data_received:             bool;
    authentication_received:         bool;
    handshake_complete:              bool;
    terminal_alert:                  u64;
    role:                            Role;
    version:                         u32;
    next_attempt:                    usize;
    core_lease:                      u64;
    initialized:                     bool;
    started:                         bool;
    closing:                         bool;
    destroyed:                       bool;
    # zero until a real mach-tls provider is bound, then CLIENT or SERVER
    tls_role:          Role;
    transition_active: bool;
    # a crypto event whose bytes found no storage, offered again by next_event
    event_deferred: bool;
    # received crypto frames refused for storage before acknowledgement
    receive_storage_refusals: u64;
    # the provider refused for memory. start_pending names a start still owed,
    # and stored crypto past each level's receive_contiguous is still owed
    waiting:       bool;
    start_pending: bool;
    pending_start: Start;
    # the tls core once finish moved it out of the handshake, which is then
    # destroyed and holds no memory
    tls_established: tls.tls13.established.Established;
    tls_finished:    bool;
    # start was called on the engine, which may hold memory from then on
    tls_started: bool;
    # the lent attempt range, fixed from init_base on
    owned_attempts: quic.connection.ownership.Range;
}
```

### initialize

```mach
pub fun initialize(adapter: *Adapter, config: Config, storage: Storage,
    protocol: Protocol) bool
```

### lease_core

```mach
pub fun lease_core(adapter: *Adapter, source: u64) bool
```

### release_core

```mach
pub fun release_core(adapter: *Adapter, source: u64) bool
```

### abandon_core

```mach
pub fun abandon_core(adapter: *Adapter, source: u64) bool
```

initialization rollback is private ownership, so no event may have escaped

### abandon_initialization

```mach
pub fun abandon_initialization(adapter: *Adapter) bool
```

detaches an unexposed adapter. a tls engine it never started is left as it
was. one it started holds memory on the connection's account, which is about
to close, so it is destroyed and the caller initializes it again to reuse it

### initialize_tls_client

```mach
pub fun initialize_tls_client(adapter: *Adapter, config: Config, storage: Storage,
    value: *tls.client.Handshake, lease: tls.buffer.Lease,
    deadline_ns: u64,
    entropy_context_size: usize,
    entropy_secret_context_size: usize) bool
```

### initialize_tls_server

```mach
pub fun initialize_tls_server(adapter: *Adapter, config: Config, storage: Storage,
    value: *tls.server.Handshake, lease: tls.buffer.Lease,
    deadline_ns: u64,
    entropy_context_size: usize,
    entropy_secret_context_size: usize) bool
```

### provider_ranges

```mach
pub fun provider_ranges(adapter: *Adapter, output: *quic.connection.ownership.Range,
    capacity: usize) bool
```

the adapter owns which provider is bound, so it answers every question about
that provider's memory itself; no caller reaches through to the binding

### provider_secrets_disjoint

```mach
pub fun provider_secrets_disjoint(adapter: *Adapter, data: *^u8,
    length: usize) bool
```

### start

```mach
pub fun start(adapter: *Adapter, value: *Start) Result
```

### receive

```mach
pub fun receive(adapter: *Adapter, level: Level, offset: u64, data: *u8,
    length: usize, now_ns: u64) Result
```

### next_event

```mach
pub fun next_event(adapter: *Adapter) Event
```

### complete_event

```mach
pub fun complete_event(adapter: *Adapter, token: EventToken, accepted: bool) Result
```

### prepare

```mach
pub fun prepare(adapter: *Adapter, level: Level, maximum: usize) Prepared
```

### prepare_probe

```mach
pub fun prepare_probe(adapter: *Adapter, level: Level,
    maximum: usize) Prepared
```

### cancel_prepared

```mach
pub fun cancel_prepared(adapter: *Adapter, token: AttemptToken) Result
```

### publish

```mach
pub fun publish(adapter: *Adapter, token: AttemptToken) Result
```

### on_terminal

```mach
pub fun on_terminal(adapter: *Adapter, token: AttemptToken, terminal: u8) Result
```

### discard

```mach
pub fun discard(adapter: *Adapter, level: Level) Result
```

releases a level's crypto storage once its keys are gone (rfc 9001 4.9).
its offsets stay, so nothing at the level can be taken again

### restart

```mach
pub fun restart(adapter: *Adapter, reason: u8, version: u32, now_ns: u64) Result
```

### on_retry

```mach
pub fun on_retry(adapter: *Adapter, version: u32, now_ns: u64) Result
```

### on_version_negotiation

```mach
pub fun on_version_negotiation(adapter: *Adapter, version: u32,
    now_ns: u64) Result
```

### poll

```mach
pub fun poll(adapter: *Adapter, now_ns: u64) Result
```

### settle

```mach
pub fun settle(adapter: *Adapter) Result
```

retires the handshake once it has nothing left to hand over, so only the
established core and none of the handshake's memory remains. STATUS_MORE
means not yet, and the caller asks again after the next poll

### settle_scoped

```mach
pub fun settle_scoped(adapter: *Adapter, source: u64) Result
```

### close

```mach
pub fun close(adapter: *Adapter, alert: u64, now_ns: u64) Result
```

### destroy

```mach
pub fun destroy(adapter: *Adapter) bool
```

### start_scoped

```mach
pub fun start_scoped(adapter: *Adapter, source: u64, value: *Start) Result
```

### receive_scoped

```mach
pub fun receive_scoped(adapter: *Adapter, source: u64, level: Level,
    offset: u64, data: *u8, length: usize,
    now_ns: u64) Result
```

### next_event_scoped

```mach
pub fun next_event_scoped(adapter: *Adapter, source: u64) Event
```

### complete_event_scoped

```mach
pub fun complete_event_scoped(adapter: *Adapter, source: u64,
    token: EventToken, accepted: bool) Result
```

### prepare_scoped

```mach
pub fun prepare_scoped(adapter: *Adapter, source: u64, level: Level,
    maximum: usize) Prepared
```

### prepare_probe_scoped

```mach
pub fun prepare_probe_scoped(adapter: *Adapter, source: u64, level: Level,
    maximum: usize) Prepared
```

### peek_scoped

```mach
pub fun peek_scoped(adapter: *Adapter, source: u64, level: Level,
    maximum: usize, probe: bool) Prepared
```

what prepare_scoped, or prepare_probe_scoped when `probe`, would answer at
`level`, with nothing changed

### cancel_prepared_scoped

```mach
pub fun cancel_prepared_scoped(adapter: *Adapter, source: u64,
    token: AttemptToken) Result
```

### publish_scoped

```mach
pub fun publish_scoped(adapter: *Adapter, source: u64,
    token: AttemptToken) Result
```

### on_terminal_scoped

```mach
pub fun on_terminal_scoped(adapter: *Adapter, source: u64,
    token: AttemptToken, terminal: u8) Result
```

### on_retry_scoped

```mach
pub fun on_retry_scoped(adapter: *Adapter, source: u64, version: u32,
    now_ns: u64) Result
```

### on_version_negotiation_scoped

```mach
pub fun on_version_negotiation_scoped(adapter: *Adapter, source: u64,
    version: u32, now_ns: u64) Result
```

### discard_scoped

```mach
pub fun discard_scoped(adapter: *Adapter, source: u64, level: Level) Result
```

### poll_scoped

```mach
pub fun poll_scoped(adapter: *Adapter, source: u64, now_ns: u64) Result
```

### close_scoped

```mach
pub fun close_scoped(adapter: *Adapter, source: u64, alert: u64,
    now_ns: u64) Result
```

### destroy_scoped

```mach
pub fun destroy_scoped(adapter: *Adapter, source: u64) bool
```

### snapshot

```mach
pub fun snapshot(adapter: *Adapter) Snapshot
```

## EventToken

```mach
pub rec EventToken {
    source:         u64;
    generation:     u64;
    provider_token: u64;
}
```

## Event

```mach
pub rec Event {
    status:         Status;
    error:          Error;
    provider_error: u64;
    token:          EventToken;
    kind:           EventKind;
    level:          Level;
    direction:      u8;
    algorithm:      quic.crypto.protection.Algorithm;
    generation:     u64;
    data:           View;
    secret:         SecretView;
    disposition:    u8;
    alert:          u64;
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

## Prepared

```mach
pub rec Prepared {
    status: Status;
    error:  Error;
    token:  AttemptToken;
    level:  Level;
    offset: u64;
    data:   View;
}
```

## Result

```mach
pub rec Result {
    status:         Status;
    error:          Error;
    provider_error: u64;
    consumed:       usize;
}
```

## Snapshot

```mach
pub rec Snapshot {
    role:                     Role;
    version:                  u32;
    event_active:             bool;
    peer_parameters_received: bool;
    early_data_received:      bool;
    authentication_received:  bool;
    handshake_complete:       bool;
    terminal_alert:           u64;
    initialized:              bool;
    started:                  bool;
    closing:                  bool;
    destroyed:                bool;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `RECEIVE_RANGE_CAP` | `usize` | `32` | intervals a level may hold out of order before a fragmenting frame is refused |
| `PROVIDER_TLS_ERROR_BASE` | `u64` | `0x10000` |  |
| `PROVIDER_BINDING_CONFIG` | `u64` | `0x20001` |  |
| `PROVIDER_BINDING_LEVEL` | `u64` | `0x20002` |  |
| `PROVIDER_BINDING_OFFSET` | `u64` | `0x20003` |  |
| `PROVIDER_BINDING_TIME` | `u64` | `0x20004` |  |
| `PROVIDER_BINDING_DEADLINE` | `u64` | `0x20005` |  |
| `PROVIDER_BINDING_STATE` | `u64` | `0x20006` |  |
| `PROVIDER_BINDING_EVENT` | `u64` | `0x20007` |  |
| `DIRECTION_SEND` | `u8` | `1` |  |
| `DIRECTION_RECEIVE` | `u8` | `2` |  |
| `EARLY_NOT_OFFERED` | `u8` | `1` |  |
| `EARLY_ACCEPTED` | `u8` | `2` |  |
| `EARLY_REJECTED` | `u8` | `3` |  |
| `AUTHENTICATED` | `u8` | `1` |  |
| `AUTHENTICATION_FAILED` | `u8` | `2` |  |
| `TERMINAL_ACKED` | `u8` | `1` |  |
| `TERMINAL_LOST` | `u8` | `2` |  |
| `RESTART_RETRY` | `u8` | `1` |  |
| `RESTART_VERSION_NEGOTIATION` | `u8` | `2` |  |
| `ATTEMPT_FREE` | `u8` | `0` |  |
| `ATTEMPT_PREPARED` | `u8` | `1` |  |
| `ATTEMPT_PUBLISHED` | `u8` | `2` |  |
| `PROVIDER_RANGE_CAPACITY` | `usize` | `3` |  |

