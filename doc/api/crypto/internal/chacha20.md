# crypto.internal.chacha20

## val KEY_SIZE

```mach
pub val KEY_SIZE: usize = 32
```

## val NONCE_SIZE

```mach
pub val NONCE_SIZE: usize = 12
```

## val BLOCK_SIZE

```mach
pub val BLOCK_SIZE: usize = 64
```

## rec Context

```mach
pub rec Context;
```

## fun destroy

```mach
pub fun destroy(context: *Context);
```

## fun init

```mach
pub fun init(context: *Context, key: contracts.SecretBytes, nonce: contracts.Bytes) contracts.Error;
```

## fun block

```mach
pub fun block(context: *Context, counter: u32, output: *^u8);
```

