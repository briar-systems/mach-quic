# crypto.hmac

## val SHA256_BLOCK_SIZE

```mach
pub val SHA256_BLOCK_SIZE: usize = 64
```

## val SHA256_TAG_SIZE

```mach
pub val SHA256_TAG_SIZE:   usize = 32
```

## val SHA384_BLOCK_SIZE

```mach
pub val SHA384_BLOCK_SIZE: usize = 128
```

## val SHA384_TAG_SIZE

```mach
pub val SHA384_TAG_SIZE:   usize = 48
```

## def MacFun

```mach
pub def MacFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Buffer) contracts.Operation
```

one-shot hmac callback with a secret key and public message

## fun sha256

```mach
pub fun sha256(key: contracts.SecretBytes, message: contracts.Bytes,
output: contracts.Buffer) contracts.Operation;
```

authenticate a public message with hmac-sha-256

the output may overlap the message because it is written only after the
complete tag exists. a nonempty public output cannot alias the secret key.

## fun sha384

```mach
pub fun sha384(key: contracts.SecretBytes, message: contracts.Bytes,
output: contracts.Buffer) contracts.Operation;
```

authenticate a public message with hmac-sha-384

the output may overlap the message because it is written only after the
complete tag exists. a nonempty public output cannot alias the secret key.

