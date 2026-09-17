# quic.recovery.recovery

## val TIMER_NONE

```mach
pub val TIMER_NONE: u8 = 0
```

## val TIMER_LOSS

```mach
pub val TIMER_LOSS: u8 = 1
```

## val TIMER_PTO

```mach
pub val TIMER_PTO:  u8 = 2
```

## val EVENT_ACKED

```mach
pub val EVENT_ACKED:     u8 = 1
```

## val EVENT_LOST

```mach
pub val EVENT_LOST:      u8 = 2
```

## val EVENT_DISCARDED

```mach
pub val EVENT_DISCARDED: u8 = 3
```

## val EVENT_RETRY

```mach
pub val EVENT_RETRY:     u8 = 4
```

## val TIMEOUT_NONE

```mach
pub val TIMEOUT_NONE:  u8 = 0
```

## val TIMEOUT_LOSS

```mach
pub val TIMEOUT_LOSS:  u8 = 1
```

## val TIMEOUT_PROBE

```mach
pub val TIMEOUT_PROBE: u8 = 2
```

## val TIMEOUT_STALE

```mach
pub val TIMEOUT_STALE: u8 = 3
```

## val TIMEOUT_EARLY

```mach
pub val TIMEOUT_EARLY: u8 = 4
```

## val TIMEOUT_ERROR

```mach
pub val TIMEOUT_ERROR: u8 = 5
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:           u8 = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:          u8 = 1
```

## val ERROR_SPACE

```mach
pub val ERROR_SPACE:          u8 = 2
```

## val ERROR_HISTORY_FULL

```mach
pub val ERROR_HISTORY_FULL:   u8 = 3
```

## val ERROR_PACKET_NUMBER

```mach
pub val ERROR_PACKET_NUMBER:  u8 = 4
```

## val ERROR_TIME

```mach
pub val ERROR_TIME:           u8 = 5
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW:       u8 = 6
```

## val ERROR_ACK

```mach
pub val ERROR_ACK:            u8 = 7
```

## val ERROR_EVENT_CAPACITY

```mach
pub val ERROR_EVENT_CAPACITY: u8 = 8
```

## val ERROR_ECN

```mach
pub val ERROR_ECN:            u8 = 9
```

## rec Config

```mach
pub rec Config;
```

## rec Rtt

```mach
pub rec Rtt;
```

## rec SentPacket

```mach
pub rec SentPacket;
```

## rec HistoryStorage

```mach
pub rec HistoryStorage;
```

## rec History

```mach
pub rec History;
```

## rec Timer

```mach
pub rec Timer;
```

## rec Event

```mach
pub rec Event;
```

## rec Recovery

```mach
pub rec Recovery;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## rec AckResult

```mach
pub rec AckResult;
```

## rec TimeoutResult

```mach
pub rec TimeoutResult;
```

## rec DiscardResult

```mach
pub rec DiscardResult;
```

## fun default_config

```mach
pub fun default_config() Config;
```

## fun init

```mach
pub fun init(initial: HistoryStorage, handshake: HistoryStorage, application: HistoryStorage, config: Config) Recovery;
```

## fun lend_history

```mach
pub fun lend_history(recovery: *Recovery, pn_space: u8, storage: HistoryStorage) bool;
```

lends an empty space storage for its history. a space that already has
storage, or that was discarded, takes none

## fun reclaim_history

```mach
pub fun reclaim_history(recovery: *Recovery, pn_space: u8) HistoryStorage;
```

takes back the storage of a space that tracks no packets, leaving it with
none. a space still tracking packets keeps its storage and gives back none

## fun has_history

```mach
pub fun has_history(recovery: *Recovery, pn_space: u8) bool;
```

## fun tracked

```mach
pub fun tracked(recovery: *Recovery, pn_space: u8) usize;
```

## fun update_rtt

```mach
pub fun update_rtt(recovery: *Recovery, latest_ns: u64, ack_delay_ns: u64, sample_at_ns: u64) bool;
```

## fun current_pto

```mach
pub fun current_pto(recovery: *Recovery, application: bool) u64;
```

## fun timer

```mach
pub fun timer(recovery: *Recovery) Timer;
```

## fun set_handshake_keys

```mach
pub fun set_handshake_keys(recovery: *Recovery, available: bool, now_ns: u64) OperationResult;
```

## fun confirm_handshake

```mach
pub fun confirm_handshake(recovery: *Recovery, now_ns: u64) OperationResult;
```

## fun set_peer_address_validated

```mach
pub fun set_peer_address_validated(recovery: *Recovery, validated: bool, now_ns: u64) OperationResult;
```

## fun set_amplification_blocked

```mach
pub fun set_amplification_blocked(recovery: *Recovery, blocked: bool, now_ns: u64) OperationResult;
```

## fun reset_path

```mach
pub fun reset_path(recovery: *Recovery, now_ns: u64) OperationResult;
```

## fun set_max_ack_delay

```mach
pub fun set_max_ack_delay(recovery: *Recovery, value_ns: u64,
now_ns: u64) OperationResult;
```

## fun on_untracked_sent

```mach
pub fun on_untracked_sent(recovery: *Recovery, pn_space: u8, number: u64,
sent_at_ns: u64) OperationResult;
```

record a packet that carried nothing recoverable so an acknowledgement
covering its number is accepted; it is never tracked for loss or rtt

## fun note_prepared

```mach
pub fun note_prepared(recovery: *Recovery, pn_space: u8, number: u64) bool;
```

record the highest packet number handed to the driver for a space so an
acknowledgement that arrives before the send completion is not refused

## fun on_packet_sent

```mach
pub fun on_packet_sent(recovery: *Recovery, pn_space: u8, sent: SentPacket) OperationResult;
```

## fun on_ack_path

```mach
pub fun on_ack_path(recovery: *Recovery, pn_space: u8, ack: *frame.Frame,
received_at_ns: u64, ack_delay_exponent: u8,
path_source: u64, path_index: usize,
path_generation: u64, events: *Event,
capacity: usize) AckResult;
```

## fun on_ack

```mach
pub fun on_ack(recovery: *Recovery, pn_space: u8, ack: *frame.Frame,
received_at_ns: u64, ack_delay_exponent: u8,
events: *Event, capacity: usize) AckResult;
```

## fun on_timeout_path

```mach
pub fun on_timeout_path(recovery: *Recovery, now_ns: u64, generation: u64,
path_source: u64, path_index: usize,
path_generation: u64, events: *Event,
capacity: usize) TimeoutResult;
```

## fun on_timeout

```mach
pub fun on_timeout(recovery: *Recovery, now_ns: u64, generation: u64,
events: *Event, capacity: usize) TimeoutResult;
```

## fun discard_space

```mach
pub fun discard_space(recovery: *Recovery, pn_space: u8, now_ns: u64, events: *Event, capacity: usize) DiscardResult;
```

## fun on_retry

```mach
pub fun on_retry(recovery: *Recovery, now_ns: u64, events: *Event, capacity: usize) DiscardResult;
```

## fun discard_all

```mach
pub fun discard_all(recovery: *Recovery, now_ns: u64, events: *Event,
capacity: usize) DiscardResult;
```

drains every packet-number space during terminal connection teardown

