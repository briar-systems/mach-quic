[quic](README.md) / **clock**

# quic.clock

the boundary between std's monotonic clock and quic's internal time

callers hand quic `time.Instant` readings and `duration.Duration` spans, and
quic hands back instants. inside, time is u64 nanoseconds on the same clock,
which keeps the core's arithmetic plain and its records small

Source: [`src/clock.mach`](../../../src/clock.mach)

| Functions | |
| :--- | :--- |
| [`nanos`](#nanos) | nanoseconds since the clock's origin |
| [`instant`](#instant) | the instant `value` nanoseconds after the clock's origin |
| [`span`](#span) | a span in nanoseconds, with a negative span counting as none |
| [`duration_of`](#duration_of) | `value` nanoseconds as a span, saturating at the largest one |
| [`same`](#same) | |

---

## Functions

### nanos

```mach
pub fun nanos(at: std.chrono.time.Instant) u64
```

nanoseconds since the clock's origin. a reading before it counts as 0, and one
past the u64 range saturates

### instant

```mach
pub fun instant(value: u64) std.chrono.time.Instant
```

the instant `value` nanoseconds after the clock's origin

### span

```mach
pub fun span(value: std.chrono.duration.Duration) u64
```

a span in nanoseconds, with a negative span counting as none

### duration_of

```mach
pub fun duration_of(value: u64) std.chrono.duration.Duration
```

`value` nanoseconds as a span, saturating at the largest one

### same

```mach
pub fun same(left: std.chrono.time.Instant, right: std.chrono.time.Instant) bool
```

