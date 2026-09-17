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

## val LANES

```mach
pub val LANES:   u8   = 2
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

## fun chunk_class

```mach
pub fun chunk_class(high_water: usize) buffers.ClassConfig;
```

one class of BYTES chunks, enough for everything quic asks for

high_water: released chunks the pool keeps for reuse

## fun pool_config

```mach
pub fun pool_config(classes: *buffers.ClassConfig, class_count: usize,
chunks: usize) buffers.Config;
```

a pool configuration over `class_count` classes with room for `chunks`
chunks of BYTES across every account

## fun open

```mach
pub fun open(provider: *Provider, account: *Account, handle: u64, send: usize,
receive: usize, reserve: usize) bool;
```

opens a connection's account with budgets and a reservation in chunks

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

a chunk of at least `bytes`, registering the account for a wake on refusal

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
pub fun test_pool(pool: *buffers.Pool, class: *buffers.ClassConfig,
memory: *limited.Limited, chunks: usize) bool;
```

a pool of `chunks` BYTES chunks over `memory`, for tests

## rec TestPool

```mach
pub rec TestPool;
```

a whole test pool and its provider, which must not move once made

## fun make_test

```mach
pub fun make_test(fixture: *TestPool, chunks: usize) bool;
```

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

