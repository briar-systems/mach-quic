[quic](../README.md) / [recovery](README.md) / **recovery**

# quic.recovery.recovery

Source: [`src/recovery/recovery.mach`](../../../../src/recovery/recovery.mach)

Uses types from [`quic.frame.frame`](../frame/frame.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |
| [`Rtt`](#rtt) | `rec` |  |
| [`SentPacket`](#sentpacket) | `rec` |  |
| [`HistoryStorage`](#historystorage) | `rec` |  |
| [`History`](#history) | `rec` |  |
| [`Timer`](#timer) | `rec` |  |
| [`Event`](#event) | `rec` |  |
| [`Recovery`](#recovery) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |
| [`AckResult`](#ackresult) | `rec` |  |
| [`TimeoutResult`](#timeoutresult) | `rec` |  |
| [`DiscardResult`](#discardresult) | `rec` |  |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config) | |

| On `HistoryStorage` | |
| :--- | :--- |
| [`init`](#init) | |

| On `Recovery` | |
| :--- | :--- |
| [`lend_history`](#lend_history) | lends an empty space storage for its history |
| [`reclaim_history`](#reclaim_history) | takes back the storage of a space that tracks no packets, leaving it with none |
| [`has_history`](#has_history), [`tracked`](#tracked), [`update_rtt`](#update_rtt), [`current_pto`](#current_pto) | |
| [`initial_pto`](#initial_pto) | rfc 9000 8.2.4 and rfc 9002 6.2.2: the pto of a path with no rtt sample yet, from kInitialRtt and without backoff |
| [`timer`](#timer-1), [`set_handshake_keys`](#set_handshake_keys), [`confirm_handshake`](#confirm_handshake), [`set_peer_address_validated`](#set_peer_address_validated), [`set_amplification_blocked`](#set_amplification_blocked), [`reset_path`](#reset_path), [`set_max_ack_delay`](#set_max_ack_delay) | |
| [`on_untracked_sent`](#on_untracked_sent) | record a packet that carried nothing recoverable so an acknowledgement covering its number is accepted; it is never tracked for loss or rtt |
| [`note_prepared`](#note_prepared) | record the highest packet number handed to the driver for a space so an acknowledgement that arrives before the send completion is not refused |
| [`on_packet_sent`](#on_packet_sent), [`on_ack_path`](#on_ack_path), [`on_ack`](#on_ack), [`on_timeout_path`](#on_timeout_path), [`on_timeout`](#on_timeout), [`discard_space`](#discard_space), [`on_retry`](#on_retry) | |
| [`discard_all`](#discard_all) | drains every packet-number space during terminal connection teardown |

| Constants | |
| :--- | :--- |
| [`TIMER_NONE`](#constants), [`TIMER_LOSS`](#constants), [`TIMER_PTO`](#constants), [`EVENT_ACKED`](#constants), [`EVENT_LOST`](#constants), [`EVENT_DISCARDED`](#constants), [`EVENT_RETRY`](#constants), [`TIMEOUT_NONE`](#constants), [`TIMEOUT_LOSS`](#constants), [`TIMEOUT_PROBE`](#constants), [`TIMEOUT_STALE`](#constants), [`TIMEOUT_EARLY`](#constants), [`TIMEOUT_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_SPACE`](#constants), [`ERROR_HISTORY_FULL`](#constants), [`ERROR_PACKET_NUMBER`](#constants), [`ERROR_TIME`](#constants), [`ERROR_OVERFLOW`](#constants), [`ERROR_ACK`](#constants), [`ERROR_EVENT_CAPACITY`](#constants), [`ERROR_ECN`](#constants) | |

---

## Config

```mach
pub rec Config {
    initial_rtt_ns:                  u64;
    granularity_ns:                  u64;
    max_ack_delay_ns:                u64;
    packet_threshold:                u64;
    persistent_congestion_threshold: u8;
    max_pto_backoff:                 u8;
}
```

### default_config

```mach
pub fun default_config() Config
```

## Rtt

```mach
pub rec Rtt {
    latest_ns:          u64;
    minimum_ns:         u64;
    smoothed_ns:        u64;
    variance_ns:        u64;
    first_sample_at_ns: u64;
    has_sample:         bool;
}
```

## SentPacket

```mach
pub rec SentPacket {
    number:                u64;
    sent_at_ns:            u64;
    bytes:                 usize;
    owner:                 u64;
    path_source:           u64;
    path_index:            usize;
    path_generation:       u64;
    ecn:                   u8;
    ack_eliciting:         bool;
    in_flight:             bool;
    sent_after_rtt_sample: bool;
}
```

## HistoryStorage

```mach
pub rec HistoryStorage {
    packets:  *SentPacket;
    capacity: usize;
}
```

### init

```mach
pub fun init(initial: HistoryStorage, handshake: HistoryStorage, application: HistoryStorage, config: Config) Recovery
```

## History

```mach
pub rec History {
    packets:                  *SentPacket;
    capacity:                 usize;
    len:                      usize;
    largest_sent:             u64;
    largest_prepared:         u64;
    largest_acked:            u64;
    loss_time_ns:             u64;
    last_ack_eliciting_at_ns: u64;
    ack_eliciting_in_flight:  usize;
    has_largest_sent:         bool;
    has_largest_prepared:     bool;
    has_largest_acked:        bool;
    active:                   bool;
}
```

## Timer

```mach
pub rec Timer {
    armed:       bool;
    kind:        u8;
    space:       u8;
    deadline_ns: u64;
    generation:  u64;
}
```

## Event

```mach
pub rec Event {
    kind:                  u8;
    space:                 u8;
    number:                u64;
    sent_at_ns:            u64;
    bytes:                 usize;
    owner:                 u64;
    path_source:           u64;
    path_index:            usize;
    path_generation:       u64;
    ecn:                   u8;
    ack_eliciting:         bool;
    in_flight:             bool;
    sent_after_rtt_sample: bool;
}
```

## Recovery

```mach
pub rec Recovery {
    spaces:                   [3]History;
    rtt:                      Rtt;
    config:                   Config;
    timer:                    Timer;
    bytes_in_flight:          usize;
    pto_count:                u32;
    last_sent_at_ns:          u64;
    latest_acked_sent_at_ns:  u64;
    persistent_start_ns:      u64;
    persistent_end_ns:        u64;
    valid:                    bool;
    has_last_sent:            bool;
    has_latest_acked_sent:    bool;
    persistent_active:        bool;
    handshake_confirmed:      bool;
    handshake_keys_available: bool;
    peer_address_validated:   bool;
    amplification_blocked:    bool;
}
```

### lend_history

```mach
pub fun lend_history(recovery: *Recovery, pn_space: u8, storage: HistoryStorage) bool
```

lends an empty space storage for its history. a space that already has
storage, or that was discarded, takes none

### reclaim_history

```mach
pub fun reclaim_history(recovery: *Recovery, pn_space: u8) HistoryStorage
```

takes back the storage of a space that tracks no packets, leaving it with
none. a space still tracking packets keeps its storage and gives back none

### has_history

```mach
pub fun has_history(recovery: *Recovery, pn_space: u8) bool
```

### tracked

```mach
pub fun tracked(recovery: *Recovery, pn_space: u8) usize
```

### update_rtt

```mach
pub fun update_rtt(recovery: *Recovery, latest_ns: u64, ack_delay_ns: u64, sample_at_ns: u64) bool
```

### current_pto

```mach
pub fun current_pto(recovery: *Recovery, application: bool) u64
```

### initial_pto

```mach
pub fun initial_pto(recovery: *Recovery, application: bool) u64
```

rfc 9000 8.2.4 and rfc 9002 6.2.2: the pto of a path with no rtt sample yet,
from kInitialRtt and without backoff

### timer

```mach
pub fun timer(recovery: *Recovery) Timer
```

### set_handshake_keys

```mach
pub fun set_handshake_keys(recovery: *Recovery, available: bool, now_ns: u64) OperationResult
```

### confirm_handshake

```mach
pub fun confirm_handshake(recovery: *Recovery, now_ns: u64) OperationResult
```

### set_peer_address_validated

```mach
pub fun set_peer_address_validated(recovery: *Recovery, validated: bool, now_ns: u64) OperationResult
```

### set_amplification_blocked

```mach
pub fun set_amplification_blocked(recovery: *Recovery, blocked: bool, now_ns: u64) OperationResult
```

### reset_path

```mach
pub fun reset_path(recovery: *Recovery, now_ns: u64) OperationResult
```

### set_max_ack_delay

```mach
pub fun set_max_ack_delay(recovery: *Recovery, value_ns: u64,
    now_ns: u64) OperationResult
```

### on_untracked_sent

```mach
pub fun on_untracked_sent(recovery: *Recovery, pn_space: u8, number: u64,
    sent_at_ns: u64) OperationResult
```

record a packet that carried nothing recoverable so an acknowledgement
covering its number is accepted; it is never tracked for loss or rtt

### note_prepared

```mach
pub fun note_prepared(recovery: *Recovery, pn_space: u8, number: u64) bool
```

record the highest packet number handed to the driver for a space so an
acknowledgement that arrives before the send completion is not refused

### on_packet_sent

```mach
pub fun on_packet_sent(recovery: *Recovery, pn_space: u8, sent: SentPacket) OperationResult
```

### on_ack_path

```mach
pub fun on_ack_path(recovery: *Recovery, pn_space: u8, ack: *quic.frame.frame.Frame,
    received_at_ns: u64, ack_delay_exponent: u8,
    path_source: u64, path_index: usize,
    path_generation: u64, events: *Event,
    capacity: usize) AckResult
```

### on_ack

```mach
pub fun on_ack(recovery: *Recovery, pn_space: u8, ack: *quic.frame.frame.Frame,
    received_at_ns: u64, ack_delay_exponent: u8,
    events: *Event, capacity: usize) AckResult
```

### on_timeout_path

```mach
pub fun on_timeout_path(recovery: *Recovery, now_ns: u64, generation: u64,
    path_source: u64, path_index: usize,
    path_generation: u64, events: *Event,
    capacity: usize) TimeoutResult
```

### on_timeout

```mach
pub fun on_timeout(recovery: *Recovery, now_ns: u64, generation: u64,
    events: *Event, capacity: usize) TimeoutResult
```

### discard_space

```mach
pub fun discard_space(recovery: *Recovery, pn_space: u8, now_ns: u64, events: *Event, capacity: usize) DiscardResult
```

### on_retry

```mach
pub fun on_retry(recovery: *Recovery, now_ns: u64, events: *Event, capacity: usize) DiscardResult
```

### discard_all

```mach
pub fun discard_all(recovery: *Recovery, now_ns: u64, events: *Event,
    capacity: usize) DiscardResult
```

drains every packet-number space during terminal connection teardown

## OperationResult

```mach
pub rec OperationResult {
    ok:    bool;
    error: u8;
    timer: Timer;
}
```

## AckResult

```mach
pub rec AckResult {
    ok:                    bool;
    error:                 u8;
    event_count:           usize;
    acked_count:           usize;
    lost_count:            usize;
    persistent_congestion: bool;
    timer:                 Timer;
}
```

## TimeoutResult

```mach
pub rec TimeoutResult {
    status:                u8;
    error:                 u8;
    event_count:           usize;
    probe_count:           u8;
    probe_space:           u8;
    probe_owner:           u64;
    persistent_congestion: bool;
    has_probe_owner:       bool;
    timer:                 Timer;
}
```

## DiscardResult

```mach
pub rec DiscardResult {
    ok:          bool;
    error:       u8;
    event_count: usize;
    timer:       Timer;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `TIMER_NONE` | `u8` | `0` |  |
| `TIMER_LOSS` | `u8` | `1` |  |
| `TIMER_PTO` | `u8` | `2` |  |
| `EVENT_ACKED` | `u8` | `1` |  |
| `EVENT_LOST` | `u8` | `2` |  |
| `EVENT_DISCARDED` | `u8` | `3` |  |
| `EVENT_RETRY` | `u8` | `4` |  |
| `TIMEOUT_NONE` | `u8` | `0` |  |
| `TIMEOUT_LOSS` | `u8` | `1` |  |
| `TIMEOUT_PROBE` | `u8` | `2` |  |
| `TIMEOUT_STALE` | `u8` | `3` |  |
| `TIMEOUT_EARLY` | `u8` | `4` |  |
| `TIMEOUT_ERROR` | `u8` | `5` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_SPACE` | `u8` | `2` |  |
| `ERROR_HISTORY_FULL` | `u8` | `3` |  |
| `ERROR_PACKET_NUMBER` | `u8` | `4` |  |
| `ERROR_TIME` | `u8` | `5` |  |
| `ERROR_OVERFLOW` | `u8` | `6` |  |
| `ERROR_ACK` | `u8` | `7` |  |
| `ERROR_EVENT_CAPACITY` | `u8` | `8` |  |
| `ERROR_ECN` | `u8` | `9` |  |

