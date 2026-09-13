# std.types.result

## rec Result

```mach
pub rec Result[T, E];
```

represents either success (ok) containing T, or error (err) containing E

tag: true for ok, false for err
value: the contained ok or err value

## fun ok

```mach
pub fun ok[T, E](value: T) Result[T, E];
```

create a Result[T, E] representing success

value: the success value
ret: a Result[T, E] with the ok value present

## fun err

```mach
pub fun err[T, E](value: E) Result[T, E];
```

create a Result[T, E] representing an error

value: the error value
ret: a Result[T, E] with the err value present

## fun is_ok

```mach
pub fun is_ok[T, E](res: Result[T, E]) bool;
```

check if the result is ok (success)

## fun is_err

```mach
pub fun is_err[T, E](res: Result[T, E]) bool;
```

check if the result is err (error)

## fun unwrap_ok

```mach
pub fun unwrap_ok[T, E](res: Result[T, E]) T;
```

return the contained ok value

aborts the process if the result is err.

ret: the contained ok value

## fun unwrap_err

```mach
pub fun unwrap_err[T, E](res: Result[T, E]) E;
```

return the contained err value

aborts the process if the result is ok.

ret: the contained err value

