# quic.path.path

## val ROLE_CLIENT

```mach
pub val ROLE_CLIENT: u8 = 1
```

## val ROLE_SERVER

```mach
pub val ROLE_SERVER: u8 = 2
```

## val ADDRESS_IPV4

```mach
pub val ADDRESS_IPV4: u8 = 1
```

## val ADDRESS_IPV6

```mach
pub val ADDRESS_IPV6: u8 = 2
```

## val PATH_FREE

```mach
pub val PATH_FREE: u8 = 0
```

## val PATH_VALIDATING

```mach
pub val PATH_VALIDATING: u8 = 1
```

## val PATH_VALIDATED

```mach
pub val PATH_VALIDATED: u8 = 2
```

## val PATH_FAILED

```mach
pub val PATH_FAILED: u8 = 3
```

## val CHALLENGE_QUEUED

```mach
pub val CHALLENGE_QUEUED: u8 = 1
```

## val CHALLENGE_PREPARED

```mach
pub val CHALLENGE_PREPARED: u8 = 2
```

## val CHALLENGE_SENT

```mach
pub val CHALLENGE_SENT: u8 = 3
```

## val RESPONSE_QUEUED

```mach
pub val RESPONSE_QUEUED: u8 = 1
```

## val RESPONSE_PREPARED

```mach
pub val RESPONSE_PREPARED: u8 = 2
```

## val MIGRATION_NONE

```mach
pub val MIGRATION_NONE: u8 = 0
```

## val MIGRATION_PEER

```mach
pub val MIGRATION_PEER: u8 = 1
```

## val MIGRATION_REBINDING

```mach
pub val MIGRATION_REBINDING: u8 = 2
```

## val MIGRATION_ACTIVE

```mach
pub val MIGRATION_ACTIVE: u8 = 3
```

## val MIGRATION_PREFERRED

```mach
pub val MIGRATION_PREFERRED: u8 = 4
```

## val MIGRATION_REVERTED

```mach
pub val MIGRATION_REVERTED: u8 = 5
```

## val MTU_TERMINAL_ACKED

```mach
pub val MTU_TERMINAL_ACKED: u8 = 1
```

## val MTU_TERMINAL_LOST

```mach
pub val MTU_TERMINAL_LOST: u8 = 2
```

## val VALIDATION_PATH

```mach
pub val VALIDATION_PATH: u8 = 1
```

## val VALIDATION_MTU

```mach
pub val VALIDATION_MTU: u8 = 2
```

## val STATUS_OK

```mach
pub val STATUS_OK: u8 = 1
```

## val STATUS_EMPTY

```mach
pub val STATUS_EMPTY: u8 = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: u8 = 3
```

## val STATUS_DROPPED

```mach
pub val STATUS_DROPPED: u8 = 4
```

## val STATUS_STALE

```mach
pub val STATUS_STALE: u8 = 5
```

## val STATUS_CLOSED

```mach
pub val STATUS_CLOSED: u8 = 6
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: u8 = 7
```

## val ERROR_NONE

```mach
pub val ERROR_NONE: u8 = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE: u8 = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG: u8 = 2
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: u8 = 3
```

## val ERROR_ADDRESS

```mach
pub val ERROR_ADDRESS: u8 = 4
```

## val ERROR_TOKEN

```mach
pub val ERROR_TOKEN: u8 = 5
```

## val ERROR_TIME

```mach
pub val ERROR_TIME: u8 = 6
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: u8 = 7
```

## val ERROR_AMPLIFICATION

```mach
pub val ERROR_AMPLIFICATION: u8 = 8
```

## val ERROR_MIGRATION_DISABLED

```mach
pub val ERROR_MIGRATION_DISABLED: u8 = 9
```

## val ERROR_HANDSHAKE

```mach
pub val ERROR_HANDSHAKE: u8 = 10
```

## val ERROR_MTU

```mach
pub val ERROR_MTU: u8 = 11
```

## val ERROR_DUPLICATE

```mach
pub val ERROR_DUPLICATE: u8 = 12
```

## rec Address

```mach
pub rec Address;
```

## rec Endpoint

```mach
pub rec Endpoint;
```

## rec Config

```mach
pub rec Config;
```

## rec Path

```mach
pub rec Path;
```

## rec Challenge

```mach
pub rec Challenge;
```

## rec Response

```mach
pub rec Response;
```

## rec SendReservation

