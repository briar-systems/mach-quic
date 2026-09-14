# std.encoding.binary

## def Order

```mach
pub def Order: u8
```

byte order for multi-byte values

## val LITTLE

```mach
pub val LITTLE: Order = 0
```

## val BIG

```mach
pub val BIG:    Order = 1
```

## def Checkpoint

```mach
pub def Checkpoint: usize
```

a logical position captured for explicit rollback

## fun put_uint

```mach
pub fun put_uint(dst: *u8, v: u64, sz: usize, order: Order);
```

write the low sz bytes of v into dst in the given order

dst: destination for sz bytes
v: value whose low sz bytes are written
sz: number of bytes to write (1..8)
order: byte order

## fun get_uint

```mach
pub fun get_uint(src: *u8, sz: usize, order: Order) u64;
```

read sz bytes from src in the given order into a u64

src: source of sz bytes
sz: number of bytes to read (1..8)
order: byte order
ret: the assembled value in the low sz bytes

## rec Encoder

```mach
pub rec Encoder;
```

growable byte sequence with a fixed byte order

alloc: allocator for buffer memory
order: byte order for multi-byte writes
data: backing byte array
len: bytes written
cap: allocated capacity

## fun encoder

```mach
pub fun encoder(a: *A.Allocator, order: Order) Encoder;
```

create an empty encoder

a: allocator for buffer memory
order: byte order for multi-byte writes
ret: a new empty Encoder

## fun encoder_dnit

```mach
pub fun encoder_dnit(e: *Encoder) bool;
```

free the encoder's buffer and reset it

e: encoder to deinitialize
ret: true if memory was freed

## fun reserve

```mach
pub fun reserve(e: *Encoder, additional: usize) R.Result[usize, str];
```

ensure capacity for `additional` more bytes

e: encoder to reserve in
additional: number of additional bytes needed
ret: new capacity, or an error

## fun write_u8

```mach
pub fun write_u8(e: *Encoder, v: u8) R.Result[usize, str];
```

append a u8

e: encoder to write into
v: value to append
ret: new length, or an error

## fun write_u16

```mach
pub fun write_u16(e: *Encoder, v: u16) R.Result[usize, str];
```

append a u16 in the encoder's byte order

e: encoder to write into
v: value to append
ret: new length, or an error

## fun write_u32

```mach
pub fun write_u32(e: *Encoder, v: u32) R.Result[usize, str];
```

append a u32 in the encoder's byte order

e: encoder to write into
v: value to append
ret: new length, or an error

## fun write_u64

```mach
pub fun write_u64(e: *Encoder, v: u64) R.Result[usize, str];
```

append a u64 in the encoder's byte order

e: encoder to write into
v: value to append
ret: new length, or an error

## fun write_bytes

```mach
pub fun write_bytes(e: *Encoder, p: *u8, len: usize) R.Result[usize, str];
```

append raw bytes verbatim

e: encoder to write into
p: source bytes
len: number of bytes
ret: new length, or an error

## fun write_str

```mach
pub fun write_str(e: *Encoder, s: str) R.Result[usize, str];
```

append a string and its null terminator

e: encoder to write into
s: string to append
ret: new length, or an error

## fun align

```mach
pub fun align(e: *Encoder, boundary: usize) R.Result[usize, str];
```

pad with zero bytes up to an alignment boundary

e: encoder to align
boundary: alignment boundary (a power of two)
ret: new length, or an error

## fun patch_u8

```mach
pub fun patch_u8(e: *Encoder, offset: usize, v: u8) R.Result[usize, str];
```

overwrite a u8 at an earlier offset without changing length

## fun patch_u16

```mach
pub fun patch_u16(e: *Encoder, offset: usize, v: u16) R.Result[usize, str];
```

overwrite a u16 at an earlier offset in the encoder's byte order

e: encoder to patch
offset: byte offset to write at
v: value to write
ret: bytes written, or an error

## fun patch_u32

```mach
pub fun patch_u32(e: *Encoder, offset: usize, v: u32) R.Result[usize, str];
```

overwrite a u32 at an earlier offset in the encoder's byte order

e: encoder to patch
offset: byte offset to write at
v: value to write
ret: bytes written, or an error

## fun patch_u64

```mach
pub fun patch_u64(e: *Encoder, offset: usize, v: u64) R.Result[usize, str];
```

overwrite a u64 at an earlier offset in the encoder's byte order

e: encoder to patch
offset: byte offset to write at
v: value to write
ret: bytes written, or an error

## rec Builder

```mach
pub rec Builder;
```

fixed-capacity byte builder with a transactional reservation lock

order: byte order for multi-byte writes
data: caller-owned backing bytes
len: logically published bytes
cap: backing capacity
reserved: whether a child reservation owns the unpublished tail
epoch: monotonically increasing reservation identity

## rec Reservation

```mach
pub rec Reservation;
```

unpublished child builder over a reserved parent tail

parent: parent whose logical length remains unchanged until commit
body: fixed child builder bounded to the reservation
start: parent's logical length when the reservation began
limit: reserved byte capacity
epoch: identity used to reject stale reservation handles
active: whether the reservation can still commit or roll back

an active reservation and its parent must stay at stable addresses. resolve
nested reservations before their parents and do not copy active handles.

## fun builder

```mach
pub fun builder(data: *u8, cap: usize, order: Order) Builder;
```

wrap caller-owned storage as an empty fixed builder

## fun builder_remaining

```mach
pub fun builder_remaining(b: *Builder) usize;
```

bytes available after the builder's published prefix

## fun builder_write_u8

```mach
pub fun builder_write_u8(b: *Builder, v: u8) R.Result[usize, str];
```

append a u8 atomically

## fun builder_write_u16

