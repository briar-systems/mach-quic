[quic](../README.md) / [connection](README.md) / **cid**

# quic.connection.cid

bounded connection id lifecycle

Source: [`src/connection/cid.mach`](../../../../src/connection/cid.mach)

Uses types from [`quic.packet.packet`](../packet/packet.md).

| Type | | |
| :--- | :--- | :--- |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`EntryState`](#entrystate) | `def` |  |
| [`Entry`](#entry) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`Config`](#config) | `rec` |  |
| [`Manager`](#manager) | `rec` |  |
| [`Handle`](#handle) | `rec` |  |
| [`Result`](#result) | `rec` |  |
| [`Selected`](#selected) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_DUPLICATE`](#status), [`STATUS_STALE`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_ERROR`](#status) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_CAPACITY`](#error), [`ERROR_LIMIT`](#error), [`ERROR_SEQUENCE`](#error), [`ERROR_DUPLICATE_ID`](#error), [`ERROR_DUPLICATE_TOKEN`](#error), [`ERROR_RETIRE_CURRENT`](#error), [`ERROR_TOKEN`](#error), [`ERROR_ZERO_LENGTH`](#error) | |

| On `EntryState` | |
| :--- | :--- |
| [`ENTRY_FREE`](#entrystate), [`ENTRY_ACTIVE`](#entrystate), [`ENTRY_RETIRE_QUEUED`](#entrystate), [`ENTRY_RETIRED`](#entrystate), [`ENTRY_RETIRE_SENT`](#entrystate) | |

| On `Manager` | |
| :--- | :--- |
| [`initialize`](#initialize), [`lease_core`](#lease_core), [`release_core`](#release_core) | |
| [`local_demand`](#local_demand) | how many more local ids may be issued now: the peer's limit less the ids it counts, bounded by free storage |
| [`issue_local`](#issue_local) | issues a local id under the next sequence, to be advertised by NEW_CONNECTION_ID |
| [`issue_local_scoped`](#issue_local_scoped) | |
| [`retire_local_prior_to`](#retire_local_prior_to) | raises the local retire_prior_to, which every later NEW_CONNECTION_ID carries |
| [`retire_local_prior_to_scoped`](#retire_local_prior_to_scoped) | |
| [`replace_initial_peer`](#replace_initial_peer) | retry replaces the peer's sequence-zero initial destination before authentication |
| [`replace_initial_peer_scoped`](#replace_initial_peer_scoped), [`install_initial_peer_reset_token`](#install_initial_peer_reset_token), [`install_initial_peer_reset_token_scoped`](#install_initial_peer_reset_token_scoped) | |
| [`install_initial_local_reset_token`](#install_initial_local_reset_token) | a server's token for its handshake id, which its transport parameters carry |
| [`update_local_limit`](#update_local_limit) | applies the peer's active_connection_id_limit before any additional local id is issued |
| [`update_local_limit_scoped`](#update_local_limit_scoped) | |
| [`receive_new`](#receive_new) | applies NEW_CONNECTION_ID transactionally after validating all collisions and limits |
| [`receive_new_scoped`](#receive_new_scoped), [`receive_retire`](#receive_retire), [`receive_retire_scoped`](#receive_retire_scoped), [`receive_retire_in_packet_scoped`](#receive_retire_in_packet_scoped), [`match_local`](#match_local), [`select`](#select), [`select_scoped`](#select_scoped), [`current`](#current) | |
| [`local_zero_length`](#local_zero_length) | a peer that chose a zero-length id is addressed by its path alone, so it never issues or rotates to another id |
| [`peer_zero_length`](#peer_zero_length), [`rotate_peer`](#rotate_peer), [`peer_rotation_available`](#peer_rotation_available), [`rotate_peer_scoped`](#rotate_peer_scoped), [`next_advertisement`](#next_advertisement), [`advertisement_sent`](#advertisement_sent), [`advertisement_sent_scoped`](#advertisement_sent_scoped), [`advertisement_terminal`](#advertisement_terminal), [`advertisement_terminal_scoped`](#advertisement_terminal_scoped), [`next_retirement`](#next_retirement), [`retirement_sent`](#retirement_sent), [`retirement_sent_scoped`](#retirement_sent_scoped), [`retirement_terminal`](#retirement_terminal), [`retirement_terminal_scoped`](#retirement_terminal_scoped), [`begin_close`](#begin_close), [`begin_close_scoped`](#begin_close_scoped), [`finish_close`](#finish_close), [`finish_close_scoped`](#finish_close_scoped), [`snapshot`](#snapshot) | |

---

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_DUPLICATE` | `2` |  |
| `STATUS_STALE` | `3` |  |
| `STATUS_BLOCKED` | `4` |  |
| `STATUS_ERROR` | `5` |  |

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
| `ERROR_LIMIT` | `4` |  |
| `ERROR_SEQUENCE` | `5` |  |
| `ERROR_DUPLICATE_ID` | `6` |  |
| `ERROR_DUPLICATE_TOKEN` | `7` |  |
| `ERROR_RETIRE_CURRENT` | `8` |  |
| `ERROR_TOKEN` | `9` |  |
| `ERROR_ZERO_LENGTH` | `10` |  |

## EntryState

```mach
pub def EntryState: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ENTRY_FREE` | `0` |  |
| `ENTRY_ACTIVE` | `1` |  |
| `ENTRY_RETIRE_QUEUED` | `2` |  |
| `ENTRY_RETIRED` | `3` |  |
| `ENTRY_RETIRE_SENT` | `4` |  |

## Entry

```mach
pub rec Entry {
    id:                     quic.packet.packet.ConnectionId;
    reset_token:            [16]u8;
    sequence:               u64;
    generation:             u64;
    state:                  EntryState;
    current:                bool;
    advertised:             bool;
    advertisement_inflight: bool;
    reset_token_present:    bool;
}
```

## Storage

```mach
pub rec Storage {
    local:          *Entry;
    local_capacity: usize;
    peer:           *Entry;
    peer_capacity:  usize;
}
```

## Config

```mach
pub rec Config {
    source:             u64;
    local_active_limit: usize;
    peer_active_limit:  usize;
}
```

## Manager

```mach
pub rec Manager {
    config:               Config;
    storage:              Storage;
    local_active:         usize;
    peer_active:          usize;
    peer_retire_prior_to: u64;
    # rfc 9000 5.1.2: local ids below this are ones the peer must retire
    local_retire_prior_to: u64;
    # the sequence the next issued local id takes
    local_next_sequence:                u64;
    core_lease:                         u64;
    initial_peer_reset_token_installed: bool;
    initialized:                        bool;
    closing:                            bool;
}
```

### initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage,
    initial_local: quic.packet.packet.ConnectionId,
    initial_peer: quic.packet.packet.ConnectionId) bool
```

### lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool
```

### release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool
```

### local_demand

```mach
pub fun local_demand(manager: *Manager) usize
```

how many more local ids may be issued now: the peer's limit less the ids it
counts, bounded by free storage. none for a zero-length id

### issue_local

```mach
pub fun issue_local(manager: *Manager, id: quic.packet.packet.ConnectionId,
    reset_token: [16]u8) Result
```

issues a local id under the next sequence, to be advertised by
NEW_CONNECTION_ID

### issue_local_scoped

```mach
pub fun issue_local_scoped(manager: *Manager, core_source: u64,
    id: quic.packet.packet.ConnectionId, reset_token: [16]u8) Result
```

### retire_local_prior_to

```mach
pub fun retire_local_prior_to(manager: *Manager, sequence: u64) Result
```

raises the local retire_prior_to, which every later NEW_CONNECTION_ID
carries. an id below it that the peer never learned leaves at once, and one
it did learn stays routable until the peer retires it

### retire_local_prior_to_scoped

```mach
pub fun retire_local_prior_to_scoped(manager: *Manager, core_source: u64,
    sequence: u64) Result
```

### replace_initial_peer

```mach
pub fun replace_initial_peer(manager: *Manager, id: quic.packet.packet.ConnectionId) Result
```

retry replaces the peer's sequence-zero initial destination before authentication

### replace_initial_peer_scoped

```mach
pub fun replace_initial_peer_scoped(manager: *Manager, core_source: u64,
    id: quic.packet.packet.ConnectionId) Result
```

### install_initial_peer_reset_token

```mach
pub fun install_initial_peer_reset_token(manager: *Manager,
    reset_token: [16]u8) Result
```

### install_initial_peer_reset_token_scoped

```mach
pub fun install_initial_peer_reset_token_scoped(manager: *Manager,
    core_source: u64,
    reset_token: [16]u8) Result
```

### install_initial_local_reset_token

```mach
pub fun install_initial_local_reset_token(manager: *Manager,
    reset_token: [16]u8) Result
```

a server's token for its handshake id, which its transport parameters carry.
set once, before the core leases the manager

### update_local_limit

```mach
pub fun update_local_limit(manager: *Manager, limit: u64) Result
```

applies the peer's active_connection_id_limit before any additional local id is issued

### update_local_limit_scoped

```mach
pub fun update_local_limit_scoped(manager: *Manager, core_source: u64,
    limit: u64) Result
```

### receive_new

```mach
pub fun receive_new(manager: *Manager, sequence: u64, retire_prior_to: u64,
    id: quic.packet.packet.ConnectionId, reset_token: [16]u8) Result
```

applies NEW_CONNECTION_ID transactionally after validating all collisions and limits

### receive_new_scoped

```mach
pub fun receive_new_scoped(manager: *Manager, core_source: u64, sequence: u64,
    retire_prior_to: u64, id: quic.packet.packet.ConnectionId,
    reset_token: [16]u8) Result
```

### receive_retire

```mach
pub fun receive_retire(manager: *Manager, sequence: u64) Result
```

### receive_retire_scoped

```mach
pub fun receive_retire_scoped(manager: *Manager, core_source: u64,
    sequence: u64) Result
```

### receive_retire_in_packet_scoped

```mach
pub fun receive_retire_in_packet_scoped(manager: *Manager, core_source: u64,
    sequence: u64,
    destination_sequence: u64) Result
```

### match_local

```mach
pub fun match_local(manager: *Manager, id: *quic.packet.packet.ConnectionId) Selected
```

### select

```mach
pub fun select(manager: *Manager, value: Handle) Result
```

### select_scoped

```mach
pub fun select_scoped(manager: *Manager, core_source: u64, value: Handle) Result
```

### current

```mach
pub fun current(manager: *Manager, local: bool) Selected
```

### local_zero_length

```mach
pub fun local_zero_length(manager: *Manager) bool
```

a peer that chose a zero-length id is addressed by its path alone, so it
never issues or rotates to another id

### peer_zero_length

```mach
pub fun peer_zero_length(manager: *Manager) bool
```

### rotate_peer

```mach
pub fun rotate_peer(manager: *Manager) Result
```

### peer_rotation_available

```mach
pub fun peer_rotation_available(manager: *Manager) bool
```

### rotate_peer_scoped

```mach
pub fun rotate_peer_scoped(manager: *Manager, core_source: u64) Result
```

### next_advertisement

```mach
pub fun next_advertisement(manager: *Manager) Selected
```

### advertisement_sent

```mach
pub fun advertisement_sent(manager: *Manager, value: Handle) Result
```

### advertisement_sent_scoped

```mach
pub fun advertisement_sent_scoped(manager: *Manager, core_source: u64,
    value: Handle) Result
```

### advertisement_terminal

```mach
pub fun advertisement_terminal(manager: *Manager, value: Handle,
    acknowledged: bool) Result
```

### advertisement_terminal_scoped

```mach
pub fun advertisement_terminal_scoped(manager: *Manager, core_source: u64,
    value: Handle, acknowledged: bool) Result
```

### next_retirement

```mach
pub fun next_retirement(manager: *Manager) Result
```

### retirement_sent

```mach
pub fun retirement_sent(manager: *Manager, value: Handle) Result
```

### retirement_sent_scoped

```mach
pub fun retirement_sent_scoped(manager: *Manager, core_source: u64,
    value: Handle) Result
```

### retirement_terminal

```mach
pub fun retirement_terminal(manager: *Manager, value: Handle,
    acknowledged: bool) Result
```

### retirement_terminal_scoped

```mach
pub fun retirement_terminal_scoped(manager: *Manager, core_source: u64,
    value: Handle, acknowledged: bool) Result
```

### begin_close

```mach
pub fun begin_close(manager: *Manager) bool
```

### begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, core_source: u64) bool
```

### finish_close

```mach
pub fun finish_close(manager: *Manager) bool
```

### finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, core_source: u64) bool
```

### snapshot

```mach
pub fun snapshot(manager: *Manager) Snapshot
```

## Handle

```mach
pub rec Handle {
    source:     u64;
    index:      usize;
    generation: u64;
    sequence:   u64;
    local:      bool;
}
```

## Result

```mach
pub rec Result {
    status:             Status;
    error:              Error;
    handle:             Handle;
    retired:            usize;
    replacement_needed: bool;
}
```

## Selected

```mach
pub rec Selected {
    status:              Status;
    error:               Error;
    handle:              Handle;
    id:                  quic.packet.packet.ConnectionId;
    reset_token:         [16]u8;
    reset_token_present: bool;
    retire_prior_to:     u64;
}
```

## Snapshot

```mach
pub rec Snapshot {
    local_active:          usize;
    peer_active:           usize;
    peer_retire_prior_to:  u64;
    local_retire_prior_to: u64;
    local_next_sequence:   u64;
    initialized:           bool;
    closing:               bool;
}
```

