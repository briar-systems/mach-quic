[quic](../README.md) / [storage](README.md) / **ranges**

# quic.storage.ranges

a bounded set of byte offsets kept as sorted, disjoint, non-adjacent
half-open intervals

a few intervals live inline. more spill into one pool chunk, taken from the
owning account's budget and given back once the set shrinks. every operation
that could grow the set checks its cap and its storage first and changes
nothing when either refuses, so a caller can refuse the input that asked

complexity, with n intervals and n at most the cap:
  locate:           O(log n)
  insert, remove:   O(log n) search plus an O(n) shift
  contains, gap:    O(log n)
  drop_prefix:      O(k) for k intervals removed, plus the shift
  covered_from:     O(1)

Source: [`src/storage/ranges.mach`](../../../../src/storage/ranges.mach)

Uses types from [`quic.storage.source`](source.md).

| Type | | |
| :--- | :--- | :--- |
| [`Interval`](#interval) | `rec` |  |
| [`Status`](#status) | `def` |  |
| [`Source`](#source) | `def` | where a set's spill chunk comes from and whose budget it counts against |
| [`RangeSet`](#rangeset) | `rec` |  |

| On `Status` | |
| :--- | :--- |
| [`STATUS_OK`](#status), [`STATUS_FULL`](#status), [`STATUS_BLOCKED`](#status), [`STATUS_ERROR`](#status) | |

| On `RangeSet` | |
| :--- | :--- |
| [`make`](#make) | an empty set holding at most `cap` intervals |
| [`count`](#count), [`empty`](#empty), [`spilled`](#spilled) | |
| [`index_after`](#index_after) | the position of the first interval that ends beyond `offset` |
| [`at`](#at) | |
| [`count_after_insert`](#count_after_insert) | the number of intervals the set would hold after inserting [start, end) |
| [`insert`](#insert) | adds [start, end) |
| [`remove`](#remove) | removes [start, end) |
| [`drop_prefix`](#drop_prefix) | removes every offset below `offset` |
| [`contains`](#contains) | |
| [`gap_start`](#gap_start) | the first offset in [from, limit) the set does not hold, or `limit` |
| [`gap_end`](#gap_end) | where the gap that starts at `from` ends: the next held offset, or `limit` |
| [`covered_from`](#covered_from) | how far the set holds every offset from `from` on, or `from` itself |
| [`clear`](#clear) | forgets every interval and gives the spill chunk back |

| Constants | |
| :--- | :--- |
| [`INLINE`](#constants), [`SPILL_CAPACITY`](#constants) | |

---

## Interval

```mach
pub rec Interval {
    start: u64;
    end:   u64;
}
```

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_OK` | `1` |  |
| `STATUS_FULL` | `2` |  |
| `STATUS_BLOCKED` | `3` |  |
| `STATUS_ERROR` | `4` |  |

## Source

```mach
pub def Source: quic.storage.source.Source
```

where a set's spill chunk comes from and whose budget it counts against

## RangeSet

```mach
pub rec RangeSet {
    inline: [INLINE]Interval;
    spill:  quic.storage.source.Chunk;
    count:  usize;
    cap:    usize;
}
```

### make

```mach
pub fun make(cap: usize) RangeSet
```

an empty set holding at most `cap` intervals. a cap above what one spill
chunk holds is lowered to it

### count

```mach
pub fun count(set: *RangeSet) usize
```

### empty

```mach
pub fun empty(set: *RangeSet) bool
```

### spilled

```mach
pub fun spilled(set: *RangeSet) bool
```

### index_after

```mach
pub fun index_after(set: *RangeSet, offset: u64) usize
```

the position of the first interval that ends beyond `offset`

### at

```mach
pub fun at(set: *RangeSet, index: usize) Interval
```

### count_after_insert

```mach
pub fun count_after_insert(set: *RangeSet, start: u64, end: u64) usize
```

the number of intervals the set would hold after inserting [start, end)

### insert

```mach
pub fun insert(set: *RangeSet, start: u64, end: u64, source: *Source) Status
```

adds [start, end). a refusal changes nothing

### remove

```mach
pub fun remove(set: *RangeSet, start: u64, end: u64, source: *Source) Status
```

removes [start, end). splitting an interval can grow the set, so this can
refuse too, and a refusal changes nothing

### drop_prefix

```mach
pub fun drop_prefix(set: *RangeSet, offset: u64, source: *Source)
```

removes every offset below `offset`

### contains

```mach
pub fun contains(set: *RangeSet, start: u64, end: u64) bool
```

### gap_start

```mach
pub fun gap_start(set: *RangeSet, from: u64, limit: u64) u64
```

the first offset in [from, limit) the set does not hold, or `limit`

### gap_end

```mach
pub fun gap_end(set: *RangeSet, from: u64, limit: u64) u64
```

where the gap that starts at `from` ends: the next held offset, or `limit`

### covered_from

```mach
pub fun covered_from(set: *RangeSet, from: u64) u64
```

how far the set holds every offset from `from` on, or `from` itself

### clear

```mach
pub fun clear(set: *RangeSet, source: *Source)
```

forgets every interval and gives the spill chunk back

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `INLINE` | `usize` | `4` |  |
| `SPILL_CAPACITY` | `usize` | `supply.BYTES / 16` |  |

