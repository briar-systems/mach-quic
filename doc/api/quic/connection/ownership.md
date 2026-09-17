# quic.connection.ownership

## def ZeroPolicy

```mach
pub def ZeroPolicy: u8
```

## val ZERO_FORBIDDEN

```mach
pub val ZERO_FORBIDDEN: ZeroPolicy = 1
```

## val ZERO_ALLOWED

```mach
pub val ZERO_ALLOWED:   ZeroPolicy = 2
```

## rec Range

```mach
pub rec Range;
```

## fun address

```mach
pub fun address(start: usize, length: usize,
zero_policy: ZeroPolicy) Range;
```

## fun bytes

```mach
pub fun bytes(data: *u8, length: usize, zero_policy: ZeroPolicy) Range;
```

## fun record

```mach
pub fun record[T](data: *T) Range;
```

public records become numeric extents without a byte alias

## fun anchored_record

```mach
pub fun anchored_record[T, U](anchor: *U, offset: usize) Range;
```

pass ?value.field with $offset_of(T, field) for a public field of mixed T

## fun array

```mach
pub fun array(data: *u8, count: usize, item_size: usize,
zero_policy: ZeroPolicy) Range;
```

## fun disjoint

```mach
pub fun disjoint(left: Range, right: Range) bool;
```

## fun contains

```mach
pub fun contains(outer: Range, inner: Range) bool;
```

## fun secret_disjoint

```mach
pub fun secret_disjoint(left: *^u8, left_length: usize,
right: *^u8, right_length: usize) bool;
```

## def Overlap

```mach
pub def Overlap: u8
```

## val OVERLAP_NONE

```mach
pub val OVERLAP_NONE:          Overlap = 0
```

## val OVERLAP_LIST_INVALID

```mach
pub val OVERLAP_LIST_INVALID:  Overlap = 1
```

## val OVERLAP_RANGE_INVALID

```mach
pub val OVERLAP_RANGE_INVALID: Overlap = 2
```

## val OVERLAP_PAIR

```mach
pub val OVERLAP_PAIR:          Overlap = 3
```

## rec Disjointness

```mach
pub rec Disjointness;
```

which range failed, and which one it collided with, so a caller is not left
bisecting a list it did not build

## fun disjointness

```mach
pub fun disjointness(ranges: *Range, count: usize) Disjointness;
```

## fun all_disjoint

```mach
pub fun all_disjoint(ranges: *Range, count: usize) bool;
```

## fun disjoint_from

```mach
pub fun disjoint_from(subject: Range, index: usize, ranges: *Range,
start: usize, count: usize) Disjointness;
```

checks one range that is not a member of `ranges` against ranges[start..count).
`index` is the subject's own position in whatever list the caller built, so a
refusal names both sides rather than only the one that was walked

