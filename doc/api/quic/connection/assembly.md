[quic](../README.md) / [connection](README.md) / **assembly**

# quic.connection.assembly

assembles a connection core and every manager it owns from one configuration

the core validates twelve exact equalities between its encoded local transport
parameters and the manager configurations those parameters describe. deriving
both from a single record is the only way that agreement is structural rather
than something each consumer rediscovers.

Source: [`src/connection/assembly.mach`](../../../../src/connection/assembly.mach)

Uses types from [`quic.connection.cid`](cid.md), [`quic.connection.core`](core.md), [`quic.connection.handshake`](handshake.md), [`quic.connection.listener`](listener.md), [`quic.connection.scratch`](scratch.md), [`quic.path.path`](../path/path.md), [`quic.recovery.ack`](../recovery/ack.md), [`quic.storage.chunks`](../storage/chunks.md), [`quic.storage.source`](../storage/source.md), [`quic.stream.datagram`](../stream/datagram.md), [`quic.stream.stream`](../stream/stream.md), [`quic.transport`](../transport.md), [`quic.transport.binding`](../transport/binding.md), [`quic.transport_parameters`](../transport_parameters.md).

| Type | | |
| :--- | :--- | :--- |
| [`Stage`](#stage) | `def` |  |
| [`InitResult`](#initresult) | `rec` | `core` carries the reason code the core itself reported, so a refusal at STAGE_CORE names which ownership or precondition check rejected |
| [`RoutingId`](#routingid) | `rec` |  |
| [`Route`](#route) | `rec` |  |
| [`RoutingSnapshot`](#routingsnapshot) | `rec` |  |
| [`ConnectionIds`](#connectionids) | `rec` | the local connection ids a host may still issue, and where their sequences stand |
| [`IssuedId`](#issuedid) | `rec` |  |
| [`Config`](#config) | `rec` |  |
| [`Storage`](#storage) | `rec` | fixed arrays make the public backing size part of the type |
| [`Scratch`](#scratch) | `def` | per-call buffers, one pair per pump shared by every connection on it |
| [`SecretScratch`](#secretscratch) | `def` |  |
| [`Connection`](#connection) | `rec` |  |

| On `Stage` | |
| :--- | :--- |
| [`STAGE_OK`](#stage), [`STAGE_CONFIG`](#stage), [`STAGE_STREAMS`](#stage), [`STAGE_CONNECTION_IDS`](#stage), [`STAGE_PATHS`](#stage), [`STAGE_DATAGRAMS`](#stage), [`STAGE_HANDSHAKE`](#stage), [`STAGE_PARAMETERS`](#stage), [`STAGE_CORE`](#stage), [`STAGE_BINDING`](#stage), [`STAGE_DRIVER`](#stage), [`STAGE_STORAGE`](#stage) | |
| [`STAGE_SCRATCH`](#stage) | the scratch pair was in use by another call when the core started |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config) | |
| [`apply_server_acceptance`](#apply_server_acceptance) | applies the listener's complete acceptance as one configuration transaction |
| [`encode_parameters`](#encode_parameters) | the consumer needs these bytes before the connection exists, because its TLS engine carries them as the quic_transport_parameters extension |

| On `Connection` | |
| :--- | :--- |
| [`tls_lease`](#tls_lease) | the memory a tls engine for `c` must be initialized with, before init_client or init_server |
| [`routing_snapshot`](#routing_snapshot), [`route_at`](#route_at), [`route_valid`](#route_valid), [`connection_ids`](#connection_ids) | |
| [`issue_connection_id`](#issue_connection_id) | issues a local connection id the host minted, with its stateless reset token |
| [`retire_connection_ids_prior_to`](#retire_connection_ids_prior_to) | asks the peer to retire every local id below `sequence`, carried by the next NEW_CONNECTION_ID |
| [`release_closed`](#release_closed) | release is serialized by the connection owner |
| [`tls_released`](#tls_released) | the connection no longer refers to the tls handshake record it was initialized with: the handshake finished and only its established core, held inside `c`, remains |
| [`reusable`](#reusable) | |
| [`init_client`](#init_client) | `tls` must have been initialized with tls_lease(c), and is refused at STAGE_HANDSHAKE otherwise |
| [`init_server`](#init_server) | `tls` must have been initialized with tls_lease(c), and is refused at STAGE_HANDSHAKE otherwise |

| Constants | |
| :--- | :--- |
| [`MAX_UDP_PAYLOAD`](#constants) | the largest UDP payload a connection handles, which its scratch is sized for |
| [`CRYPTO_PER_LEVEL`](#constants) | crypto bytes a level may carry, each level holding at most one chunk |
| [`H3_CRITICAL_STREAMS_PER_PEER`](#constants), [`H3_REQUEST_STREAMS`](#constants), [`STREAM_CAPACITY`](#constants), [`STREAM_STRIDE`](#constants), [`STREAM_WINDOW`](#constants), [`STREAM_ATTEMPT_CAPACITY`](#constants), [`DATAGRAM_CAPACITY`](#constants), [`DATAGRAM_STRIDE`](#constants), [`CONNECTION_ID_CAPACITY`](#constants), [`OWNER_CAPACITY`](#constants), [`TOKEN_CAPACITY`](#constants), [`PARAMETER_CAPACITY`](#constants), [`SEND_CAPACITY`](#constants) | |
| [`TLS_BUDGET`](#constants) | the default for Config.tls_budget, room for a handshake's records and messages at once |

---

## Stage

```mach
pub def Stage: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STAGE_OK` | `0` |  |
| `STAGE_CONFIG` | `1` |  |
| `STAGE_STREAMS` | `2` |  |
| `STAGE_CONNECTION_IDS` | `3` |  |
| `STAGE_PATHS` | `4` |  |
| `STAGE_DATAGRAMS` | `5` |  |
| `STAGE_HANDSHAKE` | `6` |  |
| `STAGE_PARAMETERS` | `7` |  |
| `STAGE_CORE` | `8` |  |
| `STAGE_BINDING` | `9` |  |
| `STAGE_DRIVER` | `10` |  |
| `STAGE_STORAGE` | `11` |  |
| `STAGE_SCRATCH` | `12` | the scratch pair was in use by another call when the core started |

## InitResult

```mach
pub rec InitResult {
    ok:               bool;
    stage:            Stage;
    core:             quic.connection.core.InitResult;
    cleanup_retained: bool;
}
```

`core` carries the reason code the core itself reported, so a refusal at
STAGE_CORE names which ownership or precondition check rejected

## RoutingId

```mach
pub rec RoutingId {
    data:   [20]u8;
    length: usize;
}
```

## Route

```mach
pub rec Route {
    source:     u64;
    index:      usize;
    generation: u64;
    sequence:   u64;
    id:         RoutingId;
    active:     bool;
}
```

## RoutingSnapshot

```mach
pub rec RoutingSnapshot {
    source:      u64;
    capacity:    usize;
    active:      usize;
    initialized: bool;
}
```

## ConnectionIds

```mach
pub rec ConnectionIds {
    wanted:          usize;
    next_sequence:   u64;
    retire_prior_to: u64;
}
```

the local connection ids a host may still issue, and where their sequences
stand. `wanted` is zero until the peer's transport parameters set its limit

## IssuedId

```mach
pub rec IssuedId {
    ok:       bool;
    sequence: u64;
}
```

## Config

```mach
pub rec Config {
    source:                      u64;
    version:                     u32;
    local:                       std.net.ip.Endpoint;
    peer:                        std.net.ip.Endpoint;
    local_source:                *u8;
    local_source_length:         usize;
    peer_destination:            *u8;
    peer_destination_length:     usize;
    original_destination:        *u8;
    original_destination_length: usize;
    initial_destination:         *u8;
    initial_destination_length:  usize;
    retry_source:                *u8;
    retry_source_length:         usize;
    alpn:                        *u8;
    alpn_length:                 usize;
    server_name:                 *u8;
    server_name_length:          usize;
    max_udp_payload:             usize;
    # the idle timeout advertised to the peer, whole milliseconds on the wire
    max_idle_timeout:            std.chrono.duration.Duration;
    drain_timeout:               std.chrono.duration.Duration;
    peer_bidirectional_streams:  u64;
    peer_unidirectional_streams: u64;
    receive_max_data:            u64;
    receive_stream_data:         u64;
    active_connection_id_limit:  u64;
    max_datagram_frame_size:     usize;
    # when the handshake must have finished, on the monotonic clock
    tls_deadline:                opt[std.chrono.time.Instant];
    entropy_context_size:        usize;
    entropy_secret_context_size: usize;
    # chunks the pool sets aside for this connection alone
    chunk_reserve: usize;
    # bytes tls may hold on its own lane. this is a slice of the connection's
    # single account, not an allowance beside it
    tls_budget: usize;
    # the caller's own budgets, in bytes, on the lanes after quic's three.
    # the source must declare exactly supply.LANES + extra_lanes lanes, and a
    # total above supply.MAX_LANES is refused at STAGE_CONFIG
    extra_budgets: *usize;
    extra_lanes:   usize;
    # the handle the connection's account is opened under, `source` unless the
    # caller composes the account into its own space. a wake the source reports
    # for this handle must reach transport.storage_ready for this connection.
    # a stale or foreign wake is harmless. it is fixed for the account's life
    account_handle: u64;
    # the server's stateless reset token for its handshake connection id, sent
    # as the stateless_reset_token transport parameter. a client sets none
    stateless_reset_token:         [16]u8;
    stateless_reset_token_present: bool;
    peer_validated:                bool;
    retry_source_present:          bool;
    server_acceptance_applied:     bool;
    enable_early_data:             bool;
}
```

### default_config

```mach
pub fun default_config(source: u64, local: std.net.ip.Endpoint,
    peer: std.net.ip.Endpoint) Config
```

### apply_server_acceptance

```mach
pub fun apply_server_acceptance(config: *Config,
    accepted: *quic.connection.listener.Accepted) bool
```

applies the listener's complete acceptance as one configuration transaction.
accepted must remain at a fixed address through parameter encoding and init

### encode_parameters

```mach
pub fun encode_parameters(config: *Config, role: quic.transport.Role,
    output: *u8,
    capacity: usize) quic.transport_parameters.EncodeResult
```

the consumer needs these bytes before the connection exists, because its TLS
engine carries them as the quic_transport_parameters extension. re-deriving
them inside init from the same config is what keeps the two copies identical

## Storage

```mach
pub rec Storage {
    sends:                    [SEND_CAPACITY]quic.transport.SendSlot;
    supported_versions:       [2]u32;
    close_reason:             [256]u8;
    ack_application:          [32]quic.recovery.ack.Range;
    crypto_attempts:          [8]quic.connection.handshake.Attempt;
    local_cids:               [CONNECTION_ID_CAPACITY]quic.connection.cid.Entry;
    peer_cids:                [CONNECTION_ID_CAPACITY]quic.connection.cid.Entry;
    path_values:              [2]quic.path.path.Path;
    path_challenges:          [4]quic.path.path.Challenge;
    path_responses:           [4]quic.path.path.Response;
    path_sends:               [8]quic.path.path.SendReservation;
    datagram_send_entries:    [DATAGRAM_CAPACITY]quic.stream.datagram.Entry;
    datagram_receive_entries: [DATAGRAM_CAPACITY]quic.stream.datagram.Entry;
    source:                   u64;
    generation:               u64;
    leased:                   bool;
}
```

fixed arrays make the public backing size part of the type

## Scratch

```mach
pub def Scratch:       quic.connection.scratch.Scratch
```

per-call buffers, one pair per pump shared by every connection on it. a
connection binds its pair at init, and the pair must outlive the connection.
the secret half is allocated only through classification-preserving ownership

## SecretScratch

```mach
pub def SecretScratch: quic.connection.scratch.SecretScratch
```

## Connection

```mach
pub rec Connection {
    core:           quic.connection.core.Core;
    secrets:        quic.connection.core.Secrets;
    handshake:      quic.connection.handshake.Adapter;
    cids:           quic.connection.cid.Manager;
    paths:          quic.path.path.Manager;
    streams:        quic.stream.stream.Manager;
    datagrams:      quic.stream.datagram.Queue;
    binding:        quic.transport.binding.Binding;
    driver:         quic.transport.Driver[quic.transport.binding.Binding];
    storage:        *Storage;
    scratch:        *Scratch;
    secret_scratch: *SecretScratch;
    # every chunk comes from the caller's buffer source, counted against this
    # connection's account
    provider: quic.storage.source.Provider;
    account:  quic.storage.source.Account;
    # the same account's secret chunks, which hold handshake keys' contexts
    secret_provider: quic.storage.source.SecretProvider;
    # handshake-only state, held until the core confirms the handshake
    handshake_block:        quic.storage.chunks.Block;
    storage_generation:     u64;
    local_parameter_length: usize;
    initialized:            bool;
    released:               bool;
}
```

### tls_lease

```mach
pub fun tls_lease(c: *Connection) tls.buffer.Lease
```

the memory a tls engine for `c` must be initialized with, before init_client
or init_server. it points into `c`, so `c` must not move or be copied from
the moment the lease is taken until the connection is released. init opens
the account behind it and refuses an engine holding any other lease

### routing_snapshot

```mach
pub fun routing_snapshot(c: *Connection) RoutingSnapshot
```

### route_at

```mach
pub fun route_at(c: *Connection, index: usize) Route
```

### route_valid

```mach
pub fun route_valid(c: *Connection, route: *Route) bool
```

### connection_ids

```mach
pub fun connection_ids(c: *Connection) ConnectionIds
```

### issue_connection_id

```mach
pub fun issue_connection_id(c: *Connection, id: *u8, length: usize,
    reset_token: [16]u8) IssuedId
```

issues a local connection id the host minted, with its stateless reset
token. its route is published before this returns, and the core advertises
it with NEW_CONNECTION_ID. refused while `connection_ids` wants none

### retire_connection_ids_prior_to

```mach
pub fun retire_connection_ids_prior_to(c: *Connection, sequence: u64) bool
```

asks the peer to retire every local id below `sequence`, carried by the next
NEW_CONNECTION_ID. an id the peer never learned leaves at once with its
route. the others keep their routes until the peer retires them

### release_closed

```mach
pub fun release_closed(c: *Connection) bool
```

release is serialized by the connection owner. refusal leaves the complete
assembly intact. success is idempotent and preserves token generations while
removing every live protocol and caller-borrowed reference

### tls_released

```mach
pub fun tls_released(c: *Connection) bool
```

the connection no longer refers to the tls handshake record it was
initialized with: the handshake finished and only its established core, held
inside `c`, remains. the record may then be initialized for another
connection

### reusable

```mach
pub fun reusable(c: *Connection) bool
```

### init_client

```mach
pub fun init_client(c: *Connection, config: *Config, storage: *Storage,
    work: *Scratch, secret_work: *SecretScratch, chunks: std.memory.buffers.Source,
    secret_chunks: std.memory.buffers.SecretSource,
    tls: *tls.client.Handshake,
    scope: *std.sync.cancel.Scope, now: std.chrono.time.Instant) InitResult
```

`tls` must have been initialized with tls_lease(c), and is refused at
STAGE_HANDSHAKE otherwise. it must stay put until tls_released(c). `chunks`
must declare exactly supply.LANES + config.extra_lanes lanes, and
`secret_chunks` must serve the same pool and bind typed views (`fn_bind`)

### init_server

```mach
pub fun init_server(c: *Connection, config: *Config, storage: *Storage,
    work: *Scratch, secret_work: *SecretScratch, chunks: std.memory.buffers.Source,
    secret_chunks: std.memory.buffers.SecretSource,
    tls: *tls.server.Handshake,
    scope: *std.sync.cancel.Scope, now: std.chrono.time.Instant) InitResult
```

`tls` must have been initialized with tls_lease(c), and is refused at
STAGE_HANDSHAKE otherwise. it must stay put until tls_released(c). `chunks`
must declare exactly supply.LANES + config.extra_lanes lanes, and
`secret_chunks` must serve the same pool and bind typed views (`fn_bind`)

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `MAX_UDP_PAYLOAD` | `usize` | `scratch_api.PAYLOAD` | the largest UDP payload a connection handles, which its scratch is sized for |
| `CRYPTO_PER_LEVEL` | `usize` | `4096` | crypto bytes a level may carry, each level holding at most one chunk |
| `H3_CRITICAL_STREAMS_PER_PEER` | `usize` | `3` |  |
| `H3_REQUEST_STREAMS` | `usize` | `8` |  |
| `STREAM_CAPACITY` | `usize` | `16` |  |
| `STREAM_STRIDE` | `usize` | `4096` |  |
| `STREAM_WINDOW` | `usize` | `STREAM_CAPACITY * STREAM_STRIDE` |  |
| `STREAM_ATTEMPT_CAPACITY` | `usize` | `STREAM_CAPACITY * 2` |  |
| `DATAGRAM_CAPACITY` | `usize` | `4` |  |
| `DATAGRAM_STRIDE` | `usize` | `1200` |  |
| `CONNECTION_ID_CAPACITY` | `usize` | `binding_api.ROUTING_ID_CAPACITY` |  |
| `OWNER_CAPACITY` | `usize` | `16` |  |
| `TOKEN_CAPACITY` | `usize` | `512` |  |
| `PARAMETER_CAPACITY` | `usize` | `512` |  |
| `SEND_CAPACITY` | `usize` | `4` |  |
| `TLS_BUDGET` | `usize` | `64 * 1024` | the default for Config.tls_budget, room for a handshake's records and messages at once |

