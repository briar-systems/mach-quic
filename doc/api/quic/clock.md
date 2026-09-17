# quic.clock

## fun nanos

```mach
pub fun nanos(at: time.Instant) u64;
```

nanoseconds since the clock's origin. a reading before it counts as 0, and one
past the u64 range saturates

## fun instant

```mach
pub fun instant(value: u64) time.Instant;
```

the instant `value` nanoseconds after the clock's origin

## fun span

```mach
pub fun span(value: duration.Duration) u64;
```

a span in nanoseconds, with a negative span counting as none

## fun duration_of

```mach
pub fun duration_of(value: u64) duration.Duration;
```

`value` nanoseconds as a span, saturating at the largest one

## fun same

```mach
pub fun same(left: time.Instant, right: time.Instant) bool;
```

