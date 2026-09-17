# quic.storage.ranges

## val INLINE

```mach
pub val INLINE: usize = 4
```

## rec Interval

```mach
pub rec Interval;
```

## val SPILL_CAPACITY

```mach
pub val SPILL_CAPACITY: usize = supply.BYTES / 16
```

## def Status

```mach
pub def Status: u8
```

## val STATUS_OK

```mach
pub val STATUS_OK:      Status = 1
```

## val STATUS_FULL

```mach
pub val STATUS_FULL:    Status = 2
```

## val STATUS_BLOCKED

```mach
pub val STATUS_BLOCKED: Status = 3
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR:   Status = 4
```

## def Source

```mach
pub def Source: supply.Source
```

where a set's spill chunk comes from and whose budget it counts against

## rec RangeSet

```mach
pub rec RangeSet;
```

## fun make

```mach
pub fun make(cap: usize) RangeSet;
```

an empty set holding at most `cap` intervals. a cap above what one spill
chunk holds is lowered to it

## fun count

```mach
pub fun count(set: *RangeSet) usize;
```

## fun empty

```mach
pub fun empty(set: *RangeSet) bool;
```

## fun spilled

```mach
pub fun spilled(set: *RangeSet) bool;
```

## fun index_after

```mach
pub fun index_after(set: *RangeSet, offset: u64) usize;
```

the position of the first interval that ends beyond `offset`

## fun at

```mach
pub fun at(set: *RangeSet, index: usize) Interval;
```

## fun count_after_insert

```mach
pub fun count_after_insert(set: *RangeSet, start: u64, end: u64) usize;
```

the number of intervals the set would hold after inserting [start, end)

## fun insert

```mach
pub fun insert(set: *RangeSet, start: u64, end: u64, source: *Source) Status;
```

adds [start, end). a refusal changes nothing

## fun remove

```mach
pub fun remove(set: *RangeSet, start: u64, end: u64, source: *Source) Status;
```

removes [start, end). splitting an interval can grow the set, so this can
refuse too, and a refusal changes nothing

## fun drop_prefix

```mach
pub fun drop_prefix(set: *RangeSet, offset: u64, source: *Source);
```

removes every offset below `offset`

## fun contains

```mach
pub fun contains(set: *RangeSet, start: u64, end: u64) bool;
```

## fun gap_start

```mach
pub fun gap_start(set: *RangeSet, from: u64, limit: u64) u64;
```

the first offset in [from, limit) the set does not hold, or `limit`

## fun gap_end

```mach
pub fun gap_end(set: *RangeSet, from: u64, limit: u64) u64;
```

where the gap that starts at `from` ends: the next held offset, or `limit`

## fun covered_from

```mach
pub fun covered_from(set: *RangeSet, from: u64) u64;
```

how far the set holds every offset from `from` on, or `from` itself

## fun clear

```mach
pub fun clear(set: *RangeSet, source: *Source);
```

forgets every interval and gives the spill chunk back

