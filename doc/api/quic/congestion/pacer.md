# quic.congestion.pacer

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

## val ERROR_PACKET

```mach
pub val ERROR_PACKET:   u8 = 4
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW: u8 = 5
```

## val PUBLISH_OK

```mach
pub val PUBLISH_OK:    u8 = 1
```

## val PUBLISH_STALE

```mach
pub val PUBLISH_STALE: u8 = 2
```

## val PUBLISH_EARLY

```mach
pub val PUBLISH_EARLY: u8 = 3
```

## val PUBLISH_ERROR

```mach
pub val PUBLISH_ERROR: u8 = 4
```

## rec Config

```mach
pub rec Config;
```

## rec State

```mach
pub rec State;
```

## rec Schedule

```mach
pub rec Schedule;
```

## rec PublishResult

```mach
pub rec PublishResult;
```

## rec OperationResult

```mach
pub rec OperationResult;
```

## fun default_config

```mach
pub fun default_config(max_datagram_size: u64, initial_window: u64) Config;
```

## fun init

```mach
pub fun init(config: Config, congestion_window: u64, smoothed_rtt_ns: u64, now_ns: u64) State;
```

## fun sync

```mach
pub fun sync(state: *State, now_ns: u64, congestion_window: u64, smoothed_rtt_ns: u64) OperationResult;
```

## fun reconfigure

```mach
pub fun reconfigure(state: *State, config: Config, now_ns: u64,
congestion_window: u64, smoothed_rtt_ns: u64) OperationResult;
```

## fun schedule

```mach
pub fun schedule(state: *State, now_ns: u64, congestion_window: u64, smoothed_rtt_ns: u64,
packet_bytes: u64, ack_only: bool) Schedule;
```

## fun publish

```mach
pub fun publish(state: *State, scheduled: Schedule, now_ns: u64,
congestion_window: u64, smoothed_rtt_ns: u64) PublishResult;
```

## fun cancel

```mach
pub fun cancel(state: *State, scheduled: Schedule) OperationResult;
```

## fun reset

```mach
pub fun reset(state: *State, congestion_window: u64, smoothed_rtt_ns: u64, now_ns: u64) OperationResult;
```

