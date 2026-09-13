# tls.memory_range

## fun valid_address

```mach
pub fun valid_address(address: usize, len: usize) bool;
```

## fun valid

```mach
pub fun valid(data: *u8, len: usize) bool;
```

## fun scaled

```mach
pub fun scaled(count: usize, item_size: usize, output: *usize) bool;
```

## fun overlap_addresses

```mach
pub fun overlap_addresses(first: usize, first_len: usize, second: usize,
second_len: usize) bool;
```

## fun overlap

```mach
pub fun overlap(first: *u8, first_len: usize, second: *u8,
second_len: usize) bool;
```

