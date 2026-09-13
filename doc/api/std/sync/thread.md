# std.sync.thread

## val ERROR_INVALID

```mach
pub val ERROR_INVALID:     i64 = -22
```

## val ERROR_NO_MEMORY

```mach
pub val ERROR_NO_MEMORY:   i64 = -12
```

## val ERROR_UNSUPPORTED

```mach
pub val ERROR_UNSUPPORTED: i64 = -95
```

## val DEFAULT_STACK_RESERVE

```mach
pub val DEFAULT_STACK_RESERVE: usize = 2097152
```

## val MIN_STACK_RESERVE

```mach
pub val MIN_STACK_RESERVE:     usize = 65536
```

## val MAX_NAME_BYTES

```mach
pub val MAX_NAME_BYTES:        usize = 15
```

## rec Config

```mach
pub rec Config;
```

portable thread creation policy

stack_reserve: virtual address space reserved for the stack, or 0 for default
stack_commit: initial committed stack bytes, or 0 for the target default
name: nil or a portable ASCII diagnostic name of at most 15 bytes

## fun config_default

```mach
pub fun config_default(c: *Config);
```

initialize a thread configuration with portable defaults

## rec Thread

```mach
pub rec Thread;
```

handle to a spawned thread

tid: stable native diagnostic identifier, or a negative spawn error
stack: opaque resource-owner address, retained for source compatibility
done: 0 while joinable, 1 after join, -1 after detach

## fun spawn_with_config

```mach
pub fun spawn_with_config(f: fun(*u8), arg: *u8, c: *Config, t: *Thread) i64;
```

spawn with borrowed caller context and explicit configuration

arg must remain valid until the entry returns. ownership stays with the caller.

## fun spawn_owned_with_config

```mach
pub fun spawn_owned_with_config(f: fun(*u8), arg: *u8, destroy: fun(*u8), c: *Config, t: *Thread) i64;
```

spawn with owned caller context and explicit configuration

destroy runs exactly once after the entry returns, including an early return.
if spawning fails, destroy runs before this call returns.

## fun spawn_with

```mach
pub fun spawn_with(f: fun(*u8), arg: *u8, t: *Thread);
```

spawn with borrowed caller context and default configuration

## fun spawn_config

```mach
pub fun spawn_config(f: fun(), c: *Config, t: *Thread) i64;
```

spawn a zero-argument function with explicit configuration

## fun spawn_owned

```mach
pub fun spawn_owned(f: fun(*u8), arg: *u8, destroy: fun(*u8), t: *Thread) i64;
```

spawn with owned caller context and default configuration

## fun spawn

```mach
pub fun spawn(f: fun(), t: *Thread);
```

spawn a zero-argument function with default configuration

## fun join_result

```mach
pub fun join_result(t: *Thread) i64;
```

join and release every library-owned resource

## fun join

```mach
pub fun join(t: *Thread);
```

compatibility wrapper for callers that do not consume join errors

## fun detach

```mach
pub fun detach(t: *Thread) i64;
```

transfer ownership to the running or completed thread

## fun is_done

```mach
pub fun is_done(t: *Thread) bool;
```

check whether a joinable thread body has finished

## fun diagnostic_id

```mach
pub fun diagnostic_id(t: *Thread) i64;
```

return the stable native diagnostic identifier captured at spawn

