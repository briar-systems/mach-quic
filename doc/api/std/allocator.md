# std.allocator

## rec Allocator

```mach
pub rec Allocator;
```

backend-agnostic allocator interface

ctx: opaque context passed to callbacks.
fn_allocate: allocate (ctx, size, align) -> ptr (nil on OOM).
fn_reallocate: reallocate (ctx, p, old_size, new_size, align) -> ptr (nil on OOM).
fn_deallocate: deallocate (ctx, p, size, align) -> i64 (0 on success, negative errno on failure).

## fun allocate_raw

```mach
pub fun allocate_raw(a: *Allocator, size: usize, align: usize) R.Result[ptr, *u8];
```

allocate raw bytes using this allocator

a: allocator to use for this allocation.
size: number of bytes (0 returns nil).
align: requested alignment in bytes.
ret: ptr to allocated memory or error on OOM

## fun reallocate_raw

```mach
pub fun reallocate_raw(a: *Allocator, p: ptr, old_size: usize, new_size: usize, align: usize) R.Result[ptr, *u8];
```

reallocate an allocation in-place if possible, otherwise may return a new pointer

a: allocator to use for this operation
p: existing pointer (or nil to allocate new)
old_size: previous size in bytes
new_size: desired size in bytes (0 frees the allocation)
align: alignment in bytes
ret: ptr to reallocated memory (same as p if in-place) or error on OOM

## fun deallocate_raw

```mach
pub fun deallocate_raw(a: *Allocator, p: ptr, size: usize, align: usize) i64;
```

deallocate an allocation previously returned by allocate_raw or reallocate_raw

a: Allocator to use for this operation
p: pointer previously returned by allocate_raw or reallocate_raw
size: size in bytes that was allocated
align: alignment in bytes
ret: 0 on success, or negative errno

## fun allocate

```mach
pub fun allocate[T](a: *Allocator, count: usize) R.Result[*T, *u8];
```

allocate count elements of type T

a: Allocator to use for this allocation
count: number of elements to allocate
ret: pointer to allocated memory or error on OOM or overflow (nil for count == 0)

## fun zallocate

```mach
pub fun zallocate[T](a: *Allocator, count: usize) R.Result[*T, *u8];
```

allocate and zero-initialize count elements of T

a: Allocator to use for this allocation
count: number of elements to allocate
ret: pointer to allocated and zero-initialized memory or error on OOM or overflow (nil for count == 0)

## fun reallocate

```mach
pub fun reallocate[T](a: *Allocator, p: *T, old_count: usize, new_count: usize) R.Result[*T, *u8];
```

reallocate an allocation of T elements

a: Allocator to use for this operation
p: existing pointer
old_count: previous number of elements
new_count: desired number of elements (0 frees)
ret: pointer to reallocated memory (same as p if in-place) or error on OOM or overflow (nil for new_count == 0)

## fun deallocate

```mach
pub fun deallocate[T](a: *Allocator, p: *T, count: usize) R.Result[bool, *u8];
```

deallocate memory previously returned by alloc/zalloc for count
elements.

a: Allocator to use for this operation
p: pointer returned by alloc/zalloc (may be nil)
count: number of elements to deallocate
ret: ok(true) on success (including the nil-pointer / count == 0 no-op), or
       err on a non-zero deallocator status, mirroring allocate/reallocate.

