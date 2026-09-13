# std.system.os.secret

## fun allocate

```mach
pub fun allocate(size: usize) *^u8;
```

allocate one zero-initialized secret-welded byte region

size: number of addressable bytes
ret: logical span owner, or nil for zero size or failure

## fun deallocate

```mach
pub fun deallocate(data: *^u8, size: usize) i64;
```

release one secret-welded byte region

data: allocation returned by allocate
size: original nonzero allocation size
ret: zero after wipe and release, or a negative error with zeroed ownership retained

## fun random_fill

```mach
pub fun random_fill(data: *^u8, len: usize) i64;
```

initialize every requested byte from the operating-system csprng

data: destination secret storage
len: number of bytes to initialize
ret: zero after complete initialization, or a negative error after a complete wipe

