# std.net.udp

## rec Socket

```mach
pub rec Socket;
```

a bound or unbound UDP socket

handle: the native-width socket handle

## fun create

```mach
pub fun create() Result[Socket, io_error.Error];
```

create an unbound UDP socket

ret: the Socket, or an error message

## fun create_v6

```mach
pub fun create_v6() Result[Socket, io_error.Error];
```

## fun create_with_flags

```mach
pub fun create_with_flags(family: i32, flags: socket_api.Flags) Result[Socket, io_error.Error];
```

## fun bind

```mach
pub fun bind(ep: ip.Endpoint) Result[Socket, io_error.Error];
```

create a UDP socket bound to an endpoint

ep: endpoint to bind to
ret: the bound Socket, or an error message

## fun bind_with_flags

```mach
pub fun bind_with_flags(ep: ip.Endpoint, flags: socket_api.Flags) Result[Socket, io_error.Error];
```

## fun local_endpoint

```mach
pub fun local_endpoint(s: *Socket) Result[ip.Endpoint, io_error.Error];
```

## fun remote_endpoint

```mach
pub fun remote_endpoint(s: *Socket) Result[ip.Endpoint, io_error.Error];
```

## fun send_to

```mach
pub fun send_to(s: *Socket, buf: *u8, len: usize, ep: ip.Endpoint) Result[usize, io_error.Error];
```

send a datagram to a remote endpoint

s: the socket to send from
buf: source buffer
len: number of bytes to send
ep: destination endpoint
ret: number of bytes sent, or negative on error

## fun recv_from

```mach
pub fun recv_from(s: *Socket, buf: *u8, len: usize, ep: *ip.Endpoint) Result[usize, io_error.Error];
```

receive a datagram and populate the source endpoint

s: the socket to receive on
buf: destination buffer
len: maximum bytes to receive
ep: pointer to an Endpoint to fill with the source address
ret: number of bytes received, or negative on error

## fun socket_set_recv_timeout

```mach
pub fun socket_set_recv_timeout(s: *Socket, ms: u64) Result[bool, io_error.Error];
```

bound blocking receives on a UDP socket to a timeout

sets SO_RCVTIMEO on the socket. after ms elapses with no datagram pending, a
recv_from returns a normalized timeout or would-block error. ms == 0
restores indefinite blocking.

s: the socket to bound receives on
ms: timeout in milliseconds, or 0 for no timeout
ret: ok on success, or an error message

## fun socket_close

```mach
pub fun socket_close(s: *Socket) Result[bool, io_error.Error];
```

close a UDP socket

s: the socket to close

