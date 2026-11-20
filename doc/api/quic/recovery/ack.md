[quic](../README.md) / [recovery](README.md) / **ack**

# quic.recovery.ack

Source: [`src/recovery/ack.mach`](../../../../src/recovery/ack.mach)

Uses types from [`quic.frame.frame`](../frame/frame.md).

| Type | | |
| :--- | :--- | :--- |
| [`Range`](#range) | `rec` |  |
| [`SpaceStorage`](#spacestorage) | `rec` |  |
| [`Space`](#space) | `rec` |  |
| [`Tracker`](#tracker) | `rec` |  |
| [`ReceiveResult`](#receiveresult) | `rec` |  |
| [`BuildResult`](#buildresult) | `rec` |  |

| On `SpaceStorage` | |
| :--- | :--- |
| [`init`](#init) | |

| On `Tracker` | |
| :--- | :--- |
| [`classify`](#classify) | what on_packet would decide for this number, without recording it |
| [`on_packet`](#on_packet), [`ack_due`](#ack_due), [`build`](#build) | |
| [`frame_size`](#frame_size) | the bytes the frame build would write with the same arguments, or 0 where build refuses |
| [`on_ack_sent`](#on_ack_sent), [`on_ack_packet_acked`](#on_ack_packet_acked), [`discard_space`](#discard_space) | |
| [`detach_space`](#detach_space) | drops a discarded space's range storage so its holder can release it |

| Constants | |
| :--- | :--- |
| [`RECEIVE_NEW`](#constants), [`RECEIVE_DUPLICATE`](#constants), [`RECEIVE_DROPPED`](#constants), [`RECEIVE_DISCARDED`](#constants), [`RECEIVE_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_SPACE`](#constants), [`ERROR_NUMBER`](#constants), [`ERROR_STORAGE`](#constants), [`ERROR_OUTPUT`](#constants), [`ERROR_ECN`](#constants), [`ECN_NOT_ECT`](#constants), [`ECN_ECT0`](#constants), [`ECN_ECT1`](#constants), [`ECN_CE`](#constants) | |

---

## Range

```mach
pub rec Range {
    start: u64;
    end:   u64;
}
```

## SpaceStorage

```mach
pub rec SpaceStorage {
    ranges:   *Range;
    capacity: usize;
}
```

### init

```mach
pub fun init(initial: SpaceStorage, handshake: SpaceStorage, application: SpaceStorage, max_ack_delay_ns: u64, ack_delay_exponent: u8) Tracker
```

## Space

```mach
pub rec Space {
    ranges:                    *Range;
    capacity:                  usize;
    count:                     usize;
    floor:                     u64;
    largest_received:          u64;
    largest_received_at_ns:    u64;
    largest_ack_eliciting:     u64;
    ack_deadline_ns:           u64;
    ack_eliciting_since_last:  u32;
    receive_generation:        u64;
    ect0:                      u64;
    ect1:                      u64;
    ecn_ce:                    u64;
    has_largest:               bool;
    has_largest_ack_eliciting: bool;
    ack_pending:               bool;
    ack_immediate:             bool;
    ack_deadline_armed:        bool;
    floor_exhausted:           bool;
    has_ecn:                   bool;
    discarded:                 bool;
}
```

## Tracker

```mach
pub rec Tracker {
    spaces:             [3]Space;
    max_ack_delay_ns:   u64;
    ack_delay_exponent: u8;
    valid:              bool;
}
```

### classify

```mach
pub fun classify(tracker: *Tracker, pn_space: u8, number: u64) u8
```

what on_packet would decide for this number, without recording it

### on_packet

```mach
pub fun on_packet(tracker: *Tracker, pn_space: u8, number: u64, received_at_ns: u64, ack_eliciting: bool, ecn: u8) ReceiveResult
```

### ack_due

```mach
pub fun ack_due(tracker: *Tracker, pn_space: u8, now_ns: u64) bool
```

### build

```mach
pub fun build(tracker: *Tracker, pn_space: u8, now_ns: u64, ranges: *quic.frame.frame.AckRange, capacity: usize, out: *quic.frame.frame.Frame) BuildResult
```

### frame_size

```mach
pub fun frame_size(tracker: *Tracker, pn_space: u8, now_ns: u64, capacity: usize) usize
```

the bytes the frame build would write with the same arguments, or 0 where
build refuses. it writes nothing, so a send can be sized before the frame is
taken

### on_ack_sent

```mach
pub fun on_ack_sent(tracker: *Tracker, pn_space: u8, generation: u64) bool
```

### on_ack_packet_acked

```mach
pub fun on_ack_packet_acked(tracker: *Tracker, pn_space: u8, largest_acknowledged: u64) bool
```

### discard_space

```mach
pub fun discard_space(tracker: *Tracker, pn_space: u8) bool
```

### detach_space

```mach
pub fun detach_space(tracker: *Tracker, pn_space: u8) bool
```

drops a discarded space's range storage so its holder can release it. the
space is never read again

## ReceiveResult

```mach
pub rec ReceiveResult {
    status:  u8;
    error:   u8;
    ack_now: bool;
}
```

## BuildResult

```mach
pub rec BuildResult {
    ok:                   bool;
    error:                u8;
    range_count:          usize;
    generation:           u64;
    largest_acknowledged: u64;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `RECEIVE_NEW` | `u8` | `1` |  |
| `RECEIVE_DUPLICATE` | `u8` | `2` |  |
| `RECEIVE_DROPPED` | `u8` | `3` |  |
| `RECEIVE_DISCARDED` | `u8` | `4` |  |
| `RECEIVE_ERROR` | `u8` | `5` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_SPACE` | `u8` | `1` |  |
| `ERROR_NUMBER` | `u8` | `2` |  |
| `ERROR_STORAGE` | `u8` | `3` |  |
| `ERROR_OUTPUT` | `u8` | `4` |  |
| `ERROR_ECN` | `u8` | `5` |  |
| `ECN_NOT_ECT` | `u8` | `0` |  |
| `ECN_ECT0` | `u8` | `1` |  |
| `ECN_ECT1` | `u8` | `2` |  |
| `ECN_CE` | `u8` | `3` |  |