```mach
pub rec SendReservation;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Manager

```mach
pub rec Manager;
```

## rec Handle

```mach
pub rec Handle;
```

## rec ChallengeToken

```mach
pub rec ChallengeToken;
```

## rec ResponseToken

```mach
pub rec ResponseToken;
```

## rec SendToken

```mach
pub rec SendToken;
```

## rec MtuToken

```mach
pub rec MtuToken;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## rec PathResult

```mach
pub rec PathResult;
```

## rec Observation

```mach
pub rec Observation;
```

## rec PreparedChallenge

```mach
pub rec PreparedChallenge;
```

## rec PreparedResponse

```mach
pub rec PreparedResponse;
```

## rec SendResult

```mach
pub rec SendResult;
```

## rec ValidationResult

```mach
pub rec ValidationResult;
```

## rec TimeoutResult

```mach
pub rec TimeoutResult;
```

## rec MtuPrepared

```mach
pub rec MtuPrepared;
```

## rec MtuResult

```mach
pub rec MtuResult;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## fun ipv4

```mach
pub fun ipv4(a: u8, b: u8, c: u8, d: u8, port: u16) Address;
```

## fun ipv6

```mach
pub fun ipv6(bytes: [16]u8, port: u16, scope_id: u32) Address;
```

## fun address_equal

```mach
pub fun address_equal(a: Address, b: Address) bool;
```

## fun same_address_without_port

```mach
pub fun same_address_without_port(a: Address, b: Address) bool;
```

## fun endpoint_equal

```mach
pub fun endpoint_equal(a: Endpoint, b: Endpoint) bool;
```

## fun default_config

```mach
pub fun default_config(source: u64, role: u8, initial_address_validated: bool) Config;
```

## fun initialize

```mach
pub fun initialize(manager: *Manager, config: Config, storage: Storage,
initial: Endpoint) bool;
```

## fun selected

```mach
pub fun selected(manager: *Manager) PathResult;
```

## fun lease_core

```mach
pub fun lease_core(manager: *Manager, source: u64) bool;
```

## fun release_core

```mach
pub fun release_core(manager: *Manager, source: u64) bool;
```

## fun find

```mach
pub fun find(manager: *Manager, endpoint: Endpoint) PathResult;
```

## fun confirm_handshake

```mach
pub fun confirm_handshake(manager: *Manager) OperationResult;
```

## fun validate_address

```mach
pub fun validate_address(manager: *Manager, value: Handle) OperationResult;
```

receiving a handshake packet proves return routability on that path

## fun observe

```mach
pub fun observe(manager: *Manager, endpoint: Endpoint, packet_number: u64, bytes: u64,
non_probing: bool, authenticated: bool, fresh: bool,
connection_id_available: bool, now_ns: u64) Observation;
```

## fun probe

```mach
pub fun probe(manager: *Manager, endpoint: Endpoint, preferred: bool) PathResult;
```

## fun migrate

```mach
pub fun migrate(manager: *Manager, value: Handle, preferred: bool,
connection_id_available: bool) Observation;
```

## fun queue_challenge

```mach
pub fun queue_challenge(manager: *Manager, value: Handle, data: [8]u8,
current_pto_ns: u64, path_pto_ns: u64,
padded: bool, purpose: u8) OperationResult;
```

## fun prepare_challenge

```mach
pub fun prepare_challenge(manager: *Manager, value: Handle) PreparedChallenge;
```

## fun cancel_challenge

```mach
pub fun cancel_challenge(manager: *Manager, token: ChallengeToken) OperationResult;
```

## fun publish_challenge

```mach
pub fun publish_challenge(manager: *Manager, token: ChallengeToken, now_ns: u64) OperationResult;
```

## fun receive_response

```mach
pub fun receive_response(manager: *Manager, data: [8]u8, now_ns: u64) ValidationResult;
```

## fun queue_response

```mach
pub fun queue_response(manager: *Manager, value: Handle, data: [8]u8) OperationResult;
```

## fun prepare_response

```mach
pub fun prepare_response(manager: *Manager, value: Handle) PreparedResponse;
```

## fun cancel_response

```mach
pub fun cancel_response(manager: *Manager, token: ResponseToken) OperationResult;
```

## fun publish_response

```mach
pub fun publish_response(manager: *Manager, token: ResponseToken) OperationResult;
```

## fun reserve_send

```mach
pub fun reserve_send(manager: *Manager, value: Handle, bytes: u64,
non_probing: bool) SendResult;
```

## fun reserve_mtu_send

```mach
pub fun reserve_mtu_send(manager: *Manager, value: Handle, bytes: u64,
non_probing: bool, token: MtuToken) SendResult;
```

## fun cancel_send

```mach
pub fun cancel_send(manager: *Manager, token: SendToken) OperationResult;
```

## fun publish_send

```mach
pub fun publish_send(manager: *Manager, token: SendToken) OperationResult;
```

## fun on_timeout

```mach
pub fun on_timeout(manager: *Manager, now_ns: u64) TimeoutResult;
```

## fun prepare_mtu_probe

```mach
pub fun prepare_mtu_probe(manager: *Manager, value: Handle) MtuPrepared;
```

## fun cancel_mtu_probe

```mach
pub fun cancel_mtu_probe(manager: *Manager, token: MtuToken) OperationResult;
```

## fun publish_mtu_probe

```mach
pub fun publish_mtu_probe(manager: *Manager, token: MtuToken) OperationResult;
```

## fun on_mtu_terminal

```mach
pub fun on_mtu_terminal(manager: *Manager, token: MtuToken, terminal: u8) MtuResult;
```

## fun on_large_packet_lost

```mach
pub fun on_large_packet_lost(manager: *Manager, value: Handle, packet_size: u16) MtuResult;
```

## fun on_packet_acked

```mach
pub fun on_packet_acked(manager: *Manager, value: Handle, packet_size: u16) OperationResult;
```

## fun on_packet_too_big

```mach
pub fun on_packet_too_big(manager: *Manager, value: Handle, reported_mtu: u16,
quote_authenticated: bool) MtuResult;
```

## fun snapshot

```mach
pub fun snapshot(manager: *Manager, value: Handle) Snapshot;
```

## fun retain_recovery

```mach
pub fun retain_recovery(manager: *Manager, value: Handle) OperationResult;
```

## fun configure_transport

```mach
pub fun configure_transport(manager: *Manager, value: Handle,
smoothed_rtt_ns: u64,
now_ns: u64) OperationResult;
```

## fun unconfigure_transport

```mach
pub fun unconfigure_transport(manager: *Manager, value: Handle) OperationResult;
```

## fun recovery_sent

```mach
pub fun recovery_sent(manager: *Manager, value: Handle,
bytes: u64) OperationResult;
```

## fun recovery_terminal

```mach
pub fun recovery_terminal(manager: *Manager, value: Handle,
bytes: u64) OperationResult;
```

## fun release_recovery

```mach
pub fun release_recovery(manager: *Manager, value: Handle) OperationResult;
```

## fun restart

```mach
pub fun restart(manager: *Manager, value: Handle) PathResult;
```

## fun release

```mach
pub fun release(manager: *Manager, value: Handle) OperationResult;
```

## fun begin_close

```mach
pub fun begin_close(manager: *Manager) OperationResult;
```

## fun finish_close

```mach
pub fun finish_close(manager: *Manager) OperationResult;
```

## fun confirm_handshake_scoped

```mach
pub fun confirm_handshake_scoped(manager: *Manager,
source: u64) OperationResult;
```

## fun validate_address_scoped

```mach
pub fun validate_address_scoped(manager: *Manager, source: u64,
value: Handle) OperationResult;
```

## fun observe_scoped

```mach
pub fun observe_scoped(manager: *Manager, source: u64, endpoint: Endpoint,
packet_number: u64, bytes: u64, non_probing: bool,
authenticated: bool, fresh: bool,
connection_id_available: bool,
now_ns: u64) Observation;
```

## fun probe_scoped

```mach
pub fun probe_scoped(manager: *Manager, source: u64, endpoint: Endpoint,
preferred: bool) PathResult;
```

## fun migrate_scoped

```mach
pub fun migrate_scoped(manager: *Manager, source: u64, value: Handle,
preferred: bool,
connection_id_available: bool) Observation;
```

## fun queue_challenge_scoped

```mach
pub fun queue_challenge_scoped(manager: *Manager, source: u64,
value: Handle, data: [8]u8,
current_pto_ns: u64, path_pto_ns: u64,
padded: bool, purpose: u8) OperationResult;
```

## fun prepare_challenge_scoped

```mach
pub fun prepare_challenge_scoped(manager: *Manager, source: u64,
value: Handle) PreparedChallenge;
```

## fun cancel_challenge_scoped

```mach
pub fun cancel_challenge_scoped(manager: *Manager, source: u64,
token: ChallengeToken) OperationResult;
```

## fun publish_challenge_scoped

```mach
pub fun publish_challenge_scoped(manager: *Manager, source: u64,
token: ChallengeToken,
now_ns: u64) OperationResult;
```

## fun receive_response_scoped

```mach
pub fun receive_response_scoped(manager: *Manager, source: u64, data: [8]u8,
now_ns: u64) ValidationResult;
```

## fun queue_response_scoped

```mach
pub fun queue_response_scoped(manager: *Manager, source: u64, value: Handle,
data: [8]u8) OperationResult;
```

## fun prepare_response_scoped

```mach
pub fun prepare_response_scoped(manager: *Manager, source: u64,
value: Handle) PreparedResponse;
```

## fun cancel_response_scoped

```mach
pub fun cancel_response_scoped(manager: *Manager, source: u64,
token: ResponseToken) OperationResult;
```

## fun publish_response_scoped

```mach
pub fun publish_response_scoped(manager: *Manager, source: u64,
token: ResponseToken) OperationResult;
```

## fun reserve_send_scoped

```mach
pub fun reserve_send_scoped(manager: *Manager, source: u64, value: Handle,
bytes: u64, non_probing: bool) SendResult;
```

## fun reserve_mtu_send_scoped

```mach
pub fun reserve_mtu_send_scoped(manager: *Manager, source: u64, value: Handle,
bytes: u64, non_probing: bool,
token: MtuToken) SendResult;
```

## fun cancel_send_scoped

```mach
pub fun cancel_send_scoped(manager: *Manager, source: u64,
token: SendToken) OperationResult;
```

## fun publish_send_scoped

```mach
pub fun publish_send_scoped(manager: *Manager, source: u64,
token: SendToken) OperationResult;
```

## fun on_timeout_scoped

```mach
pub fun on_timeout_scoped(manager: *Manager, source: u64,
now_ns: u64) TimeoutResult;
```

## fun prepare_mtu_probe_scoped

```mach
pub fun prepare_mtu_probe_scoped(manager: *Manager, source: u64,
value: Handle) MtuPrepared;
```

## fun cancel_mtu_probe_scoped

```mach
pub fun cancel_mtu_probe_scoped(manager: *Manager, source: u64,
token: MtuToken) OperationResult;
```

## fun publish_mtu_probe_scoped

```mach
pub fun publish_mtu_probe_scoped(manager: *Manager, source: u64,
token: MtuToken) OperationResult;
```

## fun on_mtu_terminal_scoped

```mach
pub fun on_mtu_terminal_scoped(manager: *Manager, source: u64, token: MtuToken,
terminal: u8) MtuResult;
```

## fun on_large_packet_lost_scoped

```mach
pub fun on_large_packet_lost_scoped(manager: *Manager, source: u64,
value: Handle,
packet_size: u16) MtuResult;
```

## fun on_packet_acked_scoped

```mach
pub fun on_packet_acked_scoped(manager: *Manager, source: u64, value: Handle,
packet_size: u16) OperationResult;
```

## fun on_packet_too_big_scoped

```mach
pub fun on_packet_too_big_scoped(manager: *Manager, source: u64,
value: Handle, reported_mtu: u16,
quote_authenticated: bool) MtuResult;
```

## fun retain_recovery_scoped

```mach
pub fun retain_recovery_scoped(manager: *Manager, source: u64,
value: Handle) OperationResult;
```

## fun configure_transport_scoped

```mach
pub fun configure_transport_scoped(manager: *Manager, source: u64,
value: Handle, smoothed_rtt_ns: u64,
now_ns: u64) OperationResult;
```

## fun unconfigure_transport_scoped

```mach
pub fun unconfigure_transport_scoped(manager: *Manager, source: u64,
value: Handle) OperationResult;
```

## fun recovery_sent_scoped

```mach
pub fun recovery_sent_scoped(manager: *Manager, source: u64, value: Handle,
bytes: u64) OperationResult;
```

## fun recovery_terminal_scoped

```mach
pub fun recovery_terminal_scoped(manager: *Manager, source: u64, value: Handle,
bytes: u64) OperationResult;
```

## fun release_recovery_scoped

```mach
pub fun release_recovery_scoped(manager: *Manager, source: u64,
value: Handle) OperationResult;
```

## fun begin_close_scoped

```mach
pub fun begin_close_scoped(manager: *Manager, source: u64) OperationResult;
```

## fun finish_close_scoped

```mach
pub fun finish_close_scoped(manager: *Manager, source: u64) OperationResult;
```

