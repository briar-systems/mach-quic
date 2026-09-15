# quic.storage.hash

## rec Key

```mach
pub rec Key;
```

## fun random_key

```mach
pub fun random_key() opt[Key];
```

draws a key from the operating system entropy source

## fun bytes

```mach
pub fun bytes(key: Key, data: *u8, length: usize) u64;
```

