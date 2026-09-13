# std.net.tcp

## rec Listener

```mach
pub rec Listener;
```

a bound TCP socket listening for connections

handle: the native-width socket handle

## rec Stream

```mach
pub rec Stream;
```

a connected TCP socket for reading and writing

handle: the native-width socket handle

## fun listen

```mach
pub fun listen(ep: ip.Endpoint, backlog: i32) Result[Listener, io_error.Error];
```

create a TCP listener bound to an endpoint

creates a socket, sets SO_REUSEADDR, binds to the address and port,
and begins listening with the given backlog.

ep: endpoint to bind to
backlog: maximum pending connection queue length
ret: the Listener, or an error message

## fun listen_with_flags

```mach
pub fun listen_with_flags(ep: ip.Endpoint, backlog: i32, flags: socket_api.Flags) Result[Listener, io_error.Error];
```

## fun accept

```mach
pub fun accept(ln: *Listener) Result[Stream, io_error.Error];
```

accept a new connection on a listener

ln: the listener to accept on
ret: a connected Stream, or an error message

## fun accept_with_flags

```mach
pub fun accept_with_flags(ln: *Listener, flags: socket_api.Flags) Result[Stream, io_error.Error];
```

## fun accept_ep

```mach
pub fun accept_ep(ln: *Listener, ep: *ip.Endpoint) Result[Stream, io_error.Error];
```

accept a new connection and populate the remote endpoint

ln: the listener to accept on
ep: pointer to an Endpoint to fill with the remote address
ret: a connected Stream, or an error message

## fun accept_ep_with_flags

```mach
pub fun accept_ep_with_flags(ln: *Listener, ep: *ip.Endpoint, flags: socket_api.Flags) Result[Stream, io_error.Error];
```

## fun connect

```mach
pub fun connect(ep: ip.Endpoint) Result[Stream, io_error.Error];
```

establish a TCP connection to a remote endpoint

ep: endpoint to connect to
ret: a connected Stream, or an error message

## fun connect_with_flags

```mach
pub fun connect_with_flags(ep: ip.Endpoint, flags: socket_api.Flags) Result[Stream, io_error.Error];
```

## fun listener_local_endpoint

```mach
pub fun listener_local_endpoint(ln: *Listener) Result[ip.Endpoint, io_error.Error];
```

## fun stream_local_endpoint

```mach
pub fun stream_local_endpoint(stream: *Stream) Result[ip.Endpoint, io_error.Error];
```

## fun stream_remote_endpoint

```mach
pub fun stream_remote_endpoint(stream: *Stream) Result[ip.Endpoint, io_error.Error];
```

## fun stream_read

```mach
pub fun stream_read(s: *Stream, buf: *u8, len: usize) Result[usize, io_error.Error];
```

read bytes from a TCP stream

s: the stream to read from
buf: destination buffer
len: maximum bytes to read
ret: bytes read, 0 on peer close, or a normalized I/O error

## fun stream_set_read_timeout

```mach
pub fun stream_set_read_timeout(s: *Stream, ms: u64) Result[bool, io_error.Error];
```

bound blocking reads on a TCP stream to a timeout

sets SO_RCVTIMEO on the stream. after ms elapses with no data pending, a
stream_read returns a normalized timeout or would-block error after the
interval, distinct from a peer close. ms == 0 restores indefinite blocking.

s: the stream to bound reads on
ms: timeout in milliseconds, or 0 for no timeout
ret: ok on success, or an error message

## fun stream_write

```mach
pub fun stream_write(s: *Stream, buf: *u8, len: usize) Result[usize, io_error.Error];
```

write bytes to a TCP stream

s: the stream to write to
buf: source buffer
len: number of bytes to write
ret: number of bytes written, or negative on error

## fun stream_shutdown

```mach
pub fun stream_shutdown(s: *Stream, how: i32) Result[bool, io_error.Error];
```

shut down part or all of a TCP stream

s: the stream to shut down
how: SHUT_RD (0), SHUT_WR (1), or SHUT_RDWR (2)

## fun stream_close

```mach
pub fun stream_close(s: *Stream) Result[bool, io_error.Error];
```

close a TCP stream

s: the stream to close

## fun listener_close

```mach
pub fun listener_close(ln: *Listener) Result[bool, io_error.Error];
```

close a TCP listener

ln: the listener to close

