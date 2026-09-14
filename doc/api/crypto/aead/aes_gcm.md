# crypto.aead.aes_gcm

## val AES128_KEY_SIZE

```mach
pub val AES128_KEY_SIZE: usize = 16
```

## val AES256_KEY_SIZE

```mach
pub val AES256_KEY_SIZE: usize = 32
```

## val NONCE_SIZE

```mach
pub val NONCE_SIZE:      usize = 12
```

## val TAG_SIZE

```mach
pub val TAG_SIZE:        usize = 16
```

## val MAX_PLAINTEXT_SIZE

```mach
pub val MAX_PLAINTEXT_SIZE: usize = 68719476704
```

## val MAX_AAD_SIZE

```mach
pub val MAX_AAD_SIZE: usize = 2305843009213693951
```

## def SealFun

```mach
pub def SealFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Bytes,
contracts.SecretBytes, contracts.Buffer) contracts.Operation
```

seal writes ciphertext followed by the complete tag

## def OpenFun

```mach
pub def OpenFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Bytes,
contracts.Bytes, contracts.SecretBuffer) contracts.Operation
```

open authenticates the complete input before releasing secret plaintext

## fun seal

```mach
pub fun seal(key: contracts.SecretBytes, nonce: contracts.Bytes, aad: contracts.Bytes,
plaintext: contracts.SecretBytes, output: contracts.Buffer) contracts.Operation;
```

encrypt and authenticate one tls or quic record payload

nonce must be exactly 12 bytes. output capacity must cover plaintext plus the
16-byte tag. aad and nonce may overlap output because both are consumed before
the first output write. secret and public buffers cannot alias by contract.

## fun open

```mach
pub fun open(key: contracts.SecretBytes, nonce: contracts.Bytes, aad: contracts.Bytes,
input: contracts.Bytes, output: contracts.SecretBuffer) contracts.Operation;
```

authenticate and decrypt one tls or quic record payload

input is ciphertext followed by a complete 16-byte tag. authentication occurs
before any decryption. authentication failure writes no plaintext and clears
exactly the ciphertext-length prefix of output. successful output may overlap
the secret key because the expanded key schedule is snapshotted first.

