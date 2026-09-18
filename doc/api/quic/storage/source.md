# quic.storage.source

## def Provider

```mach
pub def Provider: buffers.Source
```

## def Account

```mach
pub def Account:  buffers.Account
```

## def Ref

```mach
pub def Ref:      buffers.Ref
```

## def Chunk

```mach
pub def Chunk:    buffers.Chunk
```

## val BYTES

```mach
pub val BYTES: usize = 4096
```

the largest request quic makes, and the unit budgets are counted in

## def Lane

```mach
pub def Lane: u8
```

## val SEND

```mach
pub val SEND:    Lane = 0
```

## val RECEIVE

```mach
pub val RECEIVE: Lane = 1
```

## val TLS

```mach
pub val TLS:     Lane = 2
```

## val LANES

```mach
pub val LANES:   u8   = 3
```

## val MAX_LANES

```mach
pub val MAX_LANES:       usize = buffers.MAX_LANES
```

lanes a source can declare at most, and so how many a caller may add

## val MAX_EXTRA_LANES

```mach
pub val MAX_EXTRA_LANES: usize = buffers.MAX_LANES - LANES::usize
```

## val CLASS_COUNT

```mach
pub val CLASS_COUNT: usize = 3
```

the chunk sizes a connection asks a source for: quic's BYTES, and the sizes
mach-tls requests for handshake messages and records

## val SMALL

```mach
pub val SMALL:       usize = 512
```

## val RECORD

```mach
pub val RECORD:      usize = 17408
```

## rec Source

```mach
pub rec Source;
```

one connection's view of its provider, charged to one lane

## rec Taken

```mach
pub rec Taken;
```

## fun classes

```mach
pub fun classes(output: *buffers.ClassConfig, high_water: usize);
```

the CLASS_COUNT plain classes a connection asks for, smallest first

output: CLASS_COUNT entries
high_water: released chunks each class keeps for reuse

## fun pool_config

```mach
pub fun pool_config(classes: *buffers.ClassConfig, class_count: usize,
bytes: usize) buffers.Config;
```

a pool configuration over `class_count` classes with room for `bytes`
across every account

## fun pool_config_lanes

```mach
pub fun pool_config_lanes(classes: *buffers.ClassConfig, class_count: usize,
bytes: usize, extra: usize) buffers.Config;
```

as pool_config, with `extra` caller lanes after quic's three

## fun open_connection

```mach
pub fun open_connection(provider: *Provider, account: *Account, handle: u64,
send: usize, receive: usize, tls: usize, reserve: usize,
extra: *usize, extra_count: usize) bool;
```

opens a connection's account with quic's budgets and reservation in chunks,
tls's budget in bytes, and the caller's `extra_count` budgets on the lanes
after quic's. it supplies exactly LANES + extra_count budgets, so it refuses
a source that does not declare exactly that many lanes, including one that
declares none, and a total above MAX_LANES. a wrapping source must forward
fn_lanes

## fun open

```mach
pub fun open(provider: *Provider, account: *Account, handle: u64, send: usize,
receive: usize, reserve: usize) bool;
```

opens an account for quic's own chunks alone, with no tls lane and no
caller lanes. it refuses a source that does not declare exactly LANES lanes,
as open_connection does

## fun source_lanes_of

```mach
pub fun source_lanes_of(provider: *Provider) usize;
```

the lanes a source declares, 0 when it declares none

## fun close

```mach
pub fun close(provider: *Provider, account: *Account) bool;
```

## fun held

```mach
pub fun held(account: *Account, lane: Lane) usize;
```

whole chunks the account holds on a lane

## fun take

```mach
pub fun take(from: *Source, bytes: usize) Taken;
```

a chunk of at least `bytes`, registering the account for a wake on refusal.
the source picks the smallest class that fits and charges what it hands out,
so budgets, which are bytes, stay exact

## fun give

```mach
pub fun give(from: *Source, chunk: Chunk) bool;
```

gives a chunk back. a refused release leaves it held

## fun retain

```mach
pub fun retain(provider: *Provider, ref: Ref) bool;
```

a chunk is retained while bytes sealed from it are in flight

## fun settle

```mach
pub fun settle(provider: *Provider, ref: Ref) bool;
```

## fun in_flight

```mach
pub fun in_flight(provider: *Provider, ref: Ref) bool;
```

## fun ready

```mach
pub fun ready(provider: *Provider, output: *u64, capacity: usize) usize;
```

the handles of accounts woken since the last call, oldest first

## fun test_pool

```mach
pub fun test_pool(pool: *buffers.Pool, configs: *buffers.ClassConfig,
memory: *limited.Limited, chunks: usize) bool;
```

a pool with room for `chunks` BYTES chunks and a few tls records over
`memory`, for tests

configs: CLASS_COUNT entries

## fun test_pool_lanes

```mach
pub fun test_pool_lanes(pool: *buffers.Pool, configs: *buffers.ClassConfig,
memory: *limited.Limited, chunks: usize, extra: usize) bool;
```

as test_pool, with `extra` caller lanes

## rec TestPool

```mach
pub rec TestPool;
```

a whole test pool and its provider, which must not move once made

## fun make_test

```mach
pub fun make_test(fixture: *TestPool, chunks: usize) bool;
```

## fun make_test_lanes

```mach
pub fun make_test_lanes(fixture: *TestPool, chunks: usize, extra: usize) bool;
```

as make_test, with `extra` caller lanes

## fun test_made

```mach
pub fun test_made(fixture: *TestPool) bool;
```

## fun end_test

```mach
pub fun end_test(fixture: *TestPool) bool;
```

ends a test pool once every account on it is closed, keeping its memory for
the next make

## fun misuse

```mach
pub fun misuse(pool: *buffers.Pool) u64;
```

misuse a pool has refused so far

