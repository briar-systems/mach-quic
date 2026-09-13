# crypto.secret

## def State

```mach
pub def State: u8
```

## val EMPTY

```mach
pub val EMPTY:  State = 0
```

## val ACTIVE

```mach
pub val ACTIVE: State = 1
```

## val WIPED

```mach
pub val WIPED:  State = 2
```

## def FillFun

```mach
pub def FillFun: fun(ptr, *^u8, *^u8, usize) i64
```

## def AllocateFun

```mach
pub def AllocateFun: fun(ptr, *^u8, usize, **^u8) i64
```

## def DeallocateFun

```mach
pub def DeallocateFun: fun(ptr, *^u8, *^u8, usize) i64
```

## rec Allocator

```mach
pub rec Allocator;
```

allocator callbacks preserve secret-welded pointer types at the ownership
boundary so no public alias to secret storage is ever created. allocate_fn
always initializes out. a nonnil out transfers a len-byte allocation even
when the callback reports failure, allowing the caller to wipe and release
partial allocations deterministically. deallocate_fn retains ownership on
failure and releases it only on success.

## rec Entropy

```mach
pub rec Entropy;
```

an entropy callback fills all requested bytes or returns a nonzero error

## rec Secret

```mach
pub rec Secret;
```

owning values are move-only by contract

copying this record directly duplicates ownership and is invalid. use move to
transfer ownership or clone to allocate an independent copy. the allocator
and every borrowed view must outlive the owning value.

## fun empty

```mach
pub fun empty() Secret;
```

construct an empty owner before passing it to an initializer

## fun system_entropy

```mach
pub fun system_entropy() Entropy;
```

construct the operating-system entropy source

## fun system_allocator

```mach
pub fun system_allocator() Allocator;
```

construct the native secret allocator

## fun active

```mach
pub fun active(secret: *Secret) bool;
```

report whether a value owns usable secret bytes

## fun cleanup_pending

```mach
pub fun cleanup_pending(secret: *Secret) bool;
```

report whether a failed deallocation retains wiped storage

## fun init

```mach
pub fun init(secret: *Secret, owner: *Allocator, len: usize) contracts.Error;
```

allocate an explicitly zero-initialized secret

## fun init_random

```mach
pub fun init_random(secret: *Secret, owner: *Allocator, len: usize, entropy: *Entropy) contracts.Error;
```

allocate a secret and initialize it directly from an entropy source

an entropy failure wipes and releases any partially filled allocation. if the
allocator cannot release it, the owner remains in WIPED state for destroy to
retry while ENTROPY_UNAVAILABLE remains the primary result.

## fun bytes

```mach
pub fun bytes(secret: *Secret, offset: usize, len: usize, out: *contracts.SecretBytes) contracts.Error;
```

return a bounded immutable view

the view is borrowed and must not outlive the owner or a move or destroy call.

## fun buffer

```mach
pub fun buffer(secret: *Secret, offset: usize, len: usize, out: *contracts.SecretBuffer) contracts.Error;
```

return a bounded mutable view

the view is borrowed and must not outlive the owner or a move or destroy call.

## fun move

```mach
pub fun move(destination: *Secret, source: *Secret) contracts.Error;
```

transfer ownership and invalidate the source

## fun clone

```mach
pub fun clone(destination: *Secret, source: *Secret, owner: *Allocator) contracts.Error;
```

allocate an independent copy

## fun destroy

```mach
pub fun destroy(secret: *Secret) contracts.Error;
```

destroy an owner, wiping once before its first deallocation attempt

a failed deallocation keeps wiped ownership so a later call can retry without
repeating the wipe. destroying an empty value is an idempotent success.

