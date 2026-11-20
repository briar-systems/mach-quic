[quic](../README.md) / [connection](README.md) / **core**

# quic.connection.core

serialized QUIC connection engine with split public and secret state

Source: [`src/connection/core.mach`](../../../../src/connection/core.mach)

Uses types from [`quic.congestion.pacer`](../congestion/pacer.md), [`quic.connection.cid`](cid.md), [`quic.connection.handshake`](handshake.md), [`quic.connection.negotiation`](negotiation.md), [`quic.connection.ownership`](ownership.md), [`quic.crypto.protection`](../crypto/protection.md), [`quic.frame.frame`](../frame/frame.md), [`quic.packet.packet`](../packet/packet.md), [`quic.path.path`](../path/path.md), [`quic.recovery.ack`](../recovery/ack.md), [`quic.recovery.recovery`](../recovery/recovery.md), [`quic.storage.chunks`](../storage/chunks.md), [`quic.storage.ranges`](../storage/ranges.md), [`quic.storage.source`](../storage/source.md), [`quic.stream.datagram`](../stream/datagram.md), [`quic.stream.stream`](../stream/stream.md), [`quic.transport`](../transport.md), [`quic.transport_parameters`](../transport_parameters.md).

| Type | | |
| :--- | :--- | :--- |
| [`OwnerKind`](#ownerkind) | `def` |  |
| [`View`](#view) | `rec` |  |
| [`Config`](#config) | `rec` |  |
| [`OwnerToken`](#ownertoken) | `uni` |  |
| [`Owner`](#owner) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`SecretStorage`](#secretstorage) | `rec` |  |
| [`Secrets`](#secrets) | `rec` |  |
| [`Snapshot`](#snapshot) | `rec` |  |
| [`InitReason`](#initreason) | `def` | why initialization refused |
| [`InitResult`](#initresult) | `rec` | `reason_kind` and the two indices are only populated for the ownership reasons |
| [`Core`](#core) | `rec` |  |
| [`TakenToken`](#takentoken) | `rec` |  |

| On `OwnerKind` | |
| :--- | :--- |
| [`OWNER_NONE`](#ownerkind), [`OWNER_ACK`](#ownerkind), [`OWNER_CRYPTO`](#ownerkind), [`OWNER_STREAM`](#ownerkind), [`OWNER_DATAGRAM`](#ownerkind), [`OWNER_PATH_CHALLENGE`](#ownerkind), [`OWNER_PATH_RESPONSE`](#ownerkind), [`OWNER_CID_RETIREMENT`](#ownerkind), [`OWNER_CLOSE`](#ownerkind), [`OWNER_PROBE`](#ownerkind), [`OWNER_HANDSHAKE_DONE`](#ownerkind), [`OWNER_NEW_CID`](#ownerkind), [`OWNER_NEW_TOKEN`](#ownerkind), [`OWNER_MTU_PROBE`](#ownerkind) | |

| On `InitReason` | |
| :--- | :--- |
| [`INIT_OK`](#initreason), [`INIT_ARGUMENT`](#initreason), [`INIT_STORAGE_CAPACITY`](#initreason), [`INIT_STORAGE_RANGES`](#initreason), [`INIT_STORAGE_SECRETS`](#initreason), [`INIT_STORAGE_BORROWED`](#initreason), [`INIT_COMPONENT_RANGES`](#initreason), [`INIT_PROVIDER_RANGES`](#initreason), [`INIT_PROVIDER_SECRETS`](#initreason), [`INIT_COMPONENT_BORROWED`](#initreason), [`INIT_PRECONDITION`](#initreason), [`INIT_IDENTITY`](#initreason), [`INIT_PARAMETERS`](#initreason), [`INIT_RECOVERY`](#initreason), [`INIT_LEASE`](#initreason), [`INIT_KEYS`](#initreason), [`INIT_PATH`](#initreason), [`INIT_PROVIDER_START`](#initreason) | |

| On `Core` | |
| :--- | :--- |
| [`init_client_result`](#init_client_result), [`init_server_result`](#init_server_result), [`init_client`](#init_client), [`init_server`](#init_server) | |
| [`abandon_initialization`](#abandon_initialization) | rolls back a successful core init before the assembly becomes observable |
| [`release_secret_chunks`](#release_secret_chunks) | a dead core's secret chunks, given back whatever they hold |
| [`release_chunks`](#release_chunks) | a dead core's chunks, given back whatever they hold |
| [`receive`](#receive) | |
| [`queue_new_token`](#queue_new_token) | queues a NEW_TOKEN for the client, one at a time |
| [`take_received_token`](#take_received_token) | copies the client's received token out and releases it |
| [`probe_path`](#probe_path) | |
| [`issue_connection_id`](#issue_connection_id) | a local id the host minted, advertised with NEW_CONNECTION_ID once the application space can carry it |
| [`retire_connection_ids_prior_to`](#retire_connection_ids_prior_to) | raises the retire_prior_to the next NEW_CONNECTION_ID carries |
| [`migrate_path`](#migrate_path), [`queue_path_challenge`](#queue_path_challenge), [`on_path_packet_too_big`](#on_path_packet_too_big), [`poll_handshake`](#poll_handshake) | |
| [`storage_ready`](#storage_ready) | the connection's account woke: whatever the provider was refused for memory is tried again on the next call |
| [`snapshot`](#snapshot-1), [`generate`](#generate) | |
| [`handshake_pending`](#handshake_pending) | whether the provider may hand over crypto or events on its next poll: new crypto arrived, the pool woke a provider it refused, or its last poll did not end waiting for input |
| [`pending_output`](#pending_output) | whether the next generate at `now_ns` would produce a datagram, answered with nothing changed and nothing allocated, for a caller buffer of at least the connection's maximum UDP payload |
| [`complete_send`](#complete_send), [`timer`](#timer), [`on_timeout`](#on_timeout), [`begin_close`](#begin_close), [`close_ready`](#close_ready), [`finish_close`](#finish_close) | |

| Constants | |
| :--- | :--- |
| [`NO_ERROR`](#constants), [`INTERNAL_ERROR`](#constants), [`CONNECTION_REFUSED`](#constants), [`FLOW_CONTROL_ERROR`](#constants), [`STREAM_LIMIT_ERROR`](#constants), [`STREAM_STATE_ERROR`](#constants), [`FINAL_SIZE_ERROR`](#constants), [`FRAME_ENCODING_ERROR`](#constants), [`TRANSPORT_PARAMETER_ERROR`](#constants), [`CONNECTION_ID_LIMIT_ERROR`](#constants), [`PROTOCOL_VIOLATION`](#constants), [`INVALID_TOKEN`](#constants), [`APPLICATION_ERROR`](#constants), [`CRYPTO_BUFFER_EXCEEDED`](#constants), [`KEY_UPDATE_ERROR`](#constants), [`AEAD_LIMIT_REACHED`](#constants), [`NO_VIABLE_PATH`](#constants), [`CRYPTO_ERROR_BASE`](#constants), [`OWNER_FREE`](#constants), [`OWNER_PREPARED`](#constants), [`OWNER_SENT`](#constants) | |
| [`LEVEL_CONTEXT_SLOTS`](#constants) | the handshake levels that hold a secret chunk for their contexts |

---

## OwnerKind

```mach
pub def OwnerKind: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `OWNER_NONE` | `0` |  |
| `OWNER_ACK` | `1` |  |
| `OWNER_CRYPTO` | `2` |  |
| `OWNER_STREAM` | `3` |  |
| `OWNER_DATAGRAM` | `4` |  |
| `OWNER_PATH_CHALLENGE` | `5` |  |
| `OWNER_PATH_RESPONSE` | `6` |  |
| `OWNER_CID_RETIREMENT` | `7` |  |
| `OWNER_CLOSE` | `8` |  |
| `OWNER_PROBE` | `9` |  |
| `OWNER_HANDSHAKE_DONE` | `10` |  |
| `OWNER_NEW_CID` | `11` |  |
| `OWNER_NEW_TOKEN` | `12` |  |
| `OWNER_MTU_PROBE` | `13` |  |

## View

```mach
pub rec View { data: *u8; length: usize; }
```

## Config

```mach
pub rec Config {
    source:                     u64;
    role:                       quic.transport.Role;
    version:                    u32;
    supported_versions:         *u32;
    supported_version_count:    usize;
    local:                      std.net.ip.Endpoint;
    peer:                       std.net.ip.Endpoint;
    original_destination:       quic.packet.packet.ConnectionId;
    retry_source:               quic.packet.packet.ConnectionId;
    initial_secret_destination: quic.packet.packet.ConnectionId;
    local_source:               quic.packet.packet.ConnectionId;
    peer_destination:           quic.packet.packet.ConnectionId;
    alpn:                       View;
    server_name:                View;
    local_transport_parameters: View;
    max_udp_payload:            usize;
    max_idle_timeout_ns:        u64;
    drain_timeout_ns:           u64;
    peer_validated:             bool;
    retry_source_present:       bool;
    enable_early_data:          bool;
}
```

## OwnerToken

```mach
pub uni OwnerToken {
    handshake:      quic.connection.handshake.AttemptToken;
    stream:         quic.stream.stream.AttemptToken;
    datagram:       quic.stream.datagram.Token;
    path_challenge: quic.path.path.ChallengeToken;
    path_response:  quic.path.path.ResponseToken;
    mtu_probe:      quic.path.path.MtuToken;
    cid_retirement: quic.connection.cid.Handle;
}
```

## Owner

```mach
pub rec Owner {
    owner:          u64;
    generation:     u64;
    packet_number:  u64;
    bytes:          usize;
    space:          u8;
    level:          quic.connection.handshake.Level;
    kind:           OwnerKind;
    state:          u8;
    ack_generation: u64;
    # the token of the one frame this owner carries, read only under its kind
    token:                 OwnerToken;
    path:                  quic.path.path.Handle;
    path_send:             quic.path.path.SendToken;
    pacer:                 quic.congestion.pacer.Schedule;
    ack_largest:           u64;
    send_generation:       u64;
    ack_update_generation: u64;
    ack_eliciting:         bool;
    in_flight:             bool;
    growth_permitted:      bool;
    pto_probe:             bool;
    include_ping:          bool;
    minimum_datagram_size: u16;
}
```

## Storage

```mach
pub rec Storage {
    receive_header:                *u8;
    receive_header_capacity:       usize;
    receive_decoded:               *u8;
    receive_decoded_capacity:      usize;
    send_plaintext:                *u8;
    send_plaintext_capacity:       usize;
    close_reason:                  *u8;
    close_reason_capacity:         usize;
    frame_ack_ranges:              *quic.frame.frame.AckRange;
    frame_ack_capacity:            usize;
    recovery_events:               *quic.recovery.recovery.Event;
    recovery_event_capacity:       usize;
    recovery_initial:              quic.recovery.recovery.HistoryStorage;
    recovery_handshake:            quic.recovery.recovery.HistoryStorage;
    recovery_application:          quic.recovery.recovery.HistoryStorage;
    ack_initial:                   quic.recovery.ack.SpaceStorage;
    ack_handshake:                 quic.recovery.ack.SpaceStorage;
    ack_application:               quic.recovery.ack.SpaceStorage;
    owners:                        *Owner;
    owner_capacity:                usize;
    peer_extensions:               *quic.transport_parameters.Parameter;
    peer_extension_capacity:       usize;
    peer_extension_bytes:          *u8;
    peer_extension_byte_capacity:  usize;
    local_extensions:              *quic.transport_parameters.Parameter;
    local_extension_capacity:      usize;
    local_extension_bytes:         *u8;
    local_extension_byte_capacity: usize;
    negotiation:                   quic.connection.negotiation.Storage;
    # the chunk behind the extension tables, local parameter bytes and retry
    # storage, all of which the core lets go once the handshake is confirmed.
    # nil when the caller lends that storage for the connection's lifetime
    handshake_block: *quic.storage.chunks.Block;
    # where the core takes chunks for owners and packet histories that the
    # caller leaves nil, holding them only while packets are in flight
    chunk_source: quic.storage.ranges.Source;
}
```

## SecretStorage

```mach
pub rec SecretStorage {
    receive_plaintext:          *^u8;
    receive_plaintext_capacity: usize;
    send_plaintext:             *^u8;
    send_plaintext_capacity:    usize;
    # where the core takes one secret chunk per handshake level for that
    # level's expanded contexts, charged to the chunk source's account on the
    # send lane. it must bind typed views
    context_chunks: *quic.storage.source.SecretProvider;
}
```

## Secrets

```mach
pub rec Secrets {
    storage:             SecretStorage;
    handshake:           *quic.connection.handshake.Adapter;
    initial_keys:        quic.crypto.protection.InitialKeys;
    early_send:          quic.crypto.protection.KeySet;
    early_receive:       quic.crypto.protection.KeySet;
    handshake_send:      quic.crypto.protection.KeySet;
    handshake_receive:   quic.crypto.protection.KeySet;
    application_send:    quic.crypto.protection.SendKeys;
    application_receive: quic.crypto.protection.ReceiveKeys;
    # the secret chunk behind each handshake level's contexts while its keys
    # are live
    level_chunks: [LEVEL_CONTEXT_SLOTS]quic.storage.source.Chunk;
    initialized:  bool;
    destroyed:    bool;
}
```

## Snapshot

```mach
pub rec Snapshot {
    state:                 quic.transport.ConnectionState;
    version:               u32;
    authenticated_packets: usize;
    retry_count:           usize;
    version_restart_count: usize;
    active_owners:         usize;
    received_token_length: usize;
    # a queued NEW_TOKEN has not been acknowledged yet
    new_token_pending:      bool;
    early_disposition:      u8;
    peer_parameters_ready:  bool;
    peer_authenticated:     bool;
    handshake_confirmed:    bool;
    handshake_settled:      bool;
    handshake_waiting:      bool;
    initial_keys_discarded: bool;
    provider_error:         u64;
    closing:                bool;
    destroyed:              bool;
}
```

## InitReason

```mach
pub def InitReason: u64
```

why initialization refused. `error` stays the wire-facing transport code, so
a caller that only forwards a CONNECTION_CLOSE is unaffected; `reason` says
which check rejected. ownership validation alone can refuse in well over
sixty distinct ways and one undifferentiated INTERNAL_ERROR leaves a caller
bisecting its own buffer list by hand

| Name | Value | |
| :--- | :--- | :--- |
| `INIT_OK` | `0` |  |
| `INIT_ARGUMENT` | `1` |  |
| `INIT_STORAGE_CAPACITY` | `2` |  |
| `INIT_STORAGE_RANGES` | `3` |  |
| `INIT_STORAGE_SECRETS` | `4` |  |
| `INIT_STORAGE_BORROWED` | `5` |  |
| `INIT_COMPONENT_RANGES` | `6` |  |
| `INIT_PROVIDER_RANGES` | `7` |  |
| `INIT_PROVIDER_SECRETS` | `8` |  |
| `INIT_COMPONENT_BORROWED` | `9` |  |
| `INIT_PRECONDITION` | `10` |  |
| `INIT_IDENTITY` | `11` |  |
| `INIT_PARAMETERS` | `12` |  |
| `INIT_RECOVERY` | `13` |  |
| `INIT_LEASE` | `14` |  |
| `INIT_KEYS` | `15` |  |
| `INIT_PATH` | `16` |  |
| `INIT_PROVIDER_START` | `17` |  |

## InitResult

```mach
pub rec InitResult {
    ok:             bool;
    error:          u64;
    provider_error: u64;
    reason:         InitReason;
    reason_kind:    quic.connection.ownership.Overlap;
    reason_first:   usize;
    reason_second:  usize;
}
```

`reason_kind` and the two indices are only populated for the ownership
reasons. an index is a position in the range list the named check built:
INIT_STORAGE_* index the twenty-three owned storage ranges, INIT_COMPONENT_*
and INIT_PROVIDER_RANGES index the sixty-three component ranges, whose first
twenty-three entries are the storage ranges in the same order. for a
_BORROWED reason `reason_first` is instead the borrowed range's own index and
`reason_second` is the owned range it collided with

## Core

```mach
pub rec Core {
    config:      Config;
    storage:     Storage;
    cids:        *quic.connection.cid.Manager;
    paths:       *quic.path.path.Manager;
    streams:     *quic.stream.stream.Manager;
    datagrams:   *quic.stream.datagram.Queue;
    negotiation: quic.connection.negotiation.Client;
    # the live owner table: lent for the lifetime, or a chunk held while any
    # owner is active, and nil with no capacity otherwise
    owners:                     *Owner;
    owner_capacity:             usize;
    owners_active:              usize;
    owner_block:                quic.storage.chunks.Block;
    history_blocks:             [3]quic.storage.chunks.Block;
    recovery_state:             quic.recovery.recovery.Recovery;
    acknowledgements:           quic.recovery.ack.Tracker;
    peer_parameters:            quic.transport_parameters.Parameters;
    local_parameters:           quic.transport_parameters.Parameters;
    retry_source_connection_id: quic.packet.packet.ConnectionId;
    packet_numbers:             [3]u64;
    expected_packet_numbers:    [3]u64;
    ack_prepared:               [3]bool;
    # NEW_TOKEN payloads, each in a chunk held only while it is waiting: the
    # client's until the owner takes it, the server's until it is acknowledged
    received_token:            quic.storage.source.Chunk;
    received_token_length:     usize;
    send_token:                quic.storage.source.Chunk;
    send_token_length:         usize;
    send_max_udp_payload:      usize;
    idle_timeout_ns:           u64;
    next_owner:                u64;
    next_owner_slot:           usize;
    last_received_ns:          u64;
    last_activity_ns:          u64;
    last_now_ns:               u64;
    close_started_ns:          u64;
    close_deadline_ns:         u64;
    close_error:               u64;
    close_frame_type:          u64;
    close_reason_length:       usize;
    last_provider_error:       u64;
    timer_generation:          u64;
    timer_deadline_ns:         u64;
    pace_deadline_ns:          u64;
    early_discard_ns:          u64;
    timer_recovery_generation: u64;
    timer_kind:                u8;
    state:                     quic.transport.ConnectionState;
    early_disposition:         u8;
    role:                      quic.transport.Role;
    authenticated_packets:     usize;
    retry_count:               usize;
    version_restart_count:     usize;
    close_transmissions:       usize;
    probes_remaining:          u8;
    probe_space:               u8;
    probe_owner:               u64;
    peer_parameters_ready:     bool;
    retry_source_present:      bool;
    peer_authenticated:        bool;
    handshake_confirmed:       bool;
    # the packet being applied was refused for storage and stays unacknowledged
    packet_refused: bool;
    # packets refused that way
    refused_packets: u64;
    # crypto data arrived that the provider has not been polled for
    crypto_received: bool;
    # the provider is waiting for memory, so polling it waits for a wake
    handshake_waiting: bool;
    # the connection's account woke, so the provider is polled once more
    storage_woken: bool;
    # the provider's last poll ended waiting for input, so without new crypto
    # or a wake its next poll hands over nothing
    handshake_quiet: bool;
    # the pool refused a chunk a send needed and has not woken the account
    # since, so sends that need one wait for storage_ready
    send_refused: bool;
    # the handshake handed everything over and holds no memory
    handshake_settled: bool;
    # the last generate found nothing to send and nothing has changed since:
    # no core input, no manager revision, no due ack or pacing deadline
    send_idle:              bool;
    idle_stream_revision:   u64;
    idle_datagram_revision: u64;
    idle_deadline_ns:       u64;
    # the last timer answer, valid until an input changes the core
    timer_cached:           bool;
    timer_cache:            quic.transport.CoreTimer;
    initial_keys_discarded: bool;
    close_queued:           bool;
    handshake_done_queued:  bool;
    peer_close_received:    bool;
    send_token_queued:      bool;
    send_token_prepared:    bool;
    idle_timer_enabled:     bool;
    initialized:            bool;
    closing:                bool;
    destroyed:              bool;
    # owned_range for every OWNED_* index, kept current by the sites that move them
    owned: [OWNED_RANGES]quic.connection.ownership.Range;
}
```

### init_client_result

```mach
pub fun init_client_result(core: *Core, secrets: *Secrets, config: Config,
    storage: Storage, secret_storage: SecretStorage,
    handshake: *quic.connection.handshake.Adapter,
    cids: *quic.connection.cid.Manager, paths: *quic.path.path.Manager,
    streams: *quic.stream.stream.Manager,
    datagrams: *quic.stream.datagram.Queue,
    now_ns: u64) InitResult
```

### init_server_result

```mach
pub fun init_server_result(core: *Core, secrets: *Secrets, config: Config,
    storage: Storage, secret_storage: SecretStorage,
    handshake: *quic.connection.handshake.Adapter,
    cids: *quic.connection.cid.Manager, paths: *quic.path.path.Manager,
    streams: *quic.stream.stream.Manager,
    datagrams: *quic.stream.datagram.Queue,
    now_ns: u64) InitResult
```

### init_client

```mach
pub fun init_client(core: *Core, secrets: *Secrets, config: Config, storage: Storage,
    secret_storage: SecretStorage,
    handshake: *quic.connection.handshake.Adapter, cids: *quic.connection.cid.Manager,
    paths: *quic.path.path.Manager, streams: *quic.stream.stream.Manager,
    datagrams: *quic.stream.datagram.Queue, now_ns: u64) bool
```

### init_server

```mach
pub fun init_server(core: *Core, secrets: *Secrets, config: Config, storage: Storage,
    secret_storage: SecretStorage,
    handshake: *quic.connection.handshake.Adapter, cids: *quic.connection.cid.Manager,
    paths: *quic.path.path.Manager, streams: *quic.stream.stream.Manager,
    datagrams: *quic.stream.datagram.Queue, now_ns: u64) bool
```

### abandon_initialization

```mach
pub fun abandon_initialization(core: *Core, secrets: *Secrets) bool
```

rolls back a successful core init before the assembly becomes observable

### release_secret_chunks

```mach
pub fun release_secret_chunks(core: *Core, secrets: *Secrets)
```

a dead core's secret chunks, given back whatever they hold

### release_chunks

```mach
pub fun release_chunks(core: *Core)
```

a dead core's chunks, given back whatever they hold

### receive

```mach
pub fun receive(core: *Core, secrets: *Secrets,
    input: *quic.transport.CoreInput) quic.transport.CoreResult
```

### queue_new_token

```mach
pub fun queue_new_token(core: *Core, data: *u8, length: usize) quic.transport.Status
```

queues a NEW_TOKEN for the client, one at a time

| Parameter | |
| :--- | :--- |
| **returns** | STATUS_OK once queued. STATUS_EARLY while an earlier token is still unacknowledged: repeat once `snapshot().new_token_pending` clears. STATUS_BLOCKED when no chunk is free: repeat once the connection's account is woken. STATUS_ERROR for a call that can never succeed as made |

### take_received_token

```mach
pub fun take_received_token(core: *Core, output: *u8,
    capacity: usize) TakenToken
```

copies the client's received token out and releases it. STATUS_EMPTY when
none is waiting. when `capacity` is too small nothing is released, and
`length` says how much room the token needs

### probe_path

```mach
pub fun probe_path(core: *Core, endpoint: quic.path.path.Endpoint,
    preferred: bool) quic.path.path.PathResult
```

### issue_connection_id

```mach
pub fun issue_connection_id(core: *Core, id: quic.packet.packet.ConnectionId,
    reset_token: [16]u8) quic.connection.cid.Result
```

a local id the host minted, advertised with NEW_CONNECTION_ID once the
application space can carry it

### retire_connection_ids_prior_to

```mach
pub fun retire_connection_ids_prior_to(core: *Core, sequence: u64) quic.connection.cid.Result
```

raises the retire_prior_to the next NEW_CONNECTION_ID carries

### migrate_path

```mach
pub fun migrate_path(core: *Core, value: quic.path.path.Handle, preferred: bool,
    now_ns: u64) quic.path.path.Observation
```

### queue_path_challenge

```mach
pub fun queue_path_challenge(core: *Core, value: quic.path.path.Handle,
    data: [8]u8, padded: bool,
    purpose: u8) quic.path.path.OperationResult
```

### on_path_packet_too_big

```mach
pub fun on_path_packet_too_big(core: *Core, value: quic.path.path.Handle,
    reported_mtu: u16,
    quote_authenticated: bool,
    now_ns: u64) quic.path.path.MtuResult
```

### poll_handshake

```mach
pub fun poll_handshake(core: *Core, secrets: *Secrets,
    now_ns: u64) quic.transport.CoreResult
```

### storage_ready

```mach
pub fun storage_ready(core: *Core)
```

the connection's account woke: whatever the provider was refused for memory
is tried again on the next call

### snapshot

```mach
pub fun snapshot(core: *Core) Snapshot
```

### generate

```mach
pub fun generate(core: *Core, secrets: *Secrets, output: *u8,
    capacity: usize, now_ns: u64) quic.transport.CoreDatagram
```

### handshake_pending

```mach
pub fun handshake_pending(core: *Core) bool
```

whether the provider may hand over crypto or events on its next poll: new
crypto arrived, the pool woke a provider it refused, or its last poll did
not end waiting for input. pending_output answers true while it holds

### pending_output

```mach
pub fun pending_output(core: *Core, secrets: *Secrets, now_ns: u64) bool
```

whether the next generate at `now_ns` would produce a datagram, answered with
nothing changed and nothing allocated, for a caller buffer of at least the
connection's maximum UDP payload. it is exact but for two edges, each where
generate learns its answer only by acting:
- handshake work pending (handshake_pending) answers true, since only
  running the provider tells whether it yields a flight
- storage: while the pool's last refusal on the send path stands (until
  storage_ready), a send needing a chunk the connection does not hold
  answers false. otherwise the pool is assumed to grant it

### complete_send

```mach
pub fun complete_send(core: *Core, secrets: *Secrets, owner_id: u64,
    status: quic.transport.SendStatus, count: usize,
    now_ns: u64) quic.transport.CoreResult
```

### timer

```mach
pub fun timer(core: *Core) quic.transport.CoreTimer
```

### on_timeout

```mach
pub fun on_timeout(core: *Core, secrets: *Secrets, generation: u64,
    now_ns: u64) quic.transport.CoreResult
```

### begin_close

```mach
pub fun begin_close(core: *Core, secrets: *Secrets, abortive: bool,
    application_error: u64, reason: *u8,
    reason_length: usize, now_ns: u64) quic.transport.CoreResult
```

### close_ready

```mach
pub fun close_ready(core: *Core) bool
```

### finish_close

```mach
pub fun finish_close(core: *Core, secrets: *Secrets) bool
```

## TakenToken

```mach
pub rec TakenToken {
    status: quic.transport.Status;
    length: usize;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `NO_ERROR` | `u64` | `0x00` |  |
| `INTERNAL_ERROR` | `u64` | `0x01` |  |
| `CONNECTION_REFUSED` | `u64` | `0x02` |  |
| `FLOW_CONTROL_ERROR` | `u64` | `0x03` |  |
| `STREAM_LIMIT_ERROR` | `u64` | `0x04` |  |
| `STREAM_STATE_ERROR` | `u64` | `0x05` |  |
| `FINAL_SIZE_ERROR` | `u64` | `0x06` |  |
| `FRAME_ENCODING_ERROR` | `u64` | `0x07` |  |
| `TRANSPORT_PARAMETER_ERROR` | `u64` | `0x08` |  |
| `CONNECTION_ID_LIMIT_ERROR` | `u64` | `0x09` |  |
| `PROTOCOL_VIOLATION` | `u64` | `0x0a` |  |
| `INVALID_TOKEN` | `u64` | `0x0b` |  |
| `APPLICATION_ERROR` | `u64` | `0x0c` |  |
| `CRYPTO_BUFFER_EXCEEDED` | `u64` | `0x0d` |  |
| `KEY_UPDATE_ERROR` | `u64` | `0x0e` |  |
| `AEAD_LIMIT_REACHED` | `u64` | `0x0f` |  |
| `NO_VIABLE_PATH` | `u64` | `0x10` |  |
| `CRYPTO_ERROR_BASE` | `u64` | `0x100` |  |
| `OWNER_FREE` | `u8` | `0` |  |
| `OWNER_PREPARED` | `u8` | `1` |  |
| `OWNER_SENT` | `u8` | `2` |  |
| `LEVEL_CONTEXT_SLOTS` | `usize` | `3` | the handshake levels that hold a secret chunk for their contexts |

