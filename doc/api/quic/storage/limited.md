[quic](../README.md) / [storage](README.md) / **limited**

# quic.storage.limited

a strict test allocator with a live-byte budget and refusable releases

it wraps std's testing allocator, so overruns fault and fresh memory is
poisoned, and adds the two refusals growth code has to survive: running out
part way through a real flow, and a backend that will not take memory back

Source: [`src/storage/limited.mach`](../../../../src/storage/limited.mach)

| Type | | |
| :--- | :--- | :--- |
| [`Limited`](#limited) | `rec` |  |

| On `Limited` | |
| :--- | :--- |
| [`make`](#make) | the instance must not move after this, and must outlive what it hands out |
| [`allocator_of`](#allocator_of) | |
| [`clean`](#clean) | true when every byte handed out came back and nothing was freed twice |
| [`dnit`](#dnit) | |

---

## Limited

```mach
pub rec Limited {
    a:              std.allocator.Allocator;
    inner:          std.allocator.testing.Testing;
    budget:         usize;
    live_bytes:     usize;
    refusals:       usize;
    refuse_release: bool;
}
```

### make

```mach
pub fun make(state: *Limited, budget: usize) bool
```

the instance must not move after this, and must outlive what it hands out

### allocator_of

```mach
pub fun allocator_of(state: *Limited) *std.allocator.Allocator
```

### clean

```mach
pub fun clean(state: *Limited) bool
```

true when every byte handed out came back and nothing was freed twice

### dnit

```mach
pub fun dnit(state: *Limited)
```

