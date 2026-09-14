# crypto.internal.hmac

## rec Context256

```mach
pub rec Context256;
```

## rec Context384

```mach
pub rec Context384;
```

## fun destroy256

```mach
pub fun destroy256(context: *Context256);
```

## fun destroy384

```mach
pub fun destroy384(context: *Context384);
```

## fun init256

```mach
pub fun init256(context: *Context256, key: contracts.SecretBytes) contracts.Error;
```

## fun init384

```mach
pub fun init384(context: *Context384, key: contracts.SecretBytes) contracts.Error;
```

## fun update256_public

```mach
pub fun update256_public(context: *Context256, data: *u8, len: usize) contracts.Error;
```

## fun update256_secret

```mach
pub fun update256_secret(context: *Context256, data: *^u8, len: usize) contracts.Error;
```

## fun update384_public

```mach
pub fun update384_public(context: *Context384, data: *u8, len: usize) contracts.Error;
```

## fun update384_secret

```mach
pub fun update384_secret(context: *Context384, data: *^u8, len: usize) contracts.Error;
```

## fun final256

```mach
pub fun final256(context: *Context256, tag: *^u8) contracts.Error;
```

## fun final384

```mach
pub fun final384(context: *Context384, tag: *^u8) contracts.Error;
```

