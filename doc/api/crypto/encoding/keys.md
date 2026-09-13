# crypto.encoding.keys

## def Algorithm

```mach
pub def Algorithm: u8
```

## val ED25519

```mach
pub val ED25519: Algorithm = 1
```

## val X25519

```mach
pub val X25519:  Algorithm = 2
```

## val P256

```mach
pub val P256:    Algorithm = 3
```

## val RSA

```mach
pub val RSA:     Algorithm = 4
```

## def Container

```mach
pub def Container: u8
```

## val PKCS8

```mach
pub val PKCS8:       Container = 1
```

## val SEC1

```mach
pub val SEC1:        Container = 2
```

## val RSA_PRIVATE

```mach
pub val RSA_PRIVATE: Container = 3
```

## val SPKI

```mach
pub val SPKI:        Container = 4
```

## rec PublicKey

```mach
pub rec PublicKey;
```

## rec PrivateKey

```mach
pub rec PrivateKey;
```

copying this record duplicates ownership and is invalid

## fun empty_private

```mach
pub fun empty_private() PrivateKey;
```

## fun destroy_private

```mach
pub fun destroy_private(key: *PrivateKey) contracts.Error;
```

## fun decode_spki

```mach
pub fun decode_spki(input: contracts.Bytes, output: *PublicKey) contracts.Error;
```

## fun decode_pkcs8

```mach
pub fun decode_pkcs8(input: contracts.SecretBytes, owner: *secret.Allocator,
output: *PrivateKey) contracts.Error;
```

## fun decode_sec1

```mach
pub fun decode_sec1(input: contracts.SecretBytes, owner: *secret.Allocator,
output: *PrivateKey) contracts.Error;
```

## fun decode_rsa_private

```mach
pub fun decode_rsa_private(input: contracts.SecretBytes, owner: *secret.Allocator,
output: *PrivateKey) contracts.Error;
```

## fun private_bytes

```mach
pub fun private_bytes(key: *PrivateKey,
output: *contracts.SecretBytes) contracts.Error;
```

## fun copy_rsa

```mach
pub fun copy_rsa(key: *PrivateKey, modulus: contracts.Buffer,
exponent: contracts.Buffer, private_exponent: contracts.SecretBuffer) contracts.Error;
```

## fun encode_public_der

```mach
pub fun encode_public_der(key: *PublicKey,
output: contracts.Buffer) contracts.Operation;
```

## fun encode_private_der

```mach
pub fun encode_private_der(key: *PrivateKey,
output: contracts.SecretBuffer) contracts.Operation;
```

## fun decode_private_pem

```mach
pub fun decode_private_pem(input: contracts.SecretBytes, owner: *secret.Allocator,
output: *PrivateKey) contracts.Error;
```

## fun decode_public_pem

```mach
pub fun decode_public_pem(input: contracts.Bytes, der_output: contracts.Buffer,
output: *PublicKey) contracts.Error;
```

## fun encode_public_pem

```mach
pub fun encode_public_pem(key: *PublicKey,
output: contracts.Buffer) contracts.Operation;
```

## fun encode_private_pem

```mach
pub fun encode_private_pem(key: *PrivateKey,
output: contracts.SecretBuffer) contracts.Operation;
```

