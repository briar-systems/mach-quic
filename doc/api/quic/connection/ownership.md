[quic](../README.md) / [connection](README.md) / **ownership**

# quic.connection.ownership

checked physical ownership ranges

Source: [`src/connection/ownership.mach`](../../../../src/connection/ownership.mach)

| Type | | |
| :--- | :--- | :--- |
| [`ZeroPolicy`](#zeropolicy) | `def` |  |
| [`Range`](#range) | `rec` |  |
| [`Overlap`](#overlap) | `def` |  |
| [`Disjointness`](#disjointness-1) | `rec` | which range failed, and which one it collided with, so a caller is not left bisecting a list it did not build |

| On `ZeroPolicy` | |
| :--- | :--- |
| [`ZERO_FORBIDDEN`](#zeropolicy), [`ZERO_ALLOWED`](#zeropolicy), [`address`](#address), [`bytes`](#bytes), [`array`](#array) | |

| On `Range` | |
| :--- | :--- |
| [`record`](#record) | public records become numeric extents without a byte alias |
| [`anchored_record`](#anchored_record) | pass ?value.field with $offset_of(T, field) for a public field of mixed T |
| [`disjoint`](#disjoint), [`contains`](#contains), [`disjointness`](#disjointness), [`all_disjoint`](#all_disjoint) | |
| [`disjoint_from`](#disjoint_from) | checks one range that is not a member of `ranges` against ranges[start..count) |

| On `Overlap` | |
| :--- | :--- |
| [`OVERLAP_NONE`](#overlap), [`OVERLAP_LIST_INVALID`](#overlap), [`OVERLAP_RANGE_INVALID`](#overlap), [`OVERLAP_PAIR`](#overlap) | |

| Functions | |
| :--- | :--- |
| [`secret_disjoint`](#secret_disjoint) | |

---

## ZeroPolicy

```mach
pub def ZeroPolicy: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ZERO_FORBIDDEN` | `1` |  |
| `ZERO_ALLOWED` | `2` |  |

### address

```mach
pub fun address(start: usize, length: usize,
    zero_policy: ZeroPolicy) Range
```

### bytes

```mach
pub fun bytes(data: *u8, length: usize, zero_policy: ZeroPolicy) Range
```

### array

```mach
pub fun array(data: *u8, count: usize, item_size: usize,
    zero_policy: ZeroPolicy) Range
```

## Range

```mach
pub rec Range {
    start:  usize;
    length: usize;
    valid:  bool;
}
```

### record

```mach
pub fun record[T](data: *T) Range
```

public records become numeric extents without a byte alias

### anchored_record

```mach
pub fun anchored_record[T, U](anchor: *U, offset: usize) Range
```

pass ?value.field with $offset_of(T, field) for a public field of mixed T

### disjoint

```mach
pub fun disjoint(left: Range, right: Range) bool
```

### contains

```mach
pub fun contains(outer: Range, inner: Range) bool
```

### disjointness

```mach
pub fun disjointness(ranges: *Range, count: usize) Disjointness
```

### all_disjoint

```mach
pub fun all_disjoint(ranges: *Range, count: usize) bool
```

### disjoint_from

```mach
pub fun disjoint_from(subject: Range, index: usize, ranges: *Range,
    start: usize, count: usize) Disjointness
```

checks one range that is not a member of `ranges` against ranges[start..count).
`index` is the subject's own position in whatever list the caller built, so a
refusal names both sides rather than only the one that was walked

## Overlap

```mach
pub def Overlap: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `OVERLAP_NONE` | `0` |  |
| `OVERLAP_LIST_INVALID` | `1` |  |
| `OVERLAP_RANGE_INVALID` | `2` |  |
| `OVERLAP_PAIR` | `3` |  |

## Disjointness

```mach
pub rec Disjointness {
    kind:   Overlap;
    first:  usize;
    second: usize;
}
```

which range failed, and which one it collided with, so a caller is not left
bisecting a list it did not build

## Functions

### secret_disjoint

```mach
pub fun secret_disjoint(left: *^u8, left_length: usize,
    right: *^u8, right_length: usize) bool
```

