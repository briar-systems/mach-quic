# std.system.os.shared

## rec Timespec

```mach
pub rec Timespec;
```

seconds and nanoseconds from a clock source

sec: whole seconds
nsec: nanoseconds within second [0, 999999999]

## rec IoQueue

```mach
pub rec IoQueue;
```

native wait queue state owned by the portable completion runtime

## val SEEK_SET

```mach
pub val SEEK_SET: i32 = 0
```

seek whence

## val SEEK_CUR

```mach
pub val SEEK_CUR: i32 = 1
```

## val SEEK_END

```mach
pub val SEEK_END: i32 = 2
```

## val PROT_NONE

```mach
pub val PROT_NONE:  u32 = 0b000
```

memory protection flags

## val PROT_READ

```mach
pub val PROT_READ:  u32 = 0b001
```

## val PROT_WRITE

```mach
pub val PROT_WRITE: u32 = 0b010
```

## val PROT_EXEC

```mach
pub val PROT_EXEC:  u32 = 0b100
```

## val ADVISE_NORMAL

```mach
pub val ADVISE_NORMAL:     u32 = 0
```

memory advisory hints

## val ADVISE_RANDOM

```mach
pub val ADVISE_RANDOM:     u32 = 1
```

## val ADVISE_SEQUENTIAL

```mach
pub val ADVISE_SEQUENTIAL: u32 = 2
```

## val ADVISE_WILL_NEED

```mach
pub val ADVISE_WILL_NEED:  u32 = 3
```

## val ADVISE_DONT_NEED

```mach
pub val ADVISE_DONT_NEED:  u32 = 4
```

## val HUGE_2MB

```mach
pub val HUGE_2MB: usize = 2097152
```

standard huge page sizes

## val HUGE_1GB

```mach
pub val HUGE_1GB: usize = 1073741824
```

## val HEAP_RESERVE

```mach
pub val HEAP_RESERVE: usize = 268435456
```

heap region reserve size (256MB)

## val NOT_FOUND

```mach
pub val NOT_FOUND: i64 = -1
```

platform-agnostic sentinels

## fun has_exited

```mach
pub fun has_exited(status: i32) bool;
```

## fun exit_code

```mach
pub fun exit_code(status: i32) i32;
```

## fun was_signaled

```mach
pub fun was_signaled(status: i32) bool;
```

## fun term_signal

```mach
pub fun term_signal(status: i32) i32;
```

## fun was_stopped

```mach
pub fun was_stopped(status: i32) bool;
```

## fun stop_signal

```mach
pub fun stop_signal(status: i32) i32;
```

## fun was_continued

```mach
pub fun was_continued(status: i32) bool;
```

