# crypto.hkdf

## val SHA256_PRK_SIZE

```mach
pub val SHA256_PRK_SIZE: usize = 32
```

## val SHA384_PRK_SIZE

```mach
pub val SHA384_PRK_SIZE: usize = 48
```

## val MAX_BLOCKS

```mach
pub val MAX_BLOCKS:      usize = 255
```

## val SHA256_MAX_OUTPUT

```mach
pub val SHA256_MAX_OUTPUT: usize = SHA256_PRK_SIZE * MAX_BLOCKS
```

## val SHA384_MAX_OUTPUT

```mach
pub val SHA384_MAX_OUTPUT: usize = SHA384_PRK_SIZE * MAX_BLOCKS
```

## def ExtractFun

```mach
pub def ExtractFun: fun(contracts.SecretBytes, contracts.SecretBytes, contracts.SecretBuffer) contracts.Operation
```

extract writes one pseudorandom key to secret output

## def ExpandFun

```mach
pub def ExpandFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.SecretBuffer) contracts.Operation
```

expand writes caller-sized secret key material

## fun extract_sha256

```mach
pub fun extract_sha256(salt: contracts.SecretBytes, ikm: contracts.SecretBytes,
output: contracts.SecretBuffer) contracts.Operation;
```

extract a sha-256 pseudorandom key

empty salt is the rfc-defined all-zero key. output may overlap salt or ikm
because the complete pseudorandom key is held locally until extraction ends.

## fun extract_sha384

```mach
pub fun extract_sha384(salt: contracts.SecretBytes, ikm: contracts.SecretBytes,
output: contracts.SecretBuffer) contracts.Operation;
```

extract a sha-384 pseudorandom key

empty salt is the rfc-defined all-zero key. output may overlap salt or ikm
because the complete pseudorandom key is held locally until extraction ends.

## fun expand_sha256

```mach
pub fun expand_sha256(prk: contracts.SecretBytes, info: contracts.Bytes,
output: contracts.SecretBuffer) contracts.Operation;
```

expand a sha-256 pseudorandom key into output.capacity bytes

zero length is valid. prk must be exactly 32 bytes. output may overlap prk
because expansion snapshots the complete pseudorandom key before writing.

## fun expand_sha384

```mach
pub fun expand_sha384(prk: contracts.SecretBytes, info: contracts.Bytes,
output: contracts.SecretBuffer) contracts.Operation;
```

expand a sha-384 pseudorandom key into output.capacity bytes

zero length is valid. prk must be exactly 48 bytes. output may overlap prk
because expansion snapshots the complete pseudorandom key before writing.

