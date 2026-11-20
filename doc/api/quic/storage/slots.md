[quic](../README.md) / [storage](README.md) / **slots**

# quic.storage.slots

growable index-addressed records with a free list

records move when the directory grows, so only indices may be held across a
call that can grow it

Source: [`src/storage/slots.mach`](../../../../src/storage/slots.mach)

Uses types from [`quic.connection.ownership`](../connection/ownership.md).

| Type | | |
| :--- | :--- | :--- |
| [`Cell`](#cell) | `rec` |  |
| [`Slots`](#slots) | `rec` |  |

| On `Slots` | |
| :--- | :--- |
| [`empty`](#empty) | |
| [`sound`](#sound) | the counters agree with each other, so no walk can run past the directory |
| [`reserve`](#reserve) | makes the next `additional` claims succeed without allocating |
| [`claim`](#claim) | takes the lowest recently freed index, or NONE when reserve was skipped |
| [`release`](#release) | the caller's own state proves the index is claimed |
| [`at`](#at), [`bytes`](#bytes), [`range`](#range) | |
| [`destroy`](#destroy) | releases the directory |

| Constants | |
| :--- | :--- |
| [`NONE`](#constants) | an index no directory can reach, whatever its capacity |

---

## Cell

```mach
pub rec Cell[T] {
    value:     T;
    next_free: usize;
}
```

## Slots

```mach
pub rec Slots[T] {
    items:     *Cell[T];
    capacity:  usize;
    live:      usize;
    free_head: usize;
}
```

### empty

```mach
pub fun empty[T]() Slots[T]
```

### sound

```mach
pub fun sound[T](slots: *Slots[T]) bool
```

the counters agree with each other, so no walk can run past the directory

### reserve

```mach
pub fun reserve[T](slots: *Slots[T], backing: *std.allocator.Allocator,
    additional: usize) bool
```

makes the next `additional` claims succeed without allocating. a refusal
leaves every record and index where it was

### claim

```mach
pub fun claim[T](slots: *Slots[T]) usize
```

takes the lowest recently freed index, or NONE when reserve was skipped

### release

```mach
pub fun release[T](slots: *Slots[T], index: usize)
```

the caller's own state proves the index is claimed

### at

```mach
pub fun at[T](slots: *Slots[T], index: usize) *T
```

### bytes

```mach
pub fun bytes[T](slots: *Slots[T]) usize
```

### range

```mach
pub fun range[T](slots: *Slots[T]) quic.connection.ownership.Range
```

### destroy

```mach
pub fun destroy[T](slots: *Slots[T], backing: *std.allocator.Allocator) bool
```

releases the directory. a refusal keeps it, so the caller can try again

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `NONE` | `usize` | `0xffffffffffffffff` | an index no directory can reach, whatever its capacity |

