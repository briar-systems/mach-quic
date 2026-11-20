[quic](../README.md) / [congestion](README.md) / **pacer**

# quic.congestion.pacer

Source: [`src/congestion/pacer.mach`](../../../../src/congestion/pacer.mach)

| Type | | |
| :--- | :--- | :--- |
| [`Config`](#config) | `rec` |  |
| [`State`](#state) | `rec` |  |
| [`Schedule`](#schedule-1) | `rec` |  |
| [`PublishResult`](#publishresult) | `rec` |  |
| [`OperationResult`](#operationresult) | `rec` |  |

| On `Config` | |
| :--- | :--- |
| [`default_config`](#default_config), [`init`](#init) | |

| On `State` | |
| :--- | :--- |
| [`sync`](#sync), [`reconfigure`](#reconfigure), [`schedule`](#schedule), [`publish`](#publish), [`cancel`](#cancel), [`reset`](#reset) | |

| Constants | |
| :--- | :--- |
| [`ERROR_NONE`](#constants), [`ERROR_STATE`](#constants), [`ERROR_CONFIG`](#constants), [`ERROR_TIME`](#constants), [`ERROR_PACKET`](#constants), [`ERROR_OVERFLOW`](#constants), [`PUBLISH_OK`](#constants), [`PUBLISH_STALE`](#constants), [`PUBLISH_EARLY`](#constants), [`PUBLISH_ERROR`](#constants) | |

---

## Config

```mach
pub rec Config {
    max_datagram_size: u64;
    maximum_burst:     u64;
    gain_numerator:    u32;
    gain_denominator:  u32;
}
```

### default_config

```mach
pub fun default_config(max_datagram_size: u64, initial_window: u64) Config
```

### init

```mach
pub fun init(config: Config, congestion_window: u64, smoothed_rtt_ns: u64, now_ns: u64) State
```

## State

```mach
pub rec State {
    config:                 Config;
    congestion_window:      u64;
    smoothed_rtt_ns:        u64;
    last_update_ns:         u64;
    budget:                 f64;
    generation:             u64;
    outstanding_generation: u64;
    outstanding:            bool;
    valid:                  bool;
}
```

### sync

```mach
pub fun sync(state: *State, now_ns: u64, congestion_window: u64, smoothed_rtt_ns: u64) OperationResult
```

### reconfigure

```mach
pub fun reconfigure(state: *State, config: Config, now_ns: u64,
    congestion_window: u64, smoothed_rtt_ns: u64) OperationResult
```

### schedule

```mach
pub fun schedule(state: *State, now_ns: u64, congestion_window: u64, smoothed_rtt_ns: u64,
    packet_bytes: u64, ack_only: bool) Schedule
```

### publish

```mach
pub fun publish(state: *State, scheduled: Schedule, now_ns: u64,
    congestion_window: u64, smoothed_rtt_ns: u64) PublishResult
```

### cancel

```mach
pub fun cancel(state: *State, scheduled: Schedule) OperationResult
```

### reset

```mach
pub fun reset(state: *State, congestion_window: u64, smoothed_rtt_ns: u64, now_ns: u64) OperationResult
```

## Schedule

```mach
pub rec Schedule {
    ok:                bool;
    error:             u8;
    ready:             bool;
    ack_only:          bool;
    ready_at_ns:       u64;
    packet_bytes:      u64;
    generation:        u64;
    congestion_window: u64;
    smoothed_rtt_ns:   u64;
}
```

## PublishResult

```mach
pub rec PublishResult {
    status:     u8;
    error:      u8;
    generation: u64;
    budget:     u64;
}
```

## OperationResult

```mach
pub rec OperationResult {
    ok:         bool;
    error:      u8;
    generation: u64;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_STATE` | `u8` | `1` |  |
| `ERROR_CONFIG` | `u8` | `2` |  |
| `ERROR_TIME` | `u8` | `3` |  |
| `ERROR_PACKET` | `u8` | `4` |  |
| `ERROR_OVERFLOW` | `u8` | `5` |  |
| `PUBLISH_OK` | `u8` | `1` |  |
| `PUBLISH_STALE` | `u8` | `2` |  |
| `PUBLISH_EARLY` | `u8` | `3` |  |
| `PUBLISH_ERROR` | `u8` | `4` |  |

