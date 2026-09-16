# quic.storage.heap

## rec Node

```mach
pub rec Node;
```

## rec Heap

```mach
pub rec Heap;
```

## fun empty

```mach
pub fun empty() Heap;
```

## fun sound

```mach
pub fun sound(heap: *Heap) bool;
```

## fun reserve

```mach
pub fun reserve(heap: *Heap, backing: *allocator.Allocator, count: usize) bool;
```

makes room for `count` nodes in total. a refusal leaves the heap as it was

## fun push

```mach
pub fun push[T](heap: *Heap, table: *slots.Slots[T], key: u64, slot: usize,
position: fun(*T) *usize);
```

requires a reserve for count + 1 since the last growth

## fun remove

```mach
pub fun remove[T](heap: *Heap, table: *slots.Slots[T], at: usize,
position: fun(*T) *usize);
```

## fun bytes

```mach
pub fun bytes(heap: *Heap) usize;
```

## fun range

```mach
pub fun range(heap: *Heap) ownership.Range;
```

## fun destroy

```mach
pub fun destroy(heap: *Heap, backing: *allocator.Allocator) bool;
```

releases the heap. a refusal keeps it, so the caller can try again

