# crypto.internal.aes

## val BLOCK_SIZE

```mach
pub val BLOCK_SIZE: usize = 16
```

## val AES128_KEY_SIZE

```mach
pub val AES128_KEY_SIZE: usize = 16
```

## val AES256_KEY_SIZE

```mach
pub val AES256_KEY_SIZE: usize = 32
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
pub fun init(context: *Context, key: contracts.SecretBytes) contracts.Error;
```

## fun encrypt

```mach
pub fun encrypt(context: *Context, input: *^u8, output: *^u8);
```

