# quic.recovery.ack

## val RECEIVE_NEW

```mach
pub val RECEIVE_NEW: u8 = 1
```

## val RECEIVE_DUPLICATE

```mach
pub val RECEIVE_DUPLICATE: u8 = 2
```

## val RECEIVE_DROPPED

```mach
pub val RECEIVE_DROPPED: u8 = 3
```

## val RECEIVE_DISCARDED

```mach
pub val RECEIVE_DISCARDED: u8 = 4
```

## val RECEIVE_ERROR

```mach
pub val RECEIVE_ERROR: u8 = 5
```

## val ERROR_NONE

```mach
pub val ERROR_NONE: u8 = 0
```

## val ERROR_SPACE

```mach
pub val ERROR_SPACE: u8 = 1
```

## val ERROR_NUMBER

```mach
pub val ERROR_NUMBER: u8 = 2
```

## val ERROR_STORAGE

```mach
pub val ERROR_STORAGE: u8 = 3
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT: u8 = 4
```

## val ERROR_ECN

```mach
pub val ERROR_ECN: u8 = 5
```

## val ECN_NOT_ECT

```mach
pub val ECN_NOT_ECT: u8 = 0
```

## val ECN_ECT0

```mach
pub val ECN_ECT0: u8 = 1
```

## val ECN_ECT1

```mach
pub val ECN_ECT1: u8 = 2
```

## val ECN_CE

```mach
pub val ECN_CE: u8 = 3
```

## rec Range

```mach
pub rec Range;
```

## rec SpaceStorage

```mach
pub rec SpaceStorage;
```

## rec Space

```mach
pub rec Space;
```

## rec Tracker

```mach
pub rec Tracker;
```

## rec ReceiveResult

```mach
pub rec ReceiveResult;
```

## rec BuildResult

```mach
pub rec BuildResult;
```

## fun init

```mach
pub fun init(initial: SpaceStorage, handshake: SpaceStorage, application: SpaceStorage, max_ack_delay_ns: u64, ack_delay_exponent: u8) Tracker;
```

## fun on_packet

```mach
pub fun on_packet(tracker: *Tracker, pn_space: u8, number: u64, received_at_ns: u64, ack_eliciting: bool, ecn: u8) ReceiveResult;
```

## fun ack_due

```mach
pub fun ack_due(tracker: *Tracker, pn_space: u8, now_ns: u64) bool;
```

## fun build

```mach
pub fun build(tracker: *Tracker, pn_space: u8, now_ns: u64, ranges: *frame.AckRange, capacity: usize, out: *frame.Frame) BuildResult;
```

## fun on_ack_sent

```mach
pub fun on_ack_sent(tracker: *Tracker, pn_space: u8, generation: u64) bool;
```

## fun on_ack_packet_acked

```mach
pub fun on_ack_packet_acked(tracker: *Tracker, pn_space: u8, largest_acknowledged: u64) bool;
```

## fun discard_space

```mach
pub fun discard_space(tracker: *Tracker, pn_space: u8) bool;
```

