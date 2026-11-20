[quic](../README.md) / [congestion](README.md) / **controller**

# quic.congestion.controller

Source: [`src/congestion/controller.mach`](../../../../src/congestion/controller.mach)

Uses types from [`quic.recovery.recovery`](../recovery/recovery.md).

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |
| [`State`](#state) | `rec` |  |
| [`Signals`](#signals) | `rec` |  |
| [`UpdateResult`](#updateresult) | `rec` |  |
| [`Admission`](#admission) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config), [`init`](#init) | |

| On `State` | |
| :--- | :--- |
| [`reset`](#reset), [`set_limited`](#set_limited), [`allowance`](#allowance), [`admit`](#admit), [`on_recovery`](#on_recovery), [`set_max_datagram_size`](#set_max_datagram_size) | |

| Constants | |
| :--- | :--- |
| [`ALGORITHM_NEW_RENO`](#constants), [`ALGORITHM_CUBIC`](#constants), [`MODE_SLOW_START`](#constants), [`MODE_RECOVERY`](#constants), [`MODE_AVOIDANCE`](#constants), [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_CONFIG`](#constants), [`ERROR_TIME`](#constants), [`ERROR_EVENTS`](#constants), [`ERROR_OVERFLOW`](#constants) | |

---

## Config

```mach
pub rec Config {
    algorithm:              u8;
    max_datagram_size:      u64;
    initial_window:         u64;
    minimum_window:         u64;
    maximum_window:         u64;
    cubic_fast_convergence: bool;
}
```

### default_config

```mach
pub fun default_config(algorithm: u8, max_datagram_size: u64) Config
```

### init

```mach
pub fun init(config: Config, now_ns: u64) State
```

## State

```mach
pub rec State {
    config:                    Config;
    congestion_window:         u64;
    slow_start_threshold:      u64;
    recovery_start_ns:         u64;
    last_event_at_ns:          u64;
    limited_started_at_ns:     u64;
    reno_accumulator:          u64;
    cubic_window_prior:        u64;
    cubic_window_max:          u64;
    cubic_epoch_window:        u64;
    cubic_epoch_started_at_ns: u64;
    cubic_paused_ns:           u64;
    cubic_estimate:            f64;
    cubic_accumulator:         u64;
    mode:                      u8;
    valid:                     bool;
    in_recovery:               bool;
    has_recovery_start:        bool;
    cubic_epoch_active:        bool;
    cubic_timeout_epoch:       bool;
    application_limited:       bool;
    flow_control_limited:      bool;
    limited_active:            bool;
}
```

### reset

```mach
pub fun reset(state: *State, now_ns: u64) OperationResult
```

### set_limited

```mach
pub fun set_limited(state: *State, application_limited: bool, flow_control_limited: bool, now_ns: u64) OperationResult
```

### allowance

```mach
pub fun allowance(state: *State, bytes_in_flight: u64) u64
```

### admit

```mach
pub fun admit(state: *State, bytes_in_flight: u64, flow_control_allowance: u64,
    congestion_bytes: u64, flow_control_bytes: u64, in_flight: bool, probe: bool) Admission
```

### on_recovery

```mach
pub fun on_recovery(state: *State, signals: Signals) UpdateResult
```

### set_max_datagram_size

```mach
pub fun set_max_datagram_size(state: *State, max_datagram_size: u64, now_ns: u64) OperationResult
```

## Signals

```mach
pub rec Signals {
    events:                 *quic.recovery.recovery.Event;
    event_count:            usize;
    bytes_in_flight_before: u64;
    now_ns:                 u64;
    smoothed_rtt_ns:        u64;
    ecn_congestion:         bool;
    ecn_sent_at_ns:         u64;
    persistent_congestion:  bool;
    growth_permitted:       bool;
    retry:                  bool;
}
```

## UpdateResult

```mach
pub rec UpdateResult {
    ok:                 bool;
    error:              u8;
    acknowledged_bytes: u64;
    lost_bytes:         u64;
    discarded_bytes:    u64;
    congestion_window:  u64;
    mode:               u8;
    reduced:            bool;
    reset:              bool;
}
```

## Admission

```mach
pub rec Admission {
    ok:                     bool;
    error:                  u8;
    permitted:              bool;
    congestion_blocked:     bool;
    flow_control_blocked:   bool;
    congestion_allowance:   u64;
    flow_control_allowance: u64;
}
```

## OperationResult

```mach
pub rec OperationResult {
    ok:    bool;
    error: u8;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ALGORITHM_NEW_RENO` | `u8` | `1` |  |
| `ALGORITHM_CUBIC` | `u8` | `2` |  |
| `MODE_SLOW_START` | `u8` | `1` |  |
| `MODE_RECOVERY` | `u8` | `2` |  |
| `MODE_AVOIDANCE` | `u8` | `3` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_CONFIG` | `u8` | `2` |  |
| `ERROR_TIME` | `u8` | `3` |  |
| `ERROR_EVENTS` | `u8` | `4` |  |
| `ERROR_OVERFLOW` | `u8` | `5` |  |