```mach
pub fun builder_write_u16(b: *Builder, v: u16) R.Result[usize, str];
```

append a u16 in the builder's byte order atomically

## fun builder_write_u32

```mach
pub fun builder_write_u32(b: *Builder, v: u32) R.Result[usize, str];
```

append a u32 in the builder's byte order atomically

## fun builder_write_u64

```mach
pub fun builder_write_u64(b: *Builder, v: u64) R.Result[usize, str];
```

append a u64 in the builder's byte order atomically

## fun builder_write_bytes

```mach
pub fun builder_write_bytes(b: *Builder, data: *u8, len: usize) R.Result[usize, str];
```

append raw bytes atomically

## fun builder_write_str

```mach
pub fun builder_write_str(b: *Builder, s: str) R.Result[usize, str];
```

append a string and null terminator atomically

## fun builder_align

```mach
pub fun builder_align(b: *Builder, boundary: usize) R.Result[usize, str];
```

append zero padding to a power-of-two boundary atomically

## fun builder_patch_u8

```mach
pub fun builder_patch_u8(b: *Builder, offset: usize, v: u8) R.Result[usize, str];
```

patch one published byte without changing length

## fun builder_patch_u16

```mach
pub fun builder_patch_u16(b: *Builder, offset: usize, v: u16) R.Result[usize, str];
```

patch a published u16 without changing length

## fun builder_patch_u32

```mach
pub fun builder_patch_u32(b: *Builder, offset: usize, v: u32) R.Result[usize, str];
```

patch a published u32 without changing length

## fun builder_patch_u64

```mach
pub fun builder_patch_u64(b: *Builder, offset: usize, v: u64) R.Result[usize, str];
```

patch a published u64 without changing length

## fun builder_checkpoint

```mach
pub fun builder_checkpoint(b: *Builder) R.Result[Checkpoint, str];
```

capture the current fixed-builder length for explicit rollback

## fun builder_rollback

```mach
pub fun builder_rollback(b: *Builder, mark: Checkpoint) R.Result[usize, str];
```

restore a prior builder checkpoint without changing backing bytes

## fun builder_reserve

```mach
pub fun builder_reserve(b: *Builder, capacity: usize) R.Result[Reservation, str];
```

lock capacity for a child field without publishing parent length

## fun builder_commit

```mach
pub fun builder_commit(r: *Reservation) R.Result[usize, str];
```

publish the completed prefix of a reservation as one logical field

## fun reservation_rollback

```mach
pub fun reservation_rollback(r: *Reservation) R.Result[usize, str];
```

discard an unpublished reservation and unlock its parent

## rec Decoder

```mach
pub rec Decoder;
```

cursor over existing bytes with a fixed byte order

order: byte order for multi-byte reads
data: byte data
len: total length in bytes
pos: current read position

## def Cursor

```mach
pub def Cursor: Decoder
```

checked borrowed cursor, retained as an alias of Decoder for compatibility

## fun decoder

```mach
pub fun decoder(data: *u8, len: usize, order: Order) Decoder;
```

wrap existing bytes as a decoder positioned at offset 0

data: byte data
len: length in bytes
order: byte order for multi-byte reads
ret: a new Decoder

## fun cursor

```mach
pub fun cursor(data: *u8, len: usize, order: Order) Cursor;
```

wrap existing bytes as a checked cursor positioned at offset 0

## fun read_u8

```mach
pub fun read_u8(d: *Decoder) R.Result[u8, str];
```

read a u8 and advance

d: decoder to read from
ret: the value, or an error

## fun read_u16

```mach
pub fun read_u16(d: *Decoder) R.Result[u16, str];
```

read a u16 in the decoder's byte order and advance

d: decoder to read from
ret: the value, or an error

## fun read_u32

```mach
pub fun read_u32(d: *Decoder) R.Result[u32, str];
```

read a u32 in the decoder's byte order and advance

d: decoder to read from
ret: the value, or an error

## fun read_u64

```mach
pub fun read_u64(d: *Decoder) R.Result[u64, str];
```

read a u64 in the decoder's byte order and advance

d: decoder to read from
ret: the value, or an error

## fun read_bytes

```mach
pub fun read_bytes(d: *Decoder, len: usize) R.Result[*u8, str];
```

return a pointer to the next `len` bytes and advance past them

d: decoder to read from
len: number of bytes to consume
ret: pointer into the decoder's data, or an error

## fun read_str

```mach
pub fun read_str(d: *Decoder) R.Result[str, str];
```

read a null-terminated string and advance past the terminator

d: decoder to read from
ret: pointer to the string within the data, or an error

## fun skip

```mach
pub fun skip(d: *Decoder, n: usize) R.Result[usize, str];
```

advance the cursor by n bytes

d: decoder to advance
n: number of bytes to skip
ret: new position, or an error

## fun align_read

```mach
pub fun align_read(d: *Decoder, boundary: usize) R.Result[usize, str];
```

advance the cursor to an alignment boundary

d: decoder to align
boundary: alignment boundary (a power of two)
ret: new position, or an error

## fun read_subview

```mach
pub fun read_subview(d: *Decoder, len: usize) R.Result[Cursor, str];
```

return a bounded child cursor and advance only after validation

## fun cursor_checkpoint

```mach
pub fun cursor_checkpoint(d: *Decoder) R.Result[Checkpoint, str];
```

capture a cursor position for speculative decoding

## fun cursor_rollback

```mach
pub fun cursor_rollback(d: *Decoder, mark: Checkpoint) R.Result[usize, str];
```

restore an earlier cursor checkpoint

## fun remaining

```mach
pub fun remaining(d: *Decoder) usize;
```

bytes remaining between the cursor and the end

d: decoder to query
ret: unread byte count

