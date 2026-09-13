# std.net.ip

## rec IPv4

```mach
pub rec IPv4;
```

an IPv4 address stored as four octets

octets: the four octets in network order

## rec IPv6

```mach
pub rec IPv6;
```

an IPv6 address stored as sixteen octets

octets: the sixteen octets in network order

## rec Addr

```mach
pub rec Addr;
```

a tagged union of IPv4 and IPv6 addresses

is_v6: nonzero if the address is IPv6
v4: the IPv4 address (valid when is_v6 == 0)
v6: the IPv6 address (valid when is_v6 != 0)

## rec Endpoint

```mach
pub rec Endpoint;
```

an IP address and port pair

addr: IPv4 or IPv6 address
port: port number in host byte order
scope: IPv6 interface scope identifier, or zero

## fun ipv4

```mach
pub fun ipv4(a: u8, b: u8, c: u8, d: u8) IPv4;
```

create an IPv4 address from four octets

a: first octet
b: second octet
c: third octet
d: fourth octet
ret: the constructed IPv4 address

## fun ipv4_any

```mach
pub fun ipv4_any() IPv4;
```

return the unspecified IPv4 address (0.0.0.0)

## fun ipv4_loopback

```mach
pub fun ipv4_loopback() IPv4;
```

return the IPv4 loopback address (127.0.0.1)

## fun ipv4_to_u32

```mach
pub fun ipv4_to_u32(ip: IPv4) u32;
```

convert an IPv4 address to a network byte order u32

ip: the IPv4 address
ret: 32-bit integer in network byte order

## fun ipv4_from_u32

```mach
pub fun ipv4_from_u32(n: u32) IPv4;
```

convert a network byte order u32 to an IPv4 address

n: 32-bit integer in network byte order
ret: the constructed IPv4 address

## fun ipv4_format

```mach
pub fun ipv4_format(ip: IPv4, buf: *u8, len: usize) usize;
```

format an IPv4 address as "a.b.c.d" into a buffer

ip: the IPv4 address
buf: destination buffer
len: buffer capacity in bytes
ret: number of bytes written (not including null terminator)

## fun ipv6_any

```mach
pub fun ipv6_any() IPv6;
```

return the unspecified IPv6 address (::)

## fun ipv6_loopback

```mach
pub fun ipv6_loopback() IPv6;
```

return the IPv6 loopback address (::1)

## fun addr_v4

```mach
pub fun addr_v4(ip: IPv4) Addr;
```

wrap an IPv4 address in an Addr

ip: the IPv4 address
ret: an Addr containing the IPv4 address

## fun addr_v6

```mach
pub fun addr_v6(ip: IPv6) Addr;
```

wrap an IPv6 address in an Addr

ip: the IPv6 address
ret: an Addr containing the IPv6 address

## fun endpoint

```mach
pub fun endpoint(a: u8, b: u8, c: u8, d: u8, port: u16) Endpoint;
```

create an Endpoint from octets and a port

a: first octet
b: second octet
c: third octet
d: fourth octet
port: port number in host byte order
ret: the constructed Endpoint

## fun endpoint_v4

```mach
pub fun endpoint_v4(addr: IPv4, port: u16) Endpoint;
```

## fun endpoint_v6

```mach
pub fun endpoint_v6(addr: IPv6, port: u16, scope: u32) Endpoint;
```

## fun endpoint_family

```mach
pub fun endpoint_family(ep: Endpoint) i32;
```

## fun sockaddr_size

```mach
pub fun sockaddr_size(ep: Endpoint) usize;
```

## fun to_sockaddr

```mach
pub fun to_sockaddr(ep: Endpoint, sa: *u8) usize;
```

serialize an Endpoint into a sockaddr_in byte buffer

ep: the endpoint to serialize
sa: pointer to a buffer of at least os.SOCKADDR_IN_SIZE bytes

## fun from_sockaddr

```mach
pub fun from_sockaddr(sa: *u8, ep: *Endpoint) bool;
```

deserialize a sockaddr_in byte buffer into an Endpoint

sa: pointer to the sockaddr_in buffer
ep: pointer to the Endpoint to fill

## fun ipv4_parse

```mach
pub fun ipv4_parse(text: str) Result[IPv4, str];
```

## fun ipv6_parse

```mach
pub fun ipv6_parse(text: str) Result[IPv6, str];
```

## fun addr_parse

```mach
pub fun addr_parse(text: str) Result[Addr, str];
```

parse a borrowed address string without retaining or allocating it

## fun endpoint_parse

```mach
pub fun endpoint_parse(text: str) Result[Endpoint, str];
```

parse a borrowed endpoint string into a self-contained value

IPv6 zones are numeric interface indices. named zones fail explicitly
because resolving an interface name belongs to a target network interface API.

## fun ipv6_format

```mach
pub fun ipv6_format(addr: IPv6, buf: *u8, cap: usize) usize;
```

## fun addr_format

```mach
pub fun addr_format(addr: Addr, buf: *u8, cap: usize) usize;
```

format an address into caller-owned storage without allocating

## fun endpoint_format

```mach
pub fun endpoint_format(ep: Endpoint, buf: *u8, cap: usize) usize;
```

format an endpoint into caller-owned storage without allocating

## fun addr_is_unspecified

```mach
pub fun addr_is_unspecified(addr: Addr) bool;
```

## fun addr_is_loopback

```mach
pub fun addr_is_loopback(addr: Addr) bool;
```

## fun addr_is_multicast

```mach
pub fun addr_is_multicast(addr: Addr) bool;
```

## fun addr_is_v4_mapped

```mach
pub fun addr_is_v4_mapped(addr: Addr) bool;
```

