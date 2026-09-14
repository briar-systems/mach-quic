# tls.validation

## val MAX_CORPUS

```mach
pub val MAX_CORPUS: usize = 4096
```

## def Mutation

```mach
pub def Mutation: u8
```

## val FLIP_BIT

```mach
pub val FLIP_BIT: Mutation = 0
```

## val SET_BYTE

```mach
pub val SET_BYTE: Mutation = 1
```

## val TRUNCATE

```mach
pub val TRUNCATE: Mutation = 2
```

## val EXTEND

```mach
pub val EXTEND: Mutation = 3
```

## val SWAP

```mach
pub val SWAP: Mutation = 4
```

## val ZERO_RUN

```mach
pub val ZERO_RUN: Mutation = 5
```

## val MUTATION_KINDS

```mach
pub val MUTATION_KINDS: usize = 6
```

## fun advance

```mach
pub fun advance(state: u64) u64;
```

one reproducible pseudorandom sequence; the corpus must be replayable

## fun mutate

```mach
pub fun mutate(state: *u64, buffer: *u8, length: usize,
capacity: usize) usize;
```

apply exactly one mutation and report the resulting length

