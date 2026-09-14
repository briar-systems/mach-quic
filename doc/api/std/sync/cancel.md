# std.sync.cancel

## def Reason

```mach
pub def Reason: i64
```

## val ACTIVE

```mach
pub val ACTIVE:    Reason = 0
```

## val CANCELLED

```mach
pub val CANCELLED: Reason = 1
```

## val TIMED_OUT

```mach
pub val TIMED_OUT: Reason = 2
```

## val DESTROYED

```mach
pub val DESTROYED: Reason = 3
```

## val INVALID

```mach
pub val INVALID:   Reason = 4
```

## def CancelFun

```mach
pub def CancelFun: fun(ptr, Reason)
```

## rec Registration

```mach
pub rec Registration;
```

## rec Scope

```mach
pub rec Scope;
```

## fun make_root

```mach
pub fun make_root(scope: *Scope, has_deadline: bool, deadline: time.Time) bool;
```

scopes are fixed in memory and own no target handle or allocation
callers stop starting new calls before reclaiming a destroyed scope

## fun make_child

```mach
pub fun make_child(scope: *Scope, parent: *Scope, has_deadline: bool, deadline: time.Time) bool;
```

## fun init_registration

```mach
pub fun init_registration(registration: *Registration) bool;
```

initialization is valid before first attachment or after terminal completion

## fun attach

```mach
pub fun attach(scope: *Scope, registration: *Registration, callback: CancelFun, context: ptr) Reason;
```

successful registration is the ownership linearization point

## fun attach_with_completion

```mach
pub fun attach_with_completion(scope: *Scope, registration: *Registration, callback: CancelFun, completion: CancelFun, context: ptr) Reason;
```

completion publishes external work and must call finish under its lifetime lock

## fun finish

```mach
pub fun finish(registration: *Registration) bool;
```

this must be the completion hook's final registration operation

## fun unregister

```mach
pub fun unregister(registration: *Registration) bool;
```

completion wins only while the registration remains owned by its scope

## fun cancel

```mach
pub fun cancel(scope: *Scope) bool;
```

## fun timeout

```mach
pub fun timeout(scope: *Scope) bool;
```

## fun expire

```mach
pub fun expire(scope: *Scope, now: time.Time) bool;
```

callers without a runtime may drive absolute deadlines explicitly

## fun get_deadline

```mach
pub fun get_deadline(scope: *Scope, deadline: *time.Time, owner: **Scope) bool;
```

returns the effective deadline and the ancestor that owns it

## fun reason

```mach
pub fun reason(scope: *Scope) Reason;
```

## fun wait

```mach
pub fun wait(scope: *Scope) Reason;
```

## fun waiter_count

```mach
pub fun waiter_count(scope: *Scope) i64;
```

## fun destroy

```mach
pub fun destroy(scope: *Scope) bool;
```

destruction rejects children, live registrations, waiters, and callbacks

