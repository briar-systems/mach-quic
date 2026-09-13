# crypto.internal.sha2

## val SHA256_BLOCK_SIZE

```mach
pub val SHA256_BLOCK_SIZE: usize = 64
```

## val SHA256_DIGEST_SIZE

```mach
pub val SHA256_DIGEST_SIZE: usize = 32
```

## val SHA384_BLOCK_SIZE

```mach
pub val SHA384_BLOCK_SIZE: usize = 128
```

## val SHA384_DIGEST_SIZE

```mach
pub val SHA384_DIGEST_SIZE: usize = 48
```

## val SHA512_DIGEST_SIZE

```mach
pub val SHA512_DIGEST_SIZE: usize = 64
```

## val SHA256_MAX_BYTES

```mach
pub val SHA256_MAX_BYTES: u64 = 0x1FFFFFFFFFFFFFFF
```

## val SHA384_MAX_BYTES

```mach
pub val SHA384_MAX_BYTES: u64 = 0xFFFFFFFFFFFFFFFF
```

## val SHA512_MAX_BYTES

```mach
pub val SHA512_MAX_BYTES: u64 = SHA384_MAX_BYTES
```

## rec State256

```mach
pub rec State256;
```

## rec State384

```mach
pub rec State384;
```

## fun init256

```mach
pub fun init256(state: *State256);
```

## fun init384

```mach
pub fun init384(state: *State384);
```

## fun init512

```mach
pub fun init512(state: *State384);
```

## fun update256_public

```mach
pub fun update256_public(state: *State256, data: *u8, len: usize) bool;
```

## fun update256_secret

```mach
pub fun update256_secret(state: *State256, data: *^u8, len: usize) bool;
```

## fun update384_public

```mach
pub fun update384_public(state: *State384, data: *u8, len: usize) bool;
```

## fun update384_secret

```mach
pub fun update384_secret(state: *State384, data: *^u8, len: usize) bool;
```

## fun update512_public

```mach
pub fun update512_public(state: *State384, data: *u8, len: usize) bool;
```

## fun update512_secret

```mach
pub fun update512_secret(state: *State384, data: *^u8, len: usize) bool;
```

## fun final256

```mach
pub fun final256(state: *State256, digest: *^u8);
```

## fun final384

```mach
pub fun final384(state: *State384, digest: *^u8);
```

## fun final512

```mach
pub fun final512(state: *State384, digest: *^u8);
```

## fun destroy256

```mach
pub fun destroy256(state: *State256);
```

## fun destroy384

```mach
pub fun destroy384(state: *State384);
```

## fun destroy512

```mach
pub fun destroy512(state: *State384);
```

