# quic.connection.cid

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK:        Status = 1
```

## val STATUS_DUPLICATE

```mach
pub val STATUS_DUPLICATE: Status = 2
```

## val STATUS_STALE

```mach
pub val STATUS_STALE:     Status = 3
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED:   Status = 4
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR:     Status = 5
```

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:            Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:           Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:          Error = 2
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY:        Error = 3
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT:           Error = 4
```

## val ERROR_SEQUENCE

```mach
pub val ERROR_SEQUENCE:        Error = 5
```

## val ERROR_DUPLICATE_ID

```mach
pub val ERROR_DUPLICATE_ID:    Error = 6
```

## val ERROR_DUPLICATE_TOKEN

```mach
pub val ERROR_DUPLICATE_TOKEN: Error = 7
```

## val ERROR_RETIRE_CURRENT

```mach
pub val ERROR_RETIRE_CURRENT:  Error = 8
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN:           Error = 9
```

## val ERROR_ZERO_LENGTH

```mach
pub val ERROR_ZERO_LENGTH:     Error = 10
```

## def EntryState

```mach
pub def EntryState: u8
```

## val ENTRY_FREE

```mach
pub val ENTRY_FREE:          EntryState = 0
```

## val ENTRY_ACTIVE

```mach
pub val ENTRY_ACTIVE:        EntryState = 1
```

## val ENTRY_RETIRE_QUEUED

```mach
pub val ENTRY_RETIRE_QUEUED: EntryState = 2
```

## val ENTRY_RETIRED

```mach
pub val ENTRY_RETIRED:       EntryState = 3
```

## val ENTRY_RETIRE_SENT

```mach
pub val ENTRY_RETIRE_SENT:   EntryState = 4
```

## rec Entry

```mach
pub rec Entry;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Config

```mach
pub rec Config;
```

## rec Manager

```mach
pub rec Manager;
```

## rec Handle

```mach
pub rec Handle;
```

## rec Result

```mach
pub rec Result;
```

## rec Selected

```mach
pub rec Selected;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage,
initial_local: packet.ConnectionId,
initial_peer: packet.ConnectionId) bool;
```

## fun lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool;
```

## fun release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool;
```

## fun issue_local

```mach
pub fun issue_local(manager: *Manager, sequence: u64, id: packet.ConnectionId,
reset_token: [16]u8) Result;
```

## fun issue_local_scoped

```mach
pub fun issue_local_scoped(manager: *Manager, core_source: u64, sequence: u64,
id: packet.ConnectionId,
reset_token: [16]u8) Result;
```

## fun replace_initial_peer

```mach
pub fun replace_initial_peer(manager: *Manager, id: packet.ConnectionId) Result;
```

retry replaces the peer's sequence-zero initial destination before authentication

## fun replace_initial_peer_scoped

```mach
pub fun replace_initial_peer_scoped(manager: *Manager, core_source: u64,
id: packet.ConnectionId) Result;
```

## fun install_initial_peer_reset_token

```mach
pub fun install_initial_peer_reset_token(manager: *Manager,
reset_token: [16]u8) Result;
```

## fun install_initial_peer_reset_token_scoped

```mach
pub fun install_initial_peer_reset_token_scoped(manager: *Manager,
core_source: u64,
reset_token: [16]u8) Result;
```

## fun update_local_limit

```mach
pub fun update_local_limit(manager: *Manager, limit: u64) Result;
```

applies the peer's active_connection_id_limit before any additional local id is issued

## fun update_local_limit_scoped

```mach
pub fun update_local_limit_scoped(manager: *Manager, core_source: u64,
limit: u64) Result;
```

## fun receive_new

```mach
pub fun receive_new(manager: *Manager, sequence: u64, retire_prior_to: u64,
id: packet.ConnectionId, reset_token: [16]u8) Result;
```

applies NEW_CONNECTION_ID transactionally after validating all collisions and limits

## fun receive_new_scoped

```mach
pub fun receive_new_scoped(manager: *Manager, core_source: u64, sequence: u64,
retire_prior_to: u64, id: packet.ConnectionId,
reset_token: [16]u8) Result;
```

## fun receive_retire

```mach
pub fun receive_retire(manager: *Manager, sequence: u64) Result;
```

## fun receive_retire_scoped

```mach
pub fun receive_retire_scoped(manager: *Manager, core_source: u64,
sequence: u64) Result;
```

## fun receive_retire_in_packet_scoped

```mach
pub fun receive_retire_in_packet_scoped(manager: *Manager, core_source: u64,
sequence: u64,
destination_sequence: u64) Result;
```

## fun match_local

```mach
pub fun match_local(manager: *Manager, id: *packet.ConnectionId) Selected;
```

## fun select

```mach
pub fun select(manager: *Manager, value: Handle) Result;
```

## fun select_scoped

```mach
pub fun select_scoped(manager: *Manager, core_source: u64, value: Handle) Result;
```

## fun current

```mach
pub fun current(manager: *Manager, local: bool) Selected;
```

## fun local_zero_length

```mach
pub fun local_zero_length(manager: *Manager) bool;
```

a peer that chose a zero-length id is addressed by its path alone, so it
never issues or rotates to another id

## fun peer_zero_length

```mach
pub fun peer_zero_length(manager: *Manager) bool;
```

## fun rotate_peer

```mach
pub fun rotate_peer(manager: *Manager) Result;
```

## fun peer_rotation_available

```mach
pub fun peer_rotation_available(manager: *Manager) bool;
```

## fun rotate_peer_scoped

```mach
pub fun rotate_peer_scoped(manager: *Manager, core_source: u64) Result;
```

## fun next_advertisement

```mach
pub fun next_advertisement(manager: *Manager) Selected;
```

## fun advertisement_sent

```mach
pub fun advertisement_sent(manager: *Manager, value: Handle) Result;
```

## fun advertisement_sent_scoped

```mach
pub fun advertisement_sent_scoped(manager: *Manager, core_source: u64,
value: Handle) Result;
```

## fun advertisement_terminal

```mach
pub fun advertisement_terminal(manager: *Manager, value: Handle,
acknowledged: bool) Result;
```

## fun advertisement_terminal_scoped

```mach
pub fun advertisement_terminal_scoped(manager: *Manager, core_source: u64,
value: Handle, acknowledged: bool) Result;
```

## fun next_retirement

```mach
pub fun next_retirement(manager: *Manager) Result;
```

## fun retirement_sent

```mach
pub fun retirement_sent(manager: *Manager, value: Handle) Result;
```

## fun retirement_sent_scoped

```mach
pub fun retirement_sent_scoped(manager: *Manager, core_source: u64,
value: Handle) Result;
```

## fun retirement_terminal

```mach
pub fun retirement_terminal(manager: *Manager, value: Handle,
acknowledged: bool) Result;
```

## fun retirement_terminal_scoped

```mach
pub fun retirement_terminal_scoped(manager: *Manager, core_source: u64,
value: Handle, acknowledged: bool) Result;
```

## fun begin_close

```mach
pub fun begin_close(manager: *Manager) bool;
```

## fun begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, core_source: u64) bool;
```

## fun finish_close

```mach
pub fun finish_close(manager: *Manager) bool;
```

## fun finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, core_source: u64) bool;
```

## fun snapshot

```mach
pub fun snapshot(manager: *Manager) Snapshot;
```

