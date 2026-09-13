# std.net.async.linux

## rec Operation

```mach
pub rec Operation;
```

## rec Backend

```mach
pub rec Backend;
```

## fun aliases

```mach
pub fun aliases(backend: *Backend, data: *u8, len: usize) bool;
```

## fun make

```mach
pub fun make(backend: *Backend, queue: *shared.IoQueue, capacity: usize, source_id: u16) i64;
```

## fun submit_accept

```mach
pub fun submit_accept(backend: *Backend, listener: usize, peer: *ip.Endpoint, context: usize, token: *types.Token) i64;
```

## fun submit_connect

```mach
pub fun submit_connect(backend: *Backend, native: usize, peer: ip.Endpoint, context: usize, token: *types.Token) i64;
```

## fun submit_read

```mach
pub fun submit_read(backend: *Backend, native: usize, buffer: *u8, length: usize, context: usize, token: *types.Token) i64;
```

## fun submit_write

```mach
pub fun submit_write(backend: *Backend, native: usize, buffer: *u8, length: usize, context: usize, token: *types.Token) i64;
```

## fun submit_write_vector

```mach
pub fun submit_write_vector(backend: *Backend, native: usize, vectors: *types.Vector, count: usize, context: usize, token: *types.Token) i64;
```

## fun submit_receive_batch

```mach
pub fun submit_receive_batch(backend: *Backend, native: usize, packets: *types.Packet, count: usize, context: usize, token: *types.Token) i64;
```

## fun submit_send_batch

```mach
pub fun submit_send_batch(backend: *Backend, native: usize, packets: *types.Packet, count: usize, context: usize, token: *types.Token) i64;
```

## fun submit_shutdown_write

```mach
pub fun submit_shutdown_write(backend: *Backend, native: usize, context: usize, token: *types.Token) i64;
```

## fun submit_close

```mach
pub fun submit_close(backend: *Backend, native: usize, context: usize, token: *types.Token) i64;
```

## fun cancel

```mach
pub fun cancel(backend: *Backend, token: types.Token) i64;
```

## fun flush

```mach
pub fun flush(backend: *Backend) i64;
```

## fun dispatch

```mach
pub fun dispatch(
backend: *Backend,
context: usize,
events: u32,
status: i64,
flags: u64,
claimed: *bool,
) i64;
```

## fun poll

```mach
pub fun poll(backend: *Backend, timeout_ms: i32) i64;
```

one thread owns poll and completion retrieval

## fun completion

```mach
pub fun completion(backend: *Backend, index: usize, out: *types.NativeCompletion) i64;
```

## fun destroy

```mach
pub fun destroy(backend: *Backend) i64;
```

