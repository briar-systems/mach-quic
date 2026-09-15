# quic.storage.slots

## val NONE

```mach
pub val NONE: usize = 0xffffffffffffffff
```

an index no directory can reach, whatever its capacity

## rec Cell

```mach
pub rec Cell[T];
```

## rec Slots

```mach
pub rec Slots[T];
```

## fun empty

```mach
pub fun empty[T]() Slots[T];
```

## fun sound

```mach
pub fun sound[T](slots: *Slots[T]) bool;
```

the counters agree with each other, so no walk can run past the directory

## fun reserve

```mach
pub fun reserve[T](slots: *Slots[T], backing: *allocator.Allocator,
additional: usize) bool;
```

makes the next `additional` claims succeed without allocating. a refusal
leaves every record and index where it was

## fun claim

```mach
pub fun claim[T](slots: *Slots[T]) usize;
```

takes the lowest recently freed index, or NONE when reserve was skipped

## fun release

```mach
pub fun release[T](slots: *Slots[T], index: usize);
```

the caller's own state proves the index is claimed

## fun at

```mach
pub fun at[T](slots: *Slots[T], index: usize) *T;
```

## fun bytes

```mach
pub fun bytes[T](slots: *Slots[T]) usize;
```

## fun range

```mach
pub fun range[T](slots: *Slots[T]) ownership.Range;
```

## fun destroy

```mach
pub fun destroy[T](slots: *Slots[T], backing: *allocator.Allocator) bool;
```

releases the directory. a refusal keeps it, so the caller can try again

