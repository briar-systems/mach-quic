# quic.connection.core

## val NO_ERROR

```mach
pub val NO_ERROR:                  u64 = 0x00
```

## val INTERNAL_ERROR

```mach
pub val INTERNAL_ERROR:            u64 = 0x01
```

## val CONNECTION_REFUSED

```mach
pub val CONNECTION_REFUSED:        u64 = 0x02
```

## val FLOW_CONTROL_ERROR

```mach
pub val FLOW_CONTROL_ERROR:        u64 = 0x03
```

## val STREAM_LIMIT_ERROR

```mach
pub val STREAM_LIMIT_ERROR:        u64 = 0x04
```

## val STREAM_STATE_ERROR

```mach
pub val STREAM_STATE_ERROR:        u64 = 0x05
```

## val FINAL_SIZE_ERROR

```mach
pub val FINAL_SIZE_ERROR:          u64 = 0x06
```

## val FRAME_ENCODING_ERROR

```mach
pub val FRAME_ENCODING_ERROR:      u64 = 0x07
```

## val TRANSPORT_PARAMETER_ERROR

```mach
pub val TRANSPORT_PARAMETER_ERROR: u64 = 0x08
```

## val CONNECTION_ID_LIMIT_ERROR

```mach
pub val CONNECTION_ID_LIMIT_ERROR: u64 = 0x09
```

## val PROTOCOL_VIOLATION

```mach
pub val PROTOCOL_VIOLATION:        u64 = 0x0a
```

## val INVALID_TOKEN

```mach
pub val INVALID_TOKEN:             u64 = 0x0b
```

## val APPLICATION_ERROR

```mach
pub val APPLICATION_ERROR:         u64 = 0x0c
```

## val CRYPTO_BUFFER_EXCEEDED

```mach
pub val CRYPTO_BUFFER_EXCEEDED:    u64 = 0x0d
```

## val KEY_UPDATE_ERROR

```mach
pub val KEY_UPDATE_ERROR:          u64 = 0x0e
```

## val AEAD_LIMIT_REACHED

```mach
pub val AEAD_LIMIT_REACHED:        u64 = 0x0f
```

## val NO_VIABLE_PATH

```mach
pub val NO_VIABLE_PATH:            u64 = 0x10
```

## val CRYPTO_ERROR_BASE

```mach
pub val CRYPTO_ERROR_BASE:         u64 = 0x100
```

## def OwnerKind

```mach
pub def OwnerKind: u8
```

## val OWNER_NONE

```mach
pub val OWNER_NONE:           OwnerKind = 0
```

## val OWNER_ACK

```mach
pub val OWNER_ACK:            OwnerKind = 1
```

## val OWNER_CRYPTO

```mach
pub val OWNER_CRYPTO:         OwnerKind = 2
```

## val OWNER_STREAM

```mach
pub val OWNER_STREAM:         OwnerKind = 3
```

## val OWNER_DATAGRAM

```mach
pub val OWNER_DATAGRAM:       OwnerKind = 4
```

## val OWNER_PATH_CHALLENGE

```mach
pub val OWNER_PATH_CHALLENGE: OwnerKind = 5
```

## val OWNER_PATH_RESPONSE

```mach
pub val OWNER_PATH_RESPONSE:  OwnerKind = 6
```

## val OWNER_CID_RETIREMENT

```mach
pub val OWNER_CID_RETIREMENT: OwnerKind = 7
```

## val OWNER_CLOSE

```mach
pub val OWNER_CLOSE:          OwnerKind = 8
```

## val OWNER_PROBE

```mach
pub val OWNER_PROBE:          OwnerKind = 9
```

## val OWNER_HANDSHAKE_DONE

```mach
pub val OWNER_HANDSHAKE_DONE: OwnerKind = 10
```

## val OWNER_NEW_CID

```mach
pub val OWNER_NEW_CID:        OwnerKind = 11
```

## val OWNER_NEW_TOKEN

```mach
pub val OWNER_NEW_TOKEN:      OwnerKind = 12
```

## val OWNER_MTU_PROBE

```mach
pub val OWNER_MTU_PROBE:      OwnerKind = 13
```

## val OWNER_FREE

```mach
pub val OWNER_FREE:     u8 = 0
```

