[quic](../README.md) / [path](README.md) / **path**

# quic.path.path

Source: [`src/path/path.mach`](../../../../src/path/path.mach)

Uses types from [`quic.congestion.controller`](../congestion/controller.md), [`quic.congestion.pacer`](../congestion/pacer.md).

| Type | | |
| :--- | :--- | :--- |
| [`Address`](#address) | `rec` |  |
| [`Endpoint`](#endpoint) | `rec` |  |
| [`Config`](#config) | `rec` |  |
| [`Path`](#path) | `rec` |  |
| [`Challenge`](#challenge) | `rec` |  |
| [`Response`](#response) | `rec` |  |
| [`SendReservation`](#sendreservation) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`Manager`](#manager) | `rec` |  |
| [`Handle`](#handle) | `rec` |  |
| [`ChallengeToken`](#challengetoken) | `rec` |  |
| [`ResponseToken`](#responsetoken) | `rec` |  |
| [`SendToken`](#sendtoken) | `rec` |  |
| [`MtuToken`](#mtutoken) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |
| [`PathResult`](#pathresult) | `rec` |  |
| [`Observation`](#observation) | `rec` |  |
| [`PreparedChallenge`](#preparedchallenge) | `rec` |  |
| [`PreparedResponse`](#preparedresponse) | `rec` |  |
| [`SendResult`](#sendresult) | `rec` |  |
| [`ValidationResult`](#validationresult) | `rec` |  |
| [`TimeoutResult`](#timeoutresult) | `rec` |  |
| [`MtuPrepared`](#mtuprepared) | `rec` |  |
| [`MtuResult`](#mturesult) | `rec` |  |
| [`Snapshot`](#snapshot-1) | `rec` |  |

| On `Address` | |
| :--- | :--- |
| [`ipv4`](#ipv4), [`ipv6`](#ipv6), [`address_equal`](#address_equal), [`same_address_without_port`](#same_address_without_port) | |

| On `Endpoint` | |
| :--- | :--- |
| [`endpoint_equal`](#endpoint_equal) | |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config) | |

| On `Manager` | |
| :--- | :--- |
| [`initialize`](#initialize), [`selected`](#selected), [`lease_core`](#lease_core), [`release_core`](#release_core), [`find`](#find), [`confirm_handshake`](#confirm_handshake) | |
| [`validate_address`](#validate_address) | receiving a handshake packet proves return routability on that path, and rfc 9000 14.1 pads the initials both ways, so it proves the base mtu too |
| [`observe`](#observe), [`probe`](#probe), [`migrate`](#migrate), [`queue_challenge`](#queue_challenge), [`prepare_challenge`](#prepare_challenge), [`cancel_challenge`](#cancel_challenge), [`publish_challenge`](#publish_challenge), [`receive_response`](#receive_response), [`queue_response`](#queue_response), [`prepare_response`](#prepare_response), [`cancel_response`](#cancel_response), [`publish_response`](#publish_response), [`reserve_send`](#reserve_send), [`reserve_mtu_send`](#reserve_mtu_send), [`cancel_send`](#cancel_send), [`publish_send`](#publish_send), [`on_timeout`](#on_timeout) | |
| [`limit_mtu`](#limit_mtu) | lowers the send ceiling once the peer's limit is known |
| [`prepare_mtu_probe`](#prepare_mtu_probe), [`cancel_mtu_probe`](#cancel_mtu_probe), [`publish_mtu_probe`](#publish_mtu_probe), [`on_mtu_terminal`](#on_mtu_terminal), [`on_large_packet_lost`](#on_large_packet_lost), [`on_packet_acked`](#on_packet_acked), [`on_packet_too_big`](#on_packet_too_big), [`snapshot`](#snapshot), [`retain_recovery`](#retain_recovery), [`configure_transport`](#configure_transport), [`unconfigure_transport`](#unconfigure_transport), [`recovery_sent`](#recovery_sent), [`recovery_terminal`](#recovery_terminal), [`release_recovery`](#release_recovery), [`restart`](#restart), [`release`](#release), [`begin_close`](#begin_close), [`finish_close`](#finish_close), [`limit_mtu_scoped`](#limit_mtu_scoped), [`confirm_handshake_scoped`](#confirm_handshake_scoped), [`validate_address_scoped`](#validate_address_scoped), [`observe_scoped`](#observe_scoped), [`probe_scoped`](#probe_scoped), [`migrate_scoped`](#migrate_scoped), [`queue_challenge_scoped`](#queue_challenge_scoped), [`prepare_challenge_scoped`](#prepare_challenge_scoped), [`cancel_challenge_scoped`](#cancel_challenge_scoped), [`publish_challenge_scoped`](#publish_challenge_scoped), [`receive_response_scoped`](#receive_response_scoped), [`queue_response_scoped`](#queue_response_scoped), [`prepare_response_scoped`](#prepare_response_scoped), [`cancel_response_scoped`](#cancel_response_scoped), [`publish_response_scoped`](#publish_response_scoped), [`reserve_send_scoped`](#reserve_send_scoped), [`reserve_mtu_send_scoped`](#reserve_mtu_send_scoped), [`cancel_send_scoped`](#cancel_send_scoped), [`publish_send_scoped`](#publish_send_scoped), [`on_timeout_scoped`](#on_timeout_scoped) | |
| [`peek_challenge_scoped`](#peek_challenge_scoped) | what prepare_challenge_scoped would answer, with nothing changed |
| [`validating_scoped`](#validating_scoped) | whether `value` is validating or holds a challenge |
| [`peek_response_scoped`](#peek_response_scoped) | what prepare_response_scoped would answer, with nothing changed |
| [`peek_mtu_probe_scoped`](#peek_mtu_probe_scoped) | what prepare_mtu_probe_scoped would answer, with nothing changed |
| [`peek_send_scoped`](#peek_send_scoped) | whether reserve_send_scoped would reserve `bytes` on `value`, and what it would refuse with, with nothing changed |
| [`peek_mtu_send_scoped`](#peek_mtu_send_scoped) | whether an MTU probe of `bytes` that prepare_mtu_probe_scoped would issue could then be reserved, with nothing changed |
| [`prepare_mtu_probe_scoped`](#prepare_mtu_probe_scoped), [`cancel_mtu_probe_scoped`](#cancel_mtu_probe_scoped), [`publish_mtu_probe_scoped`](#publish_mtu_probe_scoped), [`on_mtu_terminal_scoped`](#on_mtu_terminal_scoped), [`on_large_packet_lost_scoped`](#on_large_packet_lost_scoped), [`on_packet_acked_scoped`](#on_packet_acked_scoped), [`on_packet_too_big_scoped`](#on_packet_too_big_scoped), [`retain_recovery_scoped`](#retain_recovery_scoped), [`configure_transport_scoped`](#configure_transport_scoped) | |
| [`peek_transport_scoped`](#peek_transport_scoped) | the congestion controller and pacer configure_transport_scoped would leave `value` sending under, with nothing changed |
| [`unconfigure_transport_scoped`](#unconfigure_transport_scoped), [`recovery_sent_scoped`](#recovery_sent_scoped), [`recovery_terminal_scoped`](#recovery_terminal_scoped), [`release_recovery_scoped`](#release_recovery_scoped), [`begin_close_scoped`](#begin_close_scoped), [`finish_close_scoped`](#finish_close_scoped) | |

| Constants | |
| :--- | :--- |
| [`ROLE_CLIENT`](#constants), [`ROLE_SERVER`](#constants), [`ADDRESS_IPV4`](#constants), [`ADDRESS_IPV6`](#constants), [`PATH_FREE`](#constants), [`PATH_VALIDATING`](#constants), [`PATH_VALIDATED`](#constants), [`PATH_FAILED`](#constants), [`CHALLENGE_QUEUED`](#constants), [`CHALLENGE_PREPARED`](#constants), [`CHALLENGE_SENT`](#constants), [`RESPONSE_QUEUED`](#constants), [`RESPONSE_PREPARED`](#constants), [`MIGRATION_NONE`](#constants), [`MIGRATION_PEER`](#constants), [`MIGRATION_REBINDING`](#constants), [`MIGRATION_ACTIVE`](#constants), [`MIGRATION_PREFERRED`](#constants), [`MIGRATION_REVERTED`](#constants), [`MTU_TERMINAL_ACKED`](#constants), [`MTU_TERMINAL_LOST`](#constants), [`VALIDATION_PATH`](#constants), [`VALIDATION_MTU`](#constants), [`STATUS_OK`](#constants), [`STATUS_EMPTY`](#constants), [`STATUS_BLOCKED`](#constants), [`STATUS_DROPPED`](#constants), [`STATUS_STALE`](#constants), [`STATUS_CLOSED`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_CONFIG`](#constants), [`ERROR_CAPACITY`](#constants), [`ERROR_ADDRESS`](#constants), [`ERROR_TOKEN`](#constants), [`ERROR_TIME`](#constants), [`ERROR_OVERFLOW`](#constants), [`ERROR_AMPLIFICATION`](#constants), [`ERROR_MIGRATION_DISABLED`](#constants), [`ERROR_HANDSHAKE`](#constants), [`ERROR_MTU`](#constants), [`ERROR_DUPLICATE`](#constants) | |

---

## Address

```mach
pub rec Address {
    family:   u8;
    bytes:    [16]u8;
    port:     u16;
    scope_id: u32;
}
```

### ipv4

```mach
pub fun ipv4(a: u8, b: u8, c: u8, d: u8, port: u16) Address
```

### ipv6

```mach
pub fun ipv6(bytes: [16]u8, port: u16, scope_id: u32) Address
```

### address_equal

```mach
pub fun address_equal(a: Address, b: Address) bool
```

### same_address_without_port

```mach
pub fun same_address_without_port(a: Address, b: Address) bool
```

## Endpoint

```mach
pub rec Endpoint {
    local: Address;
    peer:  Address;
}
```

### endpoint_equal

```mach
pub fun endpoint_equal(a: Endpoint, b: Endpoint) bool
```

## Config

```mach
pub rec Config {
    source:                         u64;
    role:                           u8;
    allow_peer_active_migration:    bool;
    peer_disabled_active_migration: bool;
    retain_port_rebinding_state:    bool;
    initial_address_validated:      bool;
    base_mtu:                       u16;
    maximum_mtu:                    u16;
    mtu_probe_step:                 u16;
    validation_timeout_factor:      u8;
    mtu_probe_attempts:             u8;
    black_hole_threshold:           u8;
}
```

### default_config

```mach
pub fun default_config(source: u64, role: u8, initial_address_validated: bool) Config
```

## Path

```mach
pub rec Path {
    endpoint:                   Endpoint;
    received_bytes:             u64;
    sent_bytes:                 u64;
    reserved_bytes:             u64;
    recovery_owners:            usize;
    recovery_bytes_in_flight:   u64;
    congestion:                 quic.congestion.controller.State;
    pacer:                      quic.congestion.pacer.State;
    validation_started_ns:      u64;
    validation_deadline_ns:     u64;
    largest_non_probing_packet: u64;
    last_received_ns:           u64;
    generation:                 u64;
    current_mtu:                u16;
    search_upper_mtu:           u16;
    mtu_probe_size:             u16;
    mtu_probe_generation:       u64;
    mtu_datagram_generation:    u64;
    mtu_probe_losses:           u8;
    black_hole_losses:          u8;
    validation_purpose:         u8;
    state:                      u8;
    valid:                      bool;
    selected:                   bool;
    preferred:                  bool;
    locally_created:            bool;
    port_rebinding:             bool;
    address_validated:          bool;
    mtu_validated:              bool;
    has_largest_non_probing:    bool;
    has_received_time:          bool;
    peer_non_probing_received:  bool;
    mtu_probe_prepared:         bool;
    mtu_probe_active:           bool;
    transport_valid:            bool;
    # an unanswered challenge is sent again at `challenge_resend_ns`, after
    # `challenge_backoff_ns`, which doubles with each send (rfc 9000 9.4)
    challenge_resend_ns:  u64;
    challenge_backoff_ns: u64;
}
```

## Challenge

```mach
pub rec Challenge {
    data:            [8]u8;
    path_index:      usize;
    path_generation: u64;
    generation:      u64;
    sent_at_ns:      u64;
    timeout_ns:      u64;
    state:           u8;
    purpose:         u8;
    # the probe timeout a first send waits before the challenge is sent again
    resend_ns: u64;
    # the datagram must be padded, and the challenge waits until it can be
    padded: bool;
    # the prepared datagram was padded to 1200, so a response validates the mtu
    sent_padded: bool;
    valid:       bool;
}
```

## Response

```mach
pub rec Response {
    data:            [8]u8;
    path_index:      usize;
    path_generation: u64;
    generation:      u64;
    state:           u8;
    valid:           bool;
}
```

## SendReservation

```mach
pub rec SendReservation {
    path_index:      usize;
    path_generation: u64;
    generation:      u64;
    bytes:           u64;
    mtu_generation:  u64;
    mtu_probe:       bool;
    non_probing:     bool;
    valid:           bool;
}
```

## Storage

```mach
pub rec Storage {
    paths:              *Path;
    path_capacity:      usize;
    challenges:         *Challenge;
    challenge_capacity: usize;
    responses:          *Response;
    response_capacity:  usize;
    sends:              *SendReservation;
    send_capacity:      usize;
}
```

## Manager

```mach
pub rec Manager {
    config:                       Config;
    storage:                      Storage;
    selected_index:               usize;
    selected_generation:          u64;
    core_lease:                   u64;
    fallback_index:               usize;
    fallback_generation:          u64;
    largest_migration_packet:     u64;
    valid:                        bool;
    handshake_confirmed:          bool;
    has_largest_migration_packet: bool;
    closing:                      bool;
}
```

### initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage,
    initial: Endpoint) bool
```

### selected

```mach
pub fun selected(manager: *Manager) PathResult
```

### lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool
```

### release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool
```

### find

```mach
pub fun find(manager: *Manager, endpoint: Endpoint) PathResult
```

### confirm_handshake

```mach
pub fun confirm_handshake(manager: *Manager) OperationResult
```

### validate_address

```mach
pub fun validate_address(manager: *Manager, value: Handle) OperationResult
```

receiving a handshake packet proves return routability on that path, and
rfc 9000 14.1 pads the initials both ways, so it proves the base mtu too

### observe

```mach
pub fun observe(manager: *Manager, endpoint: Endpoint, packet_number: u64, bytes: u64,
    non_probing: bool, authenticated: bool, fresh: bool,
    connection_id_available: bool, now_ns: u64) Observation
```

### probe

```mach
pub fun probe(manager: *Manager, endpoint: Endpoint, preferred: bool) PathResult
```

### migrate

```mach
pub fun migrate(manager: *Manager, value: Handle, preferred: bool,
    connection_id_available: bool) Observation
```

### queue_challenge

```mach
pub fun queue_challenge(manager: *Manager, value: Handle, data: [8]u8,
    current_pto_ns: u64, path_pto_ns: u64,
    padded: bool, purpose: u8) OperationResult
```

### prepare_challenge

```mach
pub fun prepare_challenge(manager: *Manager, value: Handle) PreparedChallenge
```

### cancel_challenge

```mach
pub fun cancel_challenge(manager: *Manager, token: ChallengeToken) OperationResult
```

### publish_challenge

```mach
pub fun publish_challenge(manager: *Manager, token: ChallengeToken, now_ns: u64) OperationResult
```

### receive_response

```mach
pub fun receive_response(manager: *Manager, data: [8]u8, now_ns: u64) ValidationResult
```

### queue_response

```mach
pub fun queue_response(manager: *Manager, value: Handle, data: [8]u8) OperationResult
```

### prepare_response

```mach
pub fun prepare_response(manager: *Manager, value: Handle) PreparedResponse
```

### cancel_response

```mach
pub fun cancel_response(manager: *Manager, token: ResponseToken) OperationResult
```

### publish_response

```mach
pub fun publish_response(manager: *Manager, token: ResponseToken) OperationResult
```

### reserve_send

```mach
pub fun reserve_send(manager: *Manager, value: Handle, bytes: u64,
    non_probing: bool) SendResult
```

### reserve_mtu_send

```mach
pub fun reserve_mtu_send(manager: *Manager, value: Handle, bytes: u64,
    non_probing: bool, token: MtuToken) SendResult
```

### cancel_send

```mach
pub fun cancel_send(manager: *Manager, token: SendToken) OperationResult
```

### publish_send

```mach
pub fun publish_send(manager: *Manager, token: SendToken) OperationResult
```

### on_timeout

```mach
pub fun on_timeout(manager: *Manager, now_ns: u64) TimeoutResult
```

### limit_mtu

```mach
pub fun limit_mtu(manager: *Manager, maximum: u16) OperationResult
```

lowers the send ceiling once the peer's limit is known. every path's search
ceiling follows it, so no probe is ever prepared above the peer's limit

### prepare_mtu_probe

```mach
pub fun prepare_mtu_probe(manager: *Manager, value: Handle) MtuPrepared
```

### cancel_mtu_probe

```mach
pub fun cancel_mtu_probe(manager: *Manager, token: MtuToken) OperationResult
```

### publish_mtu_probe

```mach
pub fun publish_mtu_probe(manager: *Manager, token: MtuToken) OperationResult
```

### on_mtu_terminal

```mach
pub fun on_mtu_terminal(manager: *Manager, token: MtuToken, terminal: u8) MtuResult
```

### on_large_packet_lost

```mach
pub fun on_large_packet_lost(manager: *Manager, value: Handle, packet_size: u16) MtuResult
```

### on_packet_acked

```mach
pub fun on_packet_acked(manager: *Manager, value: Handle, packet_size: u16) OperationResult
```

### on_packet_too_big

```mach
pub fun on_packet_too_big(manager: *Manager, value: Handle, reported_mtu: u16,
    quote_authenticated: bool) MtuResult
```

### snapshot

```mach
pub fun snapshot(manager: *Manager, value: Handle) Snapshot
```

### retain_recovery

```mach
pub fun retain_recovery(manager: *Manager, value: Handle) OperationResult
```

### configure_transport

```mach
pub fun configure_transport(manager: *Manager, value: Handle,
    smoothed_rtt_ns: u64,
    now_ns: u64) OperationResult
```

### unconfigure_transport

```mach
pub fun unconfigure_transport(manager: *Manager, value: Handle) OperationResult
```

### recovery_sent

```mach
pub fun recovery_sent(manager: *Manager, value: Handle,
    bytes: u64) OperationResult
```

### recovery_terminal

```mach
pub fun recovery_terminal(manager: *Manager, value: Handle,
    bytes: u64) OperationResult
```

### release_recovery

```mach
pub fun release_recovery(manager: *Manager, value: Handle) OperationResult
```

### restart

```mach
pub fun restart(manager: *Manager, value: Handle) PathResult
```

### release

```mach
pub fun release(manager: *Manager, value: Handle) OperationResult
```

### begin_close

```mach
pub fun begin_close(manager: *Manager) OperationResult
```

### finish_close

```mach
pub fun finish_close(manager: *Manager) OperationResult
```

### limit_mtu_scoped

```mach
pub fun limit_mtu_scoped(manager: *Manager, source: u64,
    maximum: u16) OperationResult
```

### confirm_handshake_scoped

```mach
pub fun confirm_handshake_scoped(manager: *Manager,
    source: u64) OperationResult
```

### validate_address_scoped

```mach
pub fun validate_address_scoped(manager: *Manager, source: u64,
    value: Handle) OperationResult
```

### observe_scoped

```mach
pub fun observe_scoped(manager: *Manager, source: u64, endpoint: Endpoint,
    packet_number: u64, bytes: u64, non_probing: bool,
    authenticated: bool, fresh: bool,
    connection_id_available: bool,
    now_ns: u64) Observation
```

### probe_scoped

```mach
pub fun probe_scoped(manager: *Manager, source: u64, endpoint: Endpoint,
    preferred: bool) PathResult
```

### migrate_scoped

```mach
pub fun migrate_scoped(manager: *Manager, source: u64, value: Handle,
    preferred: bool,
    connection_id_available: bool) Observation
```

### queue_challenge_scoped

```mach
pub fun queue_challenge_scoped(manager: *Manager, source: u64,
    value: Handle, data: [8]u8,
    current_pto_ns: u64, path_pto_ns: u64,
    padded: bool, purpose: u8) OperationResult
```

### prepare_challenge_scoped

```mach
pub fun prepare_challenge_scoped(manager: *Manager, source: u64,
    value: Handle) PreparedChallenge
```

### cancel_challenge_scoped

```mach
pub fun cancel_challenge_scoped(manager: *Manager, source: u64,
    token: ChallengeToken) OperationResult
```

### publish_challenge_scoped

```mach
pub fun publish_challenge_scoped(manager: *Manager, source: u64,
    token: ChallengeToken,
    now_ns: u64) OperationResult
```

### receive_response_scoped

```mach
pub fun receive_response_scoped(manager: *Manager, source: u64, data: [8]u8,
    now_ns: u64) ValidationResult
```

### queue_response_scoped

```mach
pub fun queue_response_scoped(manager: *Manager, source: u64, value: Handle,
    data: [8]u8) OperationResult
```

### prepare_response_scoped

```mach
pub fun prepare_response_scoped(manager: *Manager, source: u64,
    value: Handle) PreparedResponse
```

### cancel_response_scoped

```mach
pub fun cancel_response_scoped(manager: *Manager, source: u64,
    token: ResponseToken) OperationResult
```

### publish_response_scoped

```mach
pub fun publish_response_scoped(manager: *Manager, source: u64,
    token: ResponseToken) OperationResult
```

### reserve_send_scoped

```mach
pub fun reserve_send_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64, non_probing: bool) SendResult
```

### reserve_mtu_send_scoped

```mach
pub fun reserve_mtu_send_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64, non_probing: bool,
    token: MtuToken) SendResult
```

### cancel_send_scoped

```mach
pub fun cancel_send_scoped(manager: *Manager, source: u64,
    token: SendToken) OperationResult
```

### publish_send_scoped

```mach
pub fun publish_send_scoped(manager: *Manager, source: u64,
    token: SendToken) OperationResult
```

### on_timeout_scoped

```mach
pub fun on_timeout_scoped(manager: *Manager, source: u64,
    now_ns: u64) TimeoutResult
```

### peek_challenge_scoped

```mach
pub fun peek_challenge_scoped(manager: *Manager, source: u64,
    value: Handle) PreparedChallenge
```

what prepare_challenge_scoped would answer, with nothing changed

### validating_scoped

```mach
pub fun validating_scoped(manager: *Manager, source: u64, value: Handle) bool
```

whether `value` is validating or holds a challenge. false for a stale handle

### peek_response_scoped

```mach
pub fun peek_response_scoped(manager: *Manager, source: u64,
    value: Handle) PreparedResponse
```

what prepare_response_scoped would answer, with nothing changed

### peek_mtu_probe_scoped

```mach
pub fun peek_mtu_probe_scoped(manager: *Manager, source: u64,
    value: Handle) MtuPrepared
```

what prepare_mtu_probe_scoped would answer, with nothing changed

### peek_send_scoped

```mach
pub fun peek_send_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64, non_probing: bool) SendResult
```

whether reserve_send_scoped would reserve `bytes` on `value`, and what it
would refuse with, with nothing changed. the token is left empty

### peek_mtu_send_scoped

```mach
pub fun peek_mtu_send_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64, non_probing: bool, size: u16) SendResult
```

whether an MTU probe of `bytes` that prepare_mtu_probe_scoped would issue
could then be reserved, with nothing changed

### prepare_mtu_probe_scoped

```mach
pub fun prepare_mtu_probe_scoped(manager: *Manager, source: u64,
    value: Handle) MtuPrepared
```

### cancel_mtu_probe_scoped

```mach
pub fun cancel_mtu_probe_scoped(manager: *Manager, source: u64,
    token: MtuToken) OperationResult
```

### publish_mtu_probe_scoped

```mach
pub fun publish_mtu_probe_scoped(manager: *Manager, source: u64,
    token: MtuToken) OperationResult
```

### on_mtu_terminal_scoped

```mach
pub fun on_mtu_terminal_scoped(manager: *Manager, source: u64, token: MtuToken,
    terminal: u8) MtuResult
```

### on_large_packet_lost_scoped

```mach
pub fun on_large_packet_lost_scoped(manager: *Manager, source: u64,
    value: Handle,
    packet_size: u16) MtuResult
```

### on_packet_acked_scoped

```mach
pub fun on_packet_acked_scoped(manager: *Manager, source: u64, value: Handle,
    packet_size: u16) OperationResult
```

### on_packet_too_big_scoped

```mach
pub fun on_packet_too_big_scoped(manager: *Manager, source: u64,
    value: Handle, reported_mtu: u16,
    quote_authenticated: bool) MtuResult
```

### retain_recovery_scoped

```mach
pub fun retain_recovery_scoped(manager: *Manager, source: u64,
    value: Handle) OperationResult
```

### configure_transport_scoped

```mach
pub fun configure_transport_scoped(manager: *Manager, source: u64,
    value: Handle, smoothed_rtt_ns: u64,
    now_ns: u64) OperationResult
```

### peek_transport_scoped

```mach
pub fun peek_transport_scoped(manager: *Manager, source: u64, value: Handle,
    smoothed_rtt_ns: u64, now_ns: u64, congestion: *quic.congestion.controller.State,
    pacer: *quic.congestion.pacer.State) bool
```

the congestion controller and pacer configure_transport_scoped would leave
`value` sending under, with nothing changed

### unconfigure_transport_scoped

```mach
pub fun unconfigure_transport_scoped(manager: *Manager, source: u64,
    value: Handle) OperationResult
```

### recovery_sent_scoped

```mach
pub fun recovery_sent_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64) OperationResult
```

### recovery_terminal_scoped

```mach
pub fun recovery_terminal_scoped(manager: *Manager, source: u64, value: Handle,
    bytes: u64) OperationResult
```

### release_recovery_scoped

```mach
pub fun release_recovery_scoped(manager: *Manager, source: u64,
    value: Handle) OperationResult
```

### begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, source: u64) OperationResult
```

### finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, source: u64) OperationResult
```

## Handle

```mach
pub rec Handle {
    source:     u64;
    index:      usize;
    generation: u64;
}
```

## ChallengeToken

```mach
pub rec ChallengeToken {
    source:          u64;
    index:           usize;
    generation:      u64;
    path_index:      usize;
    path_generation: u64;
}
```

## ResponseToken

```mach
pub rec ResponseToken {
    source:          u64;
    index:           usize;
    generation:      u64;
    path_index:      usize;
    path_generation: u64;
}
```

## SendToken

```mach
pub rec SendToken {
    source:          u64;
    index:           usize;
    generation:      u64;
    path_index:      usize;
    path_generation: u64;
    bytes:           u64;
}
```

## MtuToken

```mach
pub rec MtuToken {
    source:          u64;
    path_index:      usize;
    path_generation: u64;
    generation:      u64;
    size:            u16;
}
```

## OperationResult

```mach
pub rec OperationResult {
    status: u8;
    error:  u8;
}
```

## PathResult

```mach
pub rec PathResult {
    status: u8;
    error:  u8;
    handle: Handle;
    # a restart gave up the failed path while packets sent on it were in
    # flight. they no longer count toward any path, and the caller settles
    # them that way
    released: Handle;
}
```

## Observation

```mach
pub rec Observation {
    status:               u8;
    error:                u8;
    handle:               Handle;
    previous:             Handle;
    migration:            u8;
    created:              bool;
    selected:             bool;
    needs_validation:     bool;
    validate_previous:    bool;
    reset_congestion:     bool;
    reset_rtt:            bool;
    reset_ecn:            bool;
    rotate_connection_id: bool;
    # a path given up while packets sent on it were in flight. the caller
    # settles those packets without charging any path
    released: Handle;
}
```

## PreparedChallenge

```mach
pub rec PreparedChallenge {
    status:                u8;
    error:                 u8;
    token:                 ChallengeToken;
    handle:                Handle;
    endpoint:              Endpoint;
    data:                  [8]u8;
    minimum_datagram_size: u16;
    maximum_datagram_size: u64;
}
```

## PreparedResponse

```mach
pub rec PreparedResponse {
    status:                u8;
    error:                 u8;
    token:                 ResponseToken;
    handle:                Handle;
    endpoint:              Endpoint;
    data:                  [8]u8;
    minimum_datagram_size: u16;
    maximum_datagram_size: u64;
    require_non_probing:   bool;
}
```

## SendResult

```mach
pub rec SendResult {
    status:    u8;
    error:     u8;
    token:     SendToken;
    allowance: u64;
}
```

## ValidationResult

```mach
pub rec ValidationResult {
    status:           u8;
    error:            u8;
    handle:           Handle;
    migration:        u8;
    selected:         bool;
    ready_to_migrate: bool;
    reset_congestion: bool;
    reset_rtt:        bool;
    reset_ecn:        bool;
    # the path's address is validated but not its mtu, so a padded challenge
    # is due (rfc 9000 8.2.1)
    validate_mtu: bool;
}
```

## TimeoutResult

```mach
pub rec TimeoutResult {
    status:                u8;
    error:                 u8;
    failed:                Handle;
    selected:              Handle;
    migration:             u8;
    reverted:              bool;
    mtu_validation_failed: bool;
    connection_lost:       bool;
    rotate_connection_id:  bool;
    reset_congestion:      bool;
    reset_rtt:             bool;
    reset_ecn:             bool;
    # a challenge on this path went unanswered, so one with fresh data is due
    resend:         Handle;
    resend_purpose: u8;
}
```

## MtuPrepared

```mach
pub rec MtuPrepared {
    status: u8;
    error:  u8;
    token:  MtuToken;
    handle: Handle;
    size:   u16;
}
```

## MtuResult

```mach
pub rec MtuResult {
    status:                 u8;
    error:                  u8;
    handle:                 Handle;
    current_mtu:            u16;
    next_probe_size:        u16;
    retry:                  bool;
    changed:                bool;
    reconfigure_congestion: bool;
    reconfigure_pacer:      bool;
}
```

## Snapshot

```mach
pub rec Snapshot {
    status:                  u8;
    error:                   u8;
    endpoint:                Endpoint;
    received_bytes:          u64;
    sent_bytes:              u64;
    reserved_bytes:          u64;
    amplification_allowance: u64;
    current_mtu:             u16;
    next_probe_size:         u16;
    state:                   u8;
    selected:                bool;
    preferred:               bool;
    port_rebinding:          bool;
    address_validated:       bool;
    mtu_validated:           bool;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ROLE_CLIENT` | `u8` | `1` |  |
| `ROLE_SERVER` | `u8` | `2` |  |
| `ADDRESS_IPV4` | `u8` | `1` |  |
| `ADDRESS_IPV6` | `u8` | `2` |  |
| `PATH_FREE` | `u8` | `0` |  |
| `PATH_VALIDATING` | `u8` | `1` |  |
| `PATH_VALIDATED` | `u8` | `2` |  |
| `PATH_FAILED` | `u8` | `3` |  |
| `CHALLENGE_QUEUED` | `u8` | `1` |  |
| `CHALLENGE_PREPARED` | `u8` | `2` |  |
| `CHALLENGE_SENT` | `u8` | `3` |  |
| `RESPONSE_QUEUED` | `u8` | `1` |  |
| `RESPONSE_PREPARED` | `u8` | `2` |  |
| `MIGRATION_NONE` | `u8` | `0` |  |
| `MIGRATION_PEER` | `u8` | `1` |  |
| `MIGRATION_REBINDING` | `u8` | `2` |  |
| `MIGRATION_ACTIVE` | `u8` | `3` |  |
| `MIGRATION_PREFERRED` | `u8` | `4` |  |
| `MIGRATION_REVERTED` | `u8` | `5` |  |
| `MTU_TERMINAL_ACKED` | `u8` | `1` |  |
| `MTU_TERMINAL_LOST` | `u8` | `2` |  |
| `VALIDATION_PATH` | `u8` | `1` |  |
| `VALIDATION_MTU` | `u8` | `2` |  |
| `STATUS_OK` | `u8` | `1` |  |
| `STATUS_EMPTY` | `u8` | `2` |  |
| `STATUS_BLOCKED` | `u8` | `3` |  |
| `STATUS_DROPPED` | `u8` | `4` |  |
| `STATUS_STALE` | `u8` | `5` |  |
| `STATUS_CLOSED` | `u8` | `6` |  |
| `STATUS_ERROR` | `u8` | `7` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_CONFIG` | `u8` | `2` |  |
| `ERROR_CAPACITY` | `u8` | `3` |  |
| `ERROR_ADDRESS` | `u8` | `4` |  |
| `ERROR_TOKEN` | `u8` | `5` |  |
| `ERROR_TIME` | `u8` | `6` |  |
| `ERROR_OVERFLOW` | `u8` | `7` |  |
| `ERROR_AMPLIFICATION` | `u8` | `8` |  |
| `ERROR_MIGRATION_DISABLED` | `u8` | `9` |  |
| `ERROR_HANDSHAKE` | `u8` | `10` |  |
| `ERROR_MTU` | `u8` | `11` |  |
| `ERROR_DUPLICATE` | `u8` | `12` |  |

