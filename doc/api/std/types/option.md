# std.types.option

## rec Option

```mach
pub rec Option[T];
```

represents an optional value that may or may not be present

has_value: true if a value is present
value: the contained value (undefined when has_value is false)

## fun some

```mach
pub fun some[T](value: T) Option[T];
```

create an Option[T] containing a value

value: the value to contain
ret: an Option[T] with the value present

## fun none

```mach
pub fun none[T]() Option[T];
```

create an Option[T] with no value

ret: an Option[T] with no value present

## fun is_some

```mach
pub fun is_some[T](opt: Option[T]) bool;
```

check if the Option[T] contains a value

## fun is_none

```mach
pub fun is_none[T](opt: Option[T]) bool;
```

check if the Option[T] is empty

## fun unwrap

```mach
pub fun unwrap[T](opt: Option[T]) T;
```

return the contained value

aborts the process if no value is present.

ret: the contained value

## fun unwrap_or

```mach
pub fun unwrap_or[T](opt: Option[T], default: T) T;
```

return the contained value, or a default if empty

default: value to return if the option is empty
ret: the contained value, or default

