# crypto.hash

## val SHA256_DIGEST_SIZE

```mach
pub val SHA256_DIGEST_SIZE: usize = 32
```

## val SHA384_DIGEST_SIZE

```mach
pub val SHA384_DIGEST_SIZE: usize = 48
```

## def State

```mach
pub def State: u8
```

## val EMPTY

```mach
pub val EMPTY:  State = 0
```

## val ACTIVE

```mach
pub val ACTIVE: State = 1
```

## rec Sha256

```mach
pub rec Sha256;
```

callers treat state records as opaque and do not copy them directly

## rec Sha384

```mach
pub rec Sha384;
```

## fun empty_sha256

```mach
pub fun empty_sha256() Sha256;
```

## fun empty_sha384

```mach
pub fun empty_sha384() Sha384;
```

## fun init_sha256

```mach
pub fun init_sha256(context: *Sha256) contracts.Error;
```

## fun init_sha384

```mach
pub fun init_sha384(context: *Sha384) contracts.Error;
```

## fun update_sha256

```mach
pub fun update_sha256(context: *Sha256, input: contracts.Bytes) contracts.Error;
```

## fun update_sha384

```mach
pub fun update_sha384(context: *Sha384, input: contracts.Bytes) contracts.Error;
```

## fun snapshot_sha256

```mach
pub fun snapshot_sha256(context: *Sha256,
output: contracts.Buffer) contracts.Operation;
```

## fun snapshot_sha384

```mach
pub fun snapshot_sha384(context: *Sha384,
output: contracts.Buffer) contracts.Operation;
```

## fun final_sha256

```mach
pub fun final_sha256(context: *Sha256,
output: contracts.Buffer) contracts.Operation;
```

## fun final_sha384

```mach
pub fun final_sha384(context: *Sha384,
output: contracts.Buffer) contracts.Operation;
```

## fun destroy_sha256

```mach
pub fun destroy_sha256(context: *Sha256) contracts.Error;
```

## fun destroy_sha384

```mach
pub fun destroy_sha384(context: *Sha384) contracts.Error;
```

