# quic.storage.index

## rec Entry

```mach
pub rec Entry;
```

## rec Index

```mach
pub rec Index;
```

## fun empty

```mach
pub fun empty() Index;
```

## fun sound

```mach
pub fun sound(index: *Index) bool;
```

the capacity is a power of two above twice the count, so every probe ends

## fun reserve

```mach
pub fun reserve(index: *Index, backing: *allocator.Allocator, count: usize) bool;
```

makes room for `count` entries in total. a refusal leaves the index as it was

## fun find

```mach
pub fun find[T, K](index: *Index, table: *slots.Slots[T], hash: u64, key: *K,
equal: fun(*T, *K) bool) usize;
```

## fun insert

```mach
pub fun insert(index: *Index, hash: u64, slot: usize);
```

requires a reserve for count + 1 since the last growth

## fun remove

```mach
pub fun remove(index: *Index, hash: u64, slot: usize) bool;
```

## fun bytes

```mach
pub fun bytes(index: *Index) usize;
```

## fun range

```mach
pub fun range(index: *Index) ownership.Range;
```

## fun destroy

```mach
pub fun destroy(index: *Index, backing: *allocator.Allocator) bool;
```

releases the index. a refusal keeps it, so the caller can try again

