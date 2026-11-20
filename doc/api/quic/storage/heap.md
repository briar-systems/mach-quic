[quic](../README.md) / [storage](README.md) / **heap**

# quic.storage.heap

growable min-heap of slot indices ordered by a u64 key

each record stores its own heap position, reached through `position`, so a
record can leave the heap from anywhere in it

Source: [`src/storage/heap.mach`](../../../../src/storage/heap.mach)

Uses types from [`quic.connection.ownership`](../connection/ownership.md), [`quic.storage.slots`](slots.md).

| Type | | |
| :--- | :--- | :--- |
| [`Node`](#node) | `rec` |  |
| [`Heap`](#heap) | `rec` |  |

| On `Heap` | |
| :--- | :--- |
| [`empty`](#empty), [`sound`](#sound) | |
| [`reserve`](#reserve) | makes room for `count` nodes in total |
| [`push`](#push) | requires a reserve for count + 1 since the last growth |
| [`remove`](#remove), [`bytes`](#bytes), [`range`](#range) | |
| [`destroy`](#destroy) | releases the heap |

---

## Node

```mach
pub rec Node {
    key:  u64;
    slot: usize;
}
```

## Heap

```mach
pub rec Heap {
    nodes:    *Node;
    capacity: usize;
    count:    usize;
}
```

### empty

```mach
pub fun empty() Heap
```

### sound

```mach
pub fun sound(heap: *Heap) bool
```

### reserve

```mach
pub fun reserve(heap: *Heap, backing: *std.allocator.Allocator, count: usize) bool
```

makes room for `count` nodes in total. a refusal leaves the heap as it was

### push

```mach
pub fun push[T](heap: *Heap, table: *quic.storage.slots.Slots[T], key: u64, slot: usize,
    position: fun(*T) *usize)
```

requires a reserve for count + 1 since the last growth

### remove

```mach
pub fun remove[T](heap: *Heap, table: *quic.storage.slots.Slots[T], at: usize,
    position: fun(*T) *usize)
```

### bytes

```mach
pub fun bytes(heap: *Heap) usize
```

### range

```mach
pub fun range(heap: *Heap) quic.connection.ownership.Range
```

### destroy

```mach
pub fun destroy(heap: *Heap, backing: *std.allocator.Allocator) bool
```

releases the heap. a refusal keeps it, so the caller can try again

