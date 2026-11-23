[quic](../README.md) / [transport](README.md) / **binding**

# quic.transport.binding

the production Protocol: the vtable that joins connection.core to the driver

this is what the untyped context made unconstructable. every core operation
takes the public record and the secret-welded Secrets together, and a
*Secrets cannot be erased to `ptr`, so a vtable with an opaque context could
only ever be implemented by a test double whose context holds no secrets.
with Protocol[T] the context is simply typed and the binding is thin.

Source: [`src/transport/binding.mach`](../../../../src/transport/binding.mach)

Uses types from [`quic.connection.core`](../connection/core.md), [`quic.connection.scratch`](../connection/scratch.md), [`quic.transport`](../transport.md).

| Type | | |
| :--- | :--- | :--- |
| [`RoutingId`](#routingid) | `rec` |  |
| [`Route`](#route) | `rec` |  |
| [`RoutingSnapshot`](#routingsnapshot) | `rec` |  |
| [`Binding`](#binding) | `rec` | holds the pointers the core's operations take and the pump's scratch pair, lent to the core around each call |

| On `Binding` | |
| :--- | :--- |
| [`reconcile_routes`](#reconcile_routes) | publishes a route for every live local id and retires every other |
| [`bind`](#bind) | binds an already-initialized core and the scratch pair its storage points into |
| [`prepare_initial_route`](#prepare_initial_route) | stages the stable sequence-zero route while it is not externally visible |
| [`abandon_initialization`](#abandon_initialization) | rollback retires routes that remained private to a failed assembly init |
| [`publish_initial_route`](#publish_initial_route) | |
| [`release_ready`](#release_ready) | release is valid only after the production core has destroyed its secrets, handshake provider, and every leased manager, and after routing is invisible |
| [`release_closed`](#release_closed) | retired epochs are deliberately preserved so a route from an earlier use of the stable record can never validate after the next publication |
| [`routing_snapshot`](#routing_snapshot), [`route_at`](#route_at), [`route_valid`](#route_valid) | |
| [`protocol`](#protocol) | an unbound binding yields a vtable with a nil context, which the driver rejects, so a protocol cannot be installed over a core that is not there |

| Constants | |
| :--- | :--- |
| [`ROUTING_ID_CAPACITY`](#constants) | one route for each local connection id a connection may hold at once |
| [`ROUTING_ID_LENGTH`](#constants) | |

---

## RoutingId

```mach
pub rec RoutingId {
    data:   [20]u8;
    length: usize;
}
```

## Route

```mach
pub rec Route {
    source:     u64;
    index:      usize;
    generation: u64;
    sequence:   u64;
    id:         RoutingId;
    active:     bool;
}
```

## RoutingSnapshot

```mach
pub rec RoutingSnapshot {
    source:      u64;
    capacity:    usize;
    active:      usize;
    initialized: bool;
}
```

## Binding

```mach
pub rec Binding {
    anchor:         u64;
    core:           *quic.connection.core.Core;
    secrets:        *quic.connection.core.Secrets;
    scratch:        *quic.connection.scratch.Scratch;
    secret_scratch: *quic.connection.scratch.SecretScratch;
    routing:        [ROUTING_ID_CAPACITY]RoutingEntry;
    routing_source: u64;
    # routes follow the local ids once the initial route is published
    routing_live: bool;
    initialized:  bool;
    released:     bool;
}
```

holds the pointers the core's operations take and the pump's scratch pair,
lent to the core around each call. it is the protocol context, so it must
stay disjoint from the driver record the transport validates it against

### reconcile_routes

```mach
pub fun reconcile_routes(binding: *Binding)
```

publishes a route for every live local id and retires every other. each
operation that can issue, retire or advertise an id reconciles before it
returns, so a route is visible before its NEW_CONNECTION_ID can leave

### bind

```mach
pub fun bind(binding: *Binding, core: *quic.connection.core.Core,
    secrets: *quic.connection.core.Secrets, public: *quic.connection.scratch.Scratch,
    secret: *quic.connection.scratch.SecretScratch) bool
```

binds an already-initialized core and the scratch pair its storage points
into. the core has validated its own ownership set by then, so the binding
only refuses a core that is not live

### prepare_initial_route

```mach
pub fun prepare_initial_route(binding: *Binding, data: *u8,
    length: usize) bool
```

stages the stable sequence-zero route while it is not externally visible.
assembly publishes it only after the transport driver is initialized
a zero-length id publishes a route with an empty key: the connection is
found by its address, never by a connection id

### abandon_initialization

```mach
pub fun abandon_initialization(binding: *Binding) bool
```

rollback retires routes that remained private to a failed assembly init

### publish_initial_route

```mach
pub fun publish_initial_route(binding: *Binding) bool
```

### release_ready

```mach
pub fun release_ready(binding: *Binding) bool
```

release is valid only after the production core has destroyed its secrets,
handshake provider, and every leased manager, and after routing is invisible

### release_closed

```mach
pub fun release_closed(binding: *Binding) bool
```

retired epochs are deliberately preserved so a route from an earlier use of
the stable record can never validate after the next publication

### routing_snapshot

```mach
pub fun routing_snapshot(binding: *Binding) RoutingSnapshot
```

### route_at

```mach
pub fun route_at(binding: *Binding, index: usize) Route
```

### route_valid

```mach
pub fun route_valid(binding: *Binding, route: *Route) bool
```

### protocol

```mach
pub fun protocol(binding: *Binding) quic.transport.Protocol[Binding]
```

an unbound binding yields a vtable with a nil context, which the driver
rejects, so a protocol cannot be installed over a core that is not there

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ROUTING_ID_CAPACITY` | `usize` | `4` | one route for each local connection id a connection may hold at once |
| `ROUTING_ID_LENGTH` | `usize` | `20` |  |

