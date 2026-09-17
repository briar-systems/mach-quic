# quic.storage.chunks

## val SHIFT

```mach
pub val SHIFT:          u64   = 12
```

## val INLINE

```mach
pub val INLINE:         usize = 2
```

## val SPILL_CAPACITY

```mach
pub val SPILL_CAPACITY: usize = supply.BYTES / $size_of(Slot)
```

## val RESERVE

```mach
pub val RESERVE:        usize = 4
```

## rec Slot

```mach
pub rec Slot;
```

## rec Chunks

```mach
pub rec Chunks;
```

## rec Reserved

```mach
pub rec Reserved;
```

the chunks one span needs, taken before anything else changes so a refusal
leaves the buffer as it was

## rec Block

```mach
pub rec Block;
```

one whole chunk laid out by its holder, such as state a connection needs
only until its handshake is confirmed

## fun take_block

```mach
pub fun take_block(from: *ranges.Source, block: *Block) bool;
```

takes a zeroed chunk into an empty block

## fun give_block

```mach
pub fun give_block(from: *ranges.Source, block: *Block);
```

wipes and gives back a held block. an empty block is left as it is

## fun number_of

```mach
pub fun number_of(offset: u64) u64;
```

## fun room

```mach
pub fun room(offset: u64) u64;
```

bytes from `offset` to the end of its chunk

## fun count

```mach
pub fun count(chunks: *Chunks) usize;
```

## fun spilled

```mach
pub fun spilled(chunks: *Chunks) bool;
```

## fun find

```mach
pub fun find(chunks: *Chunks, number: u64) *Slot;
```

the chunk numbered `number`, or nil

## fun address

```mach
pub fun address(chunks: *Chunks, offset: u64) *u8;
```

the byte at `offset`, or nil when its chunk is not held

## fun ensure

```mach
pub fun ensure(chunks: *Chunks, from: *ranges.Source, offset: u64) *Slot;
```

the chunk holding `offset`, taken from the pool when it is not there yet.
nil when the pool or the list refuses, with nothing changed

## fun cancel

```mach
pub fun cancel(from: *ranges.Source, reserved: *Reserved);
```

## fun reserve

```mach
pub fun reserve(chunks: *Chunks, from: *ranges.Source, offset: u64, length: usize,
reserved: *Reserved) bool;
```

takes the chunks of [offset, offset + length) that `chunks` lacks, plus a
spill if the list will outgrow its inline slots, or nothing. `chunks` is nil
for a buffer that does not exist yet

## fun commit

```mach
pub fun commit(chunks: *Chunks, reserved: *Reserved);
```

## fun ensure_span

```mach
pub fun ensure_span(chunks: *Chunks, from: *ranges.Source, offset: u64,
length: usize) bool;
```

takes every chunk [offset, offset + length) lacks, or none

## fun write

```mach
pub fun write(chunks: *Chunks, offset: u64, input: *u8, length: usize);
```

copies bytes into chunks that already exist

## fun read

```mach
pub fun read(chunks: *Chunks, offset: u64, output: *u8, length: usize);
```

copies bytes out of chunks that exist

## fun conflicts

```mach
pub fun conflicts(chunks: *Chunks, present: *ranges.RangeSet, offset: u64,
input: *u8, length: usize) bool;
```

whether any input byte differs from a byte `present` says is already held

## fun release_below

```mach
pub fun release_below(chunks: *Chunks, from: *ranges.Source, limit: u64);
```

releases, in order, the chunks that lie wholly below `limit` and that nothing
retains, stopping at the first that is still retained

## fun release_from

```mach
pub fun release_from(chunks: *Chunks, from: *ranges.Source, number: u64);
```

releases the chunks numbered at least `number`, none of which may be retained

## fun release_consumed

```mach
pub fun release_consumed(chunks: *Chunks, from: *ranges.Source, prefix: u64,
drained: bool);
```

releases what lies below a consumed prefix. once nothing past the prefix is
held, the partly used chunk at its end goes too, since later bytes take a
fresh chunk at their own number

## fun release_all

```mach
pub fun release_all(chunks: *Chunks, from: *ranges.Source);
```

releases every chunk nothing retains. a retained chunk stays until settled

