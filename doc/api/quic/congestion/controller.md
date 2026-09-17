# quic.congestion.controller

## val ALGORITHM_NEW_RENO

```mach
pub val ALGORITHM_NEW_RENO: u8 = 1
```

## val ALGORITHM_CUBIC

```mach
pub val ALGORITHM_CUBIC:    u8 = 2
```

## val MODE_SLOW_START

```mach
pub val MODE_SLOW_START: u8 = 1
```

## val MODE_RECOVERY

```mach
pub val MODE_RECOVERY:   u8 = 2
```

## val MODE_AVOIDANCE

```mach
pub val MODE_AVOIDANCE:  u8 = 3
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:     u8 = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:    u8 = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:   u8 = 2
```

## val ERROR_TIME

```mach
pub val ERROR_TIME:     u8 = 3
```

## val ERROR_EVENTS

```mach
pub val ERROR_EVENTS:   u8 = 4
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: u8 = 5
```

## rec Config

```mach
pub rec Config;
```

## rec State

```mach
pub rec State;
```

## rec Signals

```mach
pub rec Signals;
```

## rec UpdateResult

```mach
pub rec UpdateResult;
```

## rec Admission

```mach
pub rec Admission;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## fun default_config

```mach
pub fun default_config(algorithm: u8, max_datagram_size: u64) Config;
```

## fun init

```mach
pub fun init(config: Config, now_ns: u64) State;
```

## fun reset

```mach
pub fun reset(state: *State, now_ns: u64) OperationResult;
```

## fun set_limited

```mach
pub fun set_limited(state: *State, application_limited: bool, flow_control_limited: bool, now_ns: u64) OperationResult;
```

## fun allowance

```mach
pub fun allowance(state: *State, bytes_in_flight: u64) u64;
```

## fun admit

```mach
pub fun admit(state: *State, bytes_in_flight: u64, flow_control_allowance: u64,
congestion_bytes: u64, flow_control_bytes: u64, in_flight: bool, probe: bool) Admission;
```

## fun on_recovery

```mach
pub fun on_recovery(state: *State, signals: Signals) UpdateResult;
```

## fun set_max_datagram_size

```mach
pub fun set_max_datagram_size(state: *State, max_datagram_size: u64, now_ns: u64) OperationResult;
```

