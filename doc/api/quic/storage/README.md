[quic](../README.md) / **storage**

# quic.storage

| Module | |
| :--- | :--- |
| [`chunks`](chunks.md) | the pool chunks holding one byte sequence, such as a stream direction or a crypto level, kept sorted by chunk number (offset >> SHIFT) |
| [`heap`](heap.md) | growable min-heap of slot indices ordered by a u64 key |
| [`index`](index.md) | open-addressed hash index from a keyed hash to a slot index |
| [`limited`](limited.md) | a strict test allocator with a live-byte budget and refusable releases |
| [`ranges`](ranges.md) | a bounded set of byte offsets kept as sorted, disjoint, non-adjacent half-open intervals |
| [`slots`](slots.md) | growable index-addressed records with a free list |
| [`source`](source.md) | where connection storage comes from: a std buffer source, seen through one connection's account |

