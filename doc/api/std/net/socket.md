# std.net.socket

## rec Flags

```mach
pub rec Flags;
```

creation state is established before a handle reaches application code

## fun blocking_flags

```mach
pub fun blocking_flags() Flags;
```

## fun async_flags

```mach
pub fun async_flags() Flags;
```

## def BoolOption

```mach
pub def BoolOption: u8
```

## val REUSE_ADDRESS

```mach
pub val REUSE_ADDRESS:    BoolOption = 0
```

## val REUSE_PORT

```mach
pub val REUSE_PORT:       BoolOption = 1
```

## val EXCLUSIVE_ADDRESS

```mach
pub val EXCLUSIVE_ADDRESS:BoolOption = 2
```

## val NO_DELAY

```mach
pub val NO_DELAY:         BoolOption = 3
```

## val KEEP_ALIVE

```mach
pub val KEEP_ALIVE:       BoolOption = 4
```

## val IPV6_ONLY

```mach
pub val IPV6_ONLY:        BoolOption = 5
```

## val FAST_OPEN

```mach
pub val FAST_OPEN:        BoolOption = 6
```

## def ValueOption

```mach
pub def ValueOption: u8
```

## val KEEP_IDLE_SECONDS

```mach
pub val KEEP_IDLE_SECONDS:    ValueOption = 0
```

## val KEEP_INTERVAL_SECONDS

```mach
pub val KEEP_INTERVAL_SECONDS:ValueOption = 1
```

## val KEEP_PROBE_COUNT

```mach
pub val KEEP_PROBE_COUNT:     ValueOption = 2
```

## val SEND_BUFFER_BYTES

```mach
pub val SEND_BUFFER_BYTES:    ValueOption = 3
```

## val RECEIVE_BUFFER_BYTES

```mach
pub val RECEIVE_BUFFER_BYTES: ValueOption = 4
```

## val TRAFFIC_CLASS_IPV4

```mach
pub val TRAFFIC_CLASS_IPV4:   ValueOption = 5
```

## val TRAFFIC_CLASS_IPV6

```mach
pub val TRAFFIC_CLASS_IPV6:   ValueOption = 6
```

## rec Linger

```mach
pub rec Linger;
```

## fun create

```mach
pub fun create(family: i32, typ: i32, protocol: i32, flags: Flags) Result[io_handle.SocketHandle, io_error.Error];
```

## fun accept

```mach
pub fun accept(handle: io_handle.SocketHandle, flags: Flags, peer: *ip.Endpoint) Result[io_handle.SocketHandle, io_error.Error];
```

## fun bool_option_supported

```mach
pub fun bool_option_supported(option: BoolOption) bool;
```

## fun value_option_supported

```mach
pub fun value_option_supported(option: ValueOption) bool;
```

## fun set_bool

```mach
pub fun set_bool(handle: io_handle.SocketHandle, option: BoolOption, enabled: bool) Result[bool, io_error.Error];
```

## fun get_bool

```mach
pub fun get_bool(handle: io_handle.SocketHandle, option: BoolOption) Result[bool, io_error.Error];
```

## fun set_value

```mach
pub fun set_value(handle: io_handle.SocketHandle, option: ValueOption, value: u32) Result[bool, io_error.Error];
```

setters copy values immediately and retain no caller storage
units are seconds, probe count, requested bytes, or an 8-bit traffic class

## fun get_value

```mach
pub fun get_value(handle: io_handle.SocketHandle, option: ValueOption) Result[u32, io_error.Error];
```

## fun set_linger

```mach
pub fun set_linger(handle: io_handle.SocketHandle, value: Linger) Result[bool, io_error.Error];
```

## fun get_linger

```mach
pub fun get_linger(handle: io_handle.SocketHandle) Result[Linger, io_error.Error];
```

## fun local_endpoint

```mach
pub fun local_endpoint(handle: io_handle.SocketHandle) Result[ip.Endpoint, io_error.Error];
```

## fun remote_endpoint

```mach
pub fun remote_endpoint(handle: io_handle.SocketHandle) Result[ip.Endpoint, io_error.Error];
```

## fun inheritable

```mach
pub fun inheritable(handle: io_handle.SocketHandle) Result[bool, io_error.Error];
```

