# quic.storage.limited

## rec Limited

```mach
pub rec Limited;
```

## fun make

```mach
pub fun make(state: *Limited, budget: usize) bool;
```

the instance must not move after this, and must outlive what it hands out

## fun allocator_of

```mach
pub fun allocator_of(state: *Limited) *allocator.Allocator;
```

## fun clean

```mach
pub fun clean(state: *Limited) bool;
```

true when every byte handed out came back and nothing was freed twice

## fun dnit

```mach
pub fun dnit(state: *Limited);
```

