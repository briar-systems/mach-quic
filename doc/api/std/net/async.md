# std.net.async

## rec Driver

```mach
pub rec Driver;
```

the driver borrows one io runtime and never creates a second native queue

## fun aliases

```mach
pub fun aliases(driver: *Driver, data: *u8, len: usize) bool;
```

the caller excludes concurrent destruction while querying stable ownership

## fun make

```mach
pub fun make(driver: *Driver, runtime: *io_runtime.Runtime) Result[bool, io_error.Error];
```

## fun listen

```mach
pub fun listen(endpoint: ip.Endpoint, backlog: i32) Result[tcp.Listener, io_error.Error];
```

## fun bind_datagram

```mach
pub fun bind_datagram(endpoint: ip.Endpoint) Result[udp.Socket, io_error.Error];
```

## fun create_datagram

```mach
pub fun create_datagram(family: i32) Result[udp.Socket, io_error.Error];
```

## fun submit_accept

```mach
pub fun submit_accept(
driver: *Driver,
scope: *cancel.Scope,
listener: *tcp.Listener,
peer: *ip.Endpoint,
context: usize,
) Result[io_runtime.Token, io_error.Error];
```

## fun submit_connect

```mach
pub fun submit_connect(
driver: *Driver,
scope: *cancel.Scope,
endpoint: ip.Endpoint,
context: usize,
) Result[io_runtime.Token, io_error.Error];
```

## fun submit_read

```mach
pub fun submit_read(driver: *Driver, scope: *cancel.Scope, stream: *tcp.Stream, buffer: *u8, length: usize, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun submit_write

```mach
pub fun submit_write(driver: *Driver, scope: *cancel.Scope, stream: *tcp.Stream, buffer: *u8, length: usize, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun submit_write_vector

```mach
pub fun submit_write_vector(
driver: *Driver,
scope: *cancel.Scope,
stream: *tcp.Stream,
vectors: *types.Vector,
count: usize,
context: usize,
) Result[io_runtime.Token, io_error.Error];
```

## fun submit_receive_batch

```mach
pub fun submit_receive_batch(driver: *Driver, scope: *cancel.Scope, socket: *udp.Socket, packets: *types.Packet, count: usize, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun submit_send_batch

```mach
pub fun submit_send_batch(driver: *Driver, scope: *cancel.Scope, socket: *udp.Socket, packets: *types.Packet, count: usize, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun submit_shutdown_write

```mach
pub fun submit_shutdown_write(driver: *Driver, scope: *cancel.Scope, stream: *tcp.Stream, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun submit_stream_close

```mach
pub fun submit_stream_close(
driver: *Driver,
scope: *cancel.Scope,
stream: *tcp.Stream,
mode: lifecycle.Mode,
context: usize,
) Result[io_runtime.Token, io_error.Error];
```

## fun submit_datagram_close

```mach
pub fun submit_datagram_close(driver: *Driver, scope: *cancel.Scope, socket: *udp.Socket, context: usize) Result[io_runtime.Token, io_error.Error];
```

## fun wait

```mach
pub fun wait(
driver: *Driver,
output: *io_runtime.Completion,
output_capacity: usize,
timeout_ms: i32,
) Result[usize, io_error.Error];
```

one thread owns wait; submission may run concurrently

## fun destroy

```mach
pub fun destroy(driver: *Driver) Result[bool, io_error.Error];
```

