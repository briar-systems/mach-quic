[quic](../README.md) / [storage](README.md) / **index**

# quic.storage.index

open-addressed hash index from a keyed hash to a slot index

entries hold indices, never addresses, so growth rebuilds the index in a
fresh allocation. load stays at or below one half and deletion shifts the
cluster back, so a probe always ends at an empty entry and no tombstones
accumulate

Source: [`src/storage/index.mach`](../../../../src/storage/index.mach)

Uses types from [`quic.connection.ownership`](../connection/ownership.md), [`quic.storage.slots`](slots.md).

| Type | | |
| :--- | :--- | :--- |
| [`Entry`](#entry) | `rec` |  |
| [`Index`](#index) | `rec` |  |

| On `Index` | |
| :--- | :--- |
| [`empty`](#empty) | |
| [`sound`](#sound) | the capacity is a power of two above twice the count, so every probe ends |
| [`reserve`](#reserve) | makes room for `count` entries in total |
| [`find`](#find) | |
| [`insert`](#insert) | requires a reserve for count + 1 since the last growth |
| [`remove`](#remove), [`bytes`](#bytes), [`range`](#range) | |
| [`destroy`](#destroy) | releases the index |

---

## Entry

```mach
pub rec Entry {
    hash: u64;
    slot: usize;
}
```

## Index

```mach
pub rec Index {
    entries:  *Entry;
    capacity: usize;
    count:    usize;
}
```

### empty

```mach
pub fun empty() Index
```

### sound

```mach
pub fun sound(index: *Index) bool
```

the capacity is a power of two above twice the count, so every probe ends

### reserve

```mach
pub fun reserve(index: *Index, backing: *std.allocator.Allocator, count: usize) bool
```

makes room for `count` entries in total. a refusal leaves the index as it was

### find

```mach
pub fun find[T, K](index: *Index, table: *quic.storage.slots.Slots[T], hash: u64, key: *K,
    equal: fun(*T, *K) bool) usize
```

### insert

```mach
pub fun insert(index: *Index, hash: u64, slot: usize)
```

requires a reserve for count + 1 since the last growth

### remove

```mach
pub fun remove(index: *Index, hash: u64, slot: usize) bool
```

### bytes

```mach
pub fun bytes(index: *Index) usize
```

### range

```mach
pub fun range(index: *Index) quic.connection.ownership.Range
```

### destroy

```mach
pub fun destroy(index: *Index, backing: *std.allocator.Allocator) bool
```

releases the index. a refusal keeps it, so the caller can try again