## val OWNER_PREPARED

```mach
pub val OWNER_PREPARED: u8 = 1
```

## val OWNER_SENT

```mach
pub val OWNER_SENT:     u8 = 2
```

## rec View

```mach
pub rec View;
```

## rec Config

```mach
pub rec Config;
```

## uni OwnerToken

```mach
pub uni OwnerToken;
```

## rec Owner

```mach
pub rec Owner;
```

## rec Storage

```mach
pub rec Storage;
```

## rec SecretStorage

```mach
pub rec SecretStorage;
```

## rec Secrets

```mach
pub rec Secrets;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## def InitReason

```mach
pub def InitReason: u64
```

why initialization refused. `error` stays the wire-facing transport code, so
a caller that only forwards a CONNECTION_CLOSE is unaffected; `reason` says
which check rejected. ownership validation alone can refuse in well over
sixty distinct ways and one undifferentiated INTERNAL_ERROR leaves a caller
bisecting its own buffer list by hand

## val INIT_OK

```mach
pub val INIT_OK:                 InitReason = 0
```

## val INIT_ARGUMENT

```mach
pub val INIT_ARGUMENT:           InitReason = 1
```

## val INIT_STORAGE_CAPACITY

```mach
pub val INIT_STORAGE_CAPACITY:   InitReason = 2
```

## val INIT_STORAGE_RANGES

```mach
pub val INIT_STORAGE_RANGES:     InitReason = 3
```

## val INIT_STORAGE_SECRETS

```mach
pub val INIT_STORAGE_SECRETS:    InitReason = 4
```

## val INIT_STORAGE_BORROWED

```mach
pub val INIT_STORAGE_BORROWED:   InitReason = 5
```

## val INIT_COMPONENT_RANGES

```mach
pub val INIT_COMPONENT_RANGES:   InitReason = 6
```

## val INIT_PROVIDER_RANGES

```mach
pub val INIT_PROVIDER_RANGES:    InitReason = 7
```

## val INIT_PROVIDER_SECRETS

```mach
pub val INIT_PROVIDER_SECRETS:   InitReason = 8
```

## val INIT_COMPONENT_BORROWED

```mach
pub val INIT_COMPONENT_BORROWED: InitReason = 9
```

## val INIT_PRECONDITION

```mach
pub val INIT_PRECONDITION:       InitReason = 10
```

## val INIT_IDENTITY

```mach
pub val INIT_IDENTITY:           InitReason = 11
```

## val INIT_PARAMETERS

```mach
pub val INIT_PARAMETERS:         InitReason = 12
```

## val INIT_RECOVERY

```mach
pub val INIT_RECOVERY:           InitReason = 13
```

## val INIT_LEASE

```mach
pub val INIT_LEASE:              InitReason = 14
```

## val INIT_KEYS

```mach
pub val INIT_KEYS:               InitReason = 15
```

## val INIT_PATH

```mach
pub val INIT_PATH:               InitReason = 16
```

## val INIT_PROVIDER_START

```mach
pub val INIT_PROVIDER_START:     InitReason = 17
```

## rec InitResult

```mach
pub rec InitResult;
```

`reason_kind` and the two indices are only populated for the ownership
reasons. an index is a position in the range list the named check built:
INIT_STORAGE_* index the twenty-three owned storage ranges, INIT_COMPONENT_*
and INIT_PROVIDER_RANGES index the sixty-three component ranges, whose first
twenty-three entries are the storage ranges in the same order. for a
_BORROWED reason `reason_first` is instead the borrowed range's own index and
`reason_second` is the owned range it collided with

## rec Core

```mach
pub rec Core;
```

## fun init_client_result

```mach
pub fun init_client_result(core: *Core, secrets: *Secrets, config: Config,
storage: Storage, secret_storage: SecretStorage,
handshake: *handshake_api.Adapter,
cids: *cid_api.Manager, paths: *path_api.Manager,
streams: *stream_api.Manager,
datagrams: *datagram_api.Queue,
now_ns: u64) InitResult;
```

## fun init_server_result

```mach
pub fun init_server_result(core: *Core, secrets: *Secrets, config: Config,
storage: Storage, secret_storage: SecretStorage,
handshake: *handshake_api.Adapter,
cids: *cid_api.Manager, paths: *path_api.Manager,
streams: *stream_api.Manager,
datagrams: *datagram_api.Queue,
now_ns: u64) InitResult;
```

## fun init_client

```mach
pub fun init_client(core: *Core, secrets: *Secrets, config: Config, storage: Storage,
secret_storage: SecretStorage,
handshake: *handshake_api.Adapter, cids: *cid_api.Manager,
paths: *path_api.Manager, streams: *stream_api.Manager,
datagrams: *datagram_api.Queue, now_ns: u64) bool;
```

## fun init_server

```mach
pub fun init_server(core: *Core, secrets: *Secrets, config: Config, storage: Storage,
secret_storage: SecretStorage,
handshake: *handshake_api.Adapter, cids: *cid_api.Manager,
paths: *path_api.Manager, streams: *stream_api.Manager,
datagrams: *datagram_api.Queue, now_ns: u64) bool;
```

## fun abandon_initialization

```mach
pub fun abandon_initialization(core: *Core, secrets: *Secrets) bool;
```

rolls back a successful core init before the assembly becomes observable

## fun release_chunks

```mach
pub fun release_chunks(core: *Core);
```

a dead core's chunks, given back whatever they hold

## fun receive

```mach
pub fun receive(core: *Core, secrets: *Secrets,
input: *transport_api.CoreInput) transport_api.CoreResult;
```

## fun queue_new_token

```mach
pub fun queue_new_token(core: *Core, data: *u8, length: usize) transport_api.Status;
```

queues a NEW_TOKEN for the client. STATUS_BLOCKED when no chunk is free: the
connection's account is woken once one is, and the call can be repeated.
STATUS_ERROR for a call that can never succeed as made, including while an
earlier token is still unacknowledged

## rec TakenToken

```mach
pub rec TakenToken;
```

## fun take_received_token

```mach
pub fun take_received_token(core: *Core, output: *u8,
capacity: usize) TakenToken;
```

copies the client's received token out and releases it. STATUS_EMPTY when
none is waiting. when `capacity` is too small nothing is released, and
`length` says how much room the token needs

## fun probe_path

```mach
pub fun probe_path(core: *Core, endpoint: path_api.Endpoint,
preferred: bool) path_api.PathResult;
```

## fun migrate_path

```mach
pub fun migrate_path(core: *Core, value: path_api.Handle, preferred: bool,
now_ns: u64) path_api.Observation;
```

## fun queue_path_challenge

```mach
pub fun queue_path_challenge(core: *Core, value: path_api.Handle,
data: [8]u8, padded: bool,
purpose: u8) path_api.OperationResult;
```

## fun on_path_packet_too_big

```mach
pub fun on_path_packet_too_big(core: *Core, value: path_api.Handle,
reported_mtu: u16,
quote_authenticated: bool,
now_ns: u64) path_api.MtuResult;
```

## fun poll_handshake

```mach
pub fun poll_handshake(core: *Core, secrets: *Secrets,
now_ns: u64) transport_api.CoreResult;
```

## fun snapshot

```mach
pub fun snapshot(core: *Core) Snapshot;
```

## fun generate

```mach
pub fun generate(core: *Core, secrets: *Secrets, output: *u8,
capacity: usize, now_ns: u64) transport_api.CoreDatagram;
```

## fun complete_send

```mach
pub fun complete_send(core: *Core, secrets: *Secrets, owner_id: u64,
status: transport_api.SendStatus, count: usize,
now_ns: u64) transport_api.CoreResult;
```

## fun timer

```mach
pub fun timer(core: *Core) transport_api.CoreTimer;
```

## fun on_timeout

```mach
pub fun on_timeout(core: *Core, secrets: *Secrets, generation: u64,
now_ns: u64) transport_api.CoreResult;
```

## fun begin_close

```mach
pub fun begin_close(core: *Core, secrets: *Secrets, abortive: bool,
application_error: u64, reason: *u8,
reason_length: usize, now_ns: u64) transport_api.CoreResult;
```

## fun close_ready

```mach
pub fun close_ready(core: *Core) bool;
```

## fun finish_close

```mach
pub fun finish_close(core: *Core, secrets: *Secrets) bool;
```

