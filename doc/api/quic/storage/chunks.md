[quic](../README.md) / [storage](README.md) / **chunks**

# quic.storage.chunks

the pool chunks holding one byte sequence, such as a stream direction or a
crypto level, kept sorted by chunk number (offset >> SHIFT)

two slots live inline. more spill into one pool chunk. every chunk, the
spill included, counts against the source's account and direction. a chunk
that an in-flight attempt retains is never released

chunks come from quic.storage.source, which is the only caller of std's
buffer source

Source: [`src/storage/chunks.mach`](../../../../src/storage/chunks.mach)

Uses types from [`quic.storage.ranges`](ranges.md), [`quic.storage.source`](source.md).

| Type | | |
| :--- | :--- | :--- |
| [`Slot`](#slot) | `rec` |  |
| [`Chunks`](#chunks) | `rec` |  |
| [`Reserved`](#reserved) | `rec` | the chunks one span needs, taken before anything else changes so a refusal leaves the buffer as it was |
| [`Block`](#block) | `rec` | one whole chunk laid out by its holder, such as state a connection needs only until its handshake is confirmed |

| On `Chunks` | |
| :--- | :--- |
| [`count`](#count), [`spilled`](#spilled) | |
| [`find`](#find) | the chunk numbered `number`, or nil |
| [`address`](#address) | the byte at `offset`, or nil when its chunk is not held |
| [`ensure`](#ensure) | the chunk holding `offset`, taken from the pool when it is not there yet |
| [`reserve`](#reserve) | takes the chunks of [offset, offset + length) that `chunks` lacks, plus a spill if the list will outgrow its inline slots, or nothing |
| [`commit`](#commit) | |
| [`ensure_span`](#ensure_span) | takes every chunk [offset, offset + length) lacks, or none |
| [`write`](#write) | copies bytes into chunks that already exist |
| [`read`](#read) | copies bytes out of chunks that exist |
| [`conflicts`](#conflicts) | whether any input byte differs from a byte `present` says is already held |
| [`release_below`](#release_below) | releases, in order, the chunks that lie wholly below `limit` and that nothing retains, stopping at the first that is still retained |
| [`release_from`](#release_from) | releases the chunks numbered at least `number`, none of which may be retained |
| [`release_consumed`](#release_consumed) | releases what lies below a consumed prefix |
| [`release_all`](#release_all) | releases every chunk nothing retains |

| On `Reserved` | |
| :--- | :--- |
| [`cancel`](#cancel) | |

| On `Block` | |
| :--- | :--- |
| [`take_block`](#take_block) | takes a zeroed chunk into an empty block |
| [`give_block`](#give_block) | wipes and gives back a held block |

| Functions | |
| :--- | :--- |
| [`number_of`](#number_of) | |
| [`room`](#room) | bytes from `offset` to the end of its chunk |

| Constants | |
| :--- | :--- |
| [`SHIFT`](#constants), [`INLINE`](#constants), [`SPILL_CAPACITY`](#constants), [`RESERVE`](#constants) | |

---

## Slot

```mach
pub rec Slot {
    number: u64;
    chunk:  quic.storage.source.Chunk;
}
```

## Chunks

```mach
pub rec Chunks {
    inline: [INLINE]Slot;
    spill:  quic.storage.source.Chunk;
    count:  usize;
}
```

### count

```mach
pub fun count(chunks: *Chunks) usize
```

### spilled

```mach
pub fun spilled(chunks: *Chunks) bool
```

### find

```mach
pub fun find(chunks: *Chunks, number: u64) *Slot
```

the chunk numbered `number`, or nil

### address

```mach
pub fun address(chunks: *Chunks, offset: u64) *u8
```

the byte at `offset`, or nil when its chunk is not held

### ensure

```mach
pub fun ensure(chunks: *Chunks, from: *quic.storage.ranges.Source, offset: u64) *Slot
```

the chunk holding `offset`, taken from the pool when it is not there yet.
nil when the pool or the list refuses, with nothing changed

### reserve

```mach
pub fun reserve(chunks: *Chunks, from: *quic.storage.ranges.Source, offset: u64, length: usize,
    reserved: *Reserved) bool
```

takes the chunks of [offset, offset + length) that `chunks` lacks, plus a
spill if the list will outgrow its inline slots, or nothing. `chunks` is nil
for a buffer that does not exist yet

### commit

```mach
pub fun commit(chunks: *Chunks, reserved: *Reserved)
```

### ensure_span

```mach
pub fun ensure_span(chunks: *Chunks, from: *quic.storage.ranges.Source, offset: u64,
    length: usize) bool
```

takes every chunk [offset, offset + length) lacks, or none

### write

```mach
pub fun write(chunks: *Chunks, offset: u64, input: *u8, length: usize)
```

copies bytes into chunks that already exist

### read

```mach
pub fun read(chunks: *Chunks, offset: u64, output: *u8, length: usize)
```

copies bytes out of chunks that exist

### conflicts

```mach
pub fun conflicts(chunks: *Chunks, present: *quic.storage.ranges.RangeSet, offset: u64,
    input: *u8, length: usize) bool
```

whether any input byte differs from a byte `present` says is already held

### release_below

```mach
pub fun release_below(chunks: *Chunks, from: *quic.storage.ranges.Source, limit: u64)
```

releases, in order, the chunks that lie wholly below `limit` and that nothing
retains, stopping at the first that is still retained

### release_from

```mach
pub fun release_from(chunks: *Chunks, from: *quic.storage.ranges.Source, number: u64)
```

releases the chunks numbered at least `number`, none of which may be retained

### release_consumed

```mach
pub fun release_consumed(chunks: *Chunks, from: *quic.storage.ranges.Source, prefix: u64,
    drained: bool)
```

releases what lies below a consumed prefix. once nothing past the prefix is
held, the partly used chunk at its end goes too, since later bytes take a
fresh chunk at their own number

### release_all

```mach
pub fun release_all(chunks: *Chunks, from: *quic.storage.ranges.Source)
```

releases every chunk nothing retains. a retained chunk stays until settled

## Reserved

```mach
pub rec Reserved {
    slots: [RESERVE]Slot;
    count: usize;
    spill: quic.storage.source.Chunk;
}
```

the chunks one span needs, taken before anything else changes so a refusal
leaves the buffer as it was

### cancel

```mach
pub fun cancel(from: *quic.storage.ranges.Source, reserved: *Reserved)
```

## Block

```mach
pub rec Block {
    chunk: quic.storage.source.Chunk;
    data:  *u8;
}
```

one whole chunk laid out by its holder, such as state a connection needs
only until its handshake is confirmed

### take_block

```mach
pub fun take_block(from: *quic.storage.ranges.Source, block: *Block) bool
```

takes a zeroed chunk into an empty block

### give_block

```mach
pub fun give_block(from: *quic.storage.ranges.Source, block: *Block)
```

wipes and gives back a held block. an empty block is left as it is

## Functions

### number_of

```mach
pub fun number_of(offset: u64) u64
```

### room

```mach
pub fun room(offset: u64) u64
```

bytes from `offset` to the end of its chunk

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `SHIFT` | `u64` | `12` |  |
| `INLINE` | `usize` | `2` |  |
| `SPILL_CAPACITY` | `usize` | `supply.BYTES / $size_of(Slot)` |  |
| `RESERVE` | `usize` | `4` |  |

