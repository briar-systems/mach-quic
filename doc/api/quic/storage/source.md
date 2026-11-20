[quic](../README.md) / [storage](README.md) / **source**

# quic.storage.source

where connection storage comes from: a std buffer source, seen through one
connection's account

every chunk quic takes is at most BYTES long and charged to one of two lanes,
send or receive. tls charges the same account on a third lane of its own,
for chunks it takes through its lease. a refusal is backpressure: the account is registered with the
source and woken once chunks come back. this is the only module that calls the
source, so the rest of quic depends on the handful of operations below

Source: [`src/storage/source.mach`](../../../../src/storage/source.mach)

Uses types from [`quic.storage.limited`](limited.md).

| Type | | |
| :--- | :--- | :--- |
| [`Provider`](#provider) | `def` |  |
| [`SecretProvider`](#secretprovider) | `def` |  |
| [`Account`](#account) | `def` |  |
| [`Ref`](#ref) | `def` |  |
| [`Chunk`](#chunk) | `def` |  |
| [`Lane`](#lane) | `def` |  |
| [`Source`](#source) | `rec` | one connection's view of its provider, charged to one lane |
| [`SecretSource`](#secretsource) | `rec` | one connection's view of its provider's secret chunks, charged to one lane of the same account |
| [`Taken`](#taken) | `rec` |  |
| [`TestPool`](#testpool) | `rec` | a whole test pool and its provider, which must not move once made |

| On `Provider` | |
| :--- | :--- |
| [`open_connection`](#open_connection) | opens a connection's account with quic's budgets and reservation in chunks, tls's budget in bytes, and the caller's `extra_count` budgets on the lanes after quic's |
| [`open`](#open) | opens an account for quic's own chunks alone, with no tls lane and no caller lanes |
| [`source_lanes_of`](#source_lanes_of) | the lanes a source declares, 0 when it declares none |
| [`close`](#close) | |
| [`retain`](#retain) | a chunk is retained while bytes sealed from it are in flight |
| [`settle`](#settle), [`in_flight`](#in_flight) | |
| [`ready`](#ready) | the handles of accounts woken since the last call, oldest first |

| On `Account` | |
| :--- | :--- |
| [`held`](#held) | whole chunks the account holds on a lane |

| On `Lane` | |
| :--- | :--- |
| [`SEND`](#lane), [`RECEIVE`](#lane), [`TLS`](#lane) | |

| On `Source` | |
| :--- | :--- |
| [`take`](#take) | a chunk of at least `bytes`, registering the account for a wake on refusal |
| [`give`](#give) | gives a chunk back |

| On `SecretSource` | |
| :--- | :--- |
| [`take_secret`](#take_secret) | a secret chunk of at least `bytes`, registering the account for a wake on refusal |
| [`give_secret`](#give_secret) | wipes a secret chunk in full and gives it back |
| [`view_secret`](#view_secret) | a held secret chunk viewed as `count` values of T for the rest of its hold |

| On `TestPool` | |
| :--- | :--- |
| [`make_test`](#make_test) | |
| [`make_test_lanes`](#make_test_lanes) | as make_test, with `extra` caller lanes |
| [`test_made`](#test_made) | |

| Functions | |
| :--- | :--- |
| [`classes`](#classes) | the CLASS_COUNT classes a connection asks for, the plain ones smallest first |
| [`pool_config`](#pool_config) | a pool configuration over `class_count` classes with room for `bytes` across every account |
| [`pool_config_lanes`](#pool_config_lanes) | as pool_config, with `extra` caller lanes after quic's three |
| [`test_pool`](#test_pool) | a pool with room for `chunks` BYTES chunks and a few tls records over `memory`, for tests |
| [`test_pool_lanes`](#test_pool_lanes) | as test_pool, with `extra` caller lanes |
| [`misuse`](#misuse) | misuse a pool has refused so far |

| Constants | |
| :--- | :--- |
| [`BYTES`](#constants) | the largest request quic makes, and the unit budgets are counted in |
| [`LANES`](#constants) | |
| [`MAX_LANES`](#constants) | lanes a source can declare at most, and so how many a caller may add |
| [`MAX_EXTRA_LANES`](#constants) | |
| [`CLASS_COUNT`](#constants) | the chunk sizes a connection asks a source for: quic's BYTES, the sizes mach-tls requests for handshake messages and records, and a secret BYTES class for key material |
| [`SMALL`](#constants), [`RECORD`](#constants) | |

---

## Provider

```mach
pub def Provider:       std.memory.buffers.Source
```

### open_connection

```mach
pub fun open_connection(provider: *Provider, account: *Account, handle: u64,
    send: usize, receive: usize, tls: usize, reserve: usize,
    extra: *usize, extra_count: usize) bool
```

opens a connection's account with quic's budgets and reservation in chunks,
tls's budget in bytes, and the caller's `extra_count` budgets on the lanes
after quic's. it supplies exactly LANES + extra_count budgets, so it refuses
a source that does not declare exactly that many lanes, including one that
declares none, and a total above MAX_LANES. a wrapping source must forward
fn_lanes

### open

```mach
pub fun open(provider: *Provider, account: *Account, handle: u64, send: usize,
    receive: usize, reserve: usize) bool
```

opens an account for quic's own chunks alone, with no tls lane and no
caller lanes. it refuses a source that does not declare exactly LANES lanes,
as open_connection does

### source_lanes_of

```mach
pub fun source_lanes_of(provider: *Provider) usize
```

the lanes a source declares, 0 when it declares none

### close

```mach
pub fun close(provider: *Provider, account: *Account) bool
```

### retain

```mach
pub fun retain(provider: *Provider, ref: Ref) bool
```

a chunk is retained while bytes sealed from it are in flight

### settle

```mach
pub fun settle(provider: *Provider, ref: Ref) bool
```

### in_flight

```mach
pub fun in_flight(provider: *Provider, ref: Ref) bool
```

### ready

```mach
pub fun ready(provider: *Provider, output: *u64, capacity: usize) usize
```

the handles of accounts woken since the last call, oldest first

## SecretProvider

```mach
pub def SecretProvider: std.memory.buffers.SecretSource
```

## Account

```mach
pub def Account:        std.memory.buffers.Account
```

### held

```mach
pub fun held(account: *Account, lane: Lane) usize
```

whole chunks the account holds on a lane

## Ref

```mach
pub def Ref:            std.memory.buffers.Ref
```

## Chunk

```mach
pub def Chunk:          std.memory.buffers.Chunk
```

## Lane

```mach
pub def Lane: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `SEND` | `0` |  |
| `RECEIVE` | `1` |  |
| `TLS` | `2` |  |

## Source

```mach
pub rec Source {
    provider: *Provider;
    account:  *Account;
    lane:     Lane;
}
```

one connection's view of its provider, charged to one lane

### take

```mach
pub fun take(from: *Source, bytes: usize) Taken
```

a chunk of at least `bytes`, registering the account for a wake on refusal.
the source picks the smallest class that fits and charges what it hands out,
so budgets, which are bytes, stay exact

### give

```mach
pub fun give(from: *Source, chunk: Chunk) bool
```

gives a chunk back. a refused release leaves it held

## SecretSource

```mach
pub rec SecretSource {
    provider: *SecretProvider;
    account:  *Account;
    lane:     Lane;
}
```

one connection's view of its provider's secret chunks, charged to one lane
of the same account

### take_secret

```mach
pub fun take_secret(from: *SecretSource, bytes: usize) Taken
```

a secret chunk of at least `bytes`, registering the account for a wake on
refusal. its bytes are reached only through the provider's welded view

### give_secret

```mach
pub fun give_secret(from: *SecretSource, chunk: Chunk) bool
```

wipes a secret chunk in full and gives it back. a refused release leaves it
held

### view_secret

```mach
pub fun view_secret[T](from: *SecretSource, chunk: Chunk, count: usize) *T
```

a held secret chunk viewed as `count` values of T for the rest of its hold.
nil for a stale chunk, a shape that does not fit, or a provider without
typed views

## Taken

```mach
pub rec Taken {
    ok:    bool;
    chunk: Chunk;
}
```

## TestPool

```mach
pub rec TestPool {
    memory:   quic.storage.limited.Limited;
    pool:     std.memory.buffers.Pool;
    classes:  [CLASS_COUNT]std.memory.buffers.ClassConfig;
    provider: Provider;
    secret:   SecretProvider;
}
```

a whole test pool and its provider, which must not move once made

### make_test

```mach
pub fun make_test(fixture: *TestPool, chunks: usize) bool
```

### make_test_lanes

```mach
pub fun make_test_lanes(fixture: *TestPool, chunks: usize, extra: usize) bool
```

as make_test, with `extra` caller lanes

### test_made

```mach
pub fun test_made(fixture: *TestPool) bool
```

## Functions

### classes

```mach
pub fun classes(output: *std.memory.buffers.ClassConfig, high_water: usize)
```

the CLASS_COUNT classes a connection asks for, the plain ones smallest first

| Parameter | |
| :--- | :--- |
| `output` | CLASS_COUNT entries |
| `high_water` | released chunks each class keeps for reuse |

### pool_config

```mach
pub fun pool_config(classes: *std.memory.buffers.ClassConfig, class_count: usize,
    bytes: usize) std.memory.buffers.Config
```

a pool configuration over `class_count` classes with room for `bytes`
across every account

### pool_config_lanes

```mach
pub fun pool_config_lanes(classes: *std.memory.buffers.ClassConfig, class_count: usize,
    bytes: usize, extra: usize) std.memory.buffers.Config
```

as pool_config, with `extra` caller lanes after quic's three

### test_pool

```mach
pub fun test_pool(pool: *std.memory.buffers.Pool, configs: *std.memory.buffers.ClassConfig,
    memory: *quic.storage.limited.Limited, chunks: usize) bool
```

a pool with room for `chunks` BYTES chunks and a few tls records over
`memory`, for tests

| Parameter | |
| :--- | :--- |
| `configs` | CLASS_COUNT entries |

### test_pool_lanes

```mach
pub fun test_pool_lanes(pool: *std.memory.buffers.Pool, configs: *std.memory.buffers.ClassConfig,
    memory: *quic.storage.limited.Limited, chunks: usize, extra: usize) bool
```

as test_pool, with `extra` caller lanes

### misuse

```mach
pub fun misuse(pool: *std.memory.buffers.Pool) u64
```

misuse a pool has refused so far

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `BYTES` | `usize` | `4096` | the largest request quic makes, and the unit budgets are counted in |
| `LANES` | `u8` | `3` |  |
| `MAX_LANES` | `usize` | `buffers.MAX_LANES` | lanes a source can declare at most, and so how many a caller may add |
| `MAX_EXTRA_LANES` | `usize` | `buffers.MAX_LANES - LANES::usize` |  |
| `CLASS_COUNT` | `usize` | `4` | the chunk sizes a connection asks a source for: quic's BYTES, the sizes mach-tls requests for handshake messages and records, and a secret BYTES class for key material |
| `SMALL` | `usize` | `512` |  |
| `RECORD` | `usize` | `17408` |  |

