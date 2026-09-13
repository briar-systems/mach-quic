# crypto.signature

## def Algorithm

```mach
pub def Algorithm: u16
```

## val ECDSA_P256_SHA256

```mach
pub val ECDSA_P256_SHA256: Algorithm = 0x0403
```

## val ED25519

```mach
pub val ED25519:           Algorithm = 0x0807
```

## val RSA_PKCS1_SHA256

```mach
pub val RSA_PKCS1_SHA256:  Algorithm = 0x0401
```

## val RSA_PKCS1_SHA384

```mach
pub val RSA_PKCS1_SHA384:  Algorithm = 0x0501
```

## val RSA_PSS_RSAE_SHA256

```mach
pub val RSA_PSS_RSAE_SHA256: Algorithm = 0x0804
```

## val RSA_PSS_RSAE_SHA384

```mach
pub val RSA_PSS_RSAE_SHA384: Algorithm = 0x0805
```

## fun algorithm_status

```mach
pub fun algorithm_status(algorithm: Algorithm) contracts.Error;
```

## val ECDSA_P256_PRIVATE_KEY_SIZE

```mach
pub val ECDSA_P256_PRIVATE_KEY_SIZE: usize = 32
```

## val ECDSA_P256_PUBLIC_KEY_SIZE

```mach
pub val ECDSA_P256_PUBLIC_KEY_SIZE: usize = 65
```

## val ECDSA_P256_SIGNATURE_MIN_SIZE

```mach
pub val ECDSA_P256_SIGNATURE_MIN_SIZE: usize = 8
```

## val ECDSA_P256_SIGNATURE_MAX_SIZE

```mach
pub val ECDSA_P256_SIGNATURE_MAX_SIZE: usize = 72
```

## val ED25519_PRIVATE_KEY_SIZE

```mach
pub val ED25519_PRIVATE_KEY_SIZE: usize = 32
```

## val ED25519_PUBLIC_KEY_SIZE

```mach
pub val ED25519_PUBLIC_KEY_SIZE: usize = 32
```

## val ED25519_SIGNATURE_SIZE

```mach
pub val ED25519_SIGNATURE_SIZE: usize = 64
```

## val RSA_MIN_MODULUS_SIZE

```mach
pub val RSA_MIN_MODULUS_SIZE: usize = rsa.MIN_MODULUS_BYTES
```

## val RSA_MAX_MODULUS_SIZE

```mach
pub val RSA_MAX_MODULUS_SIZE: usize = rsa.MAX_MODULUS_BYTES
```

## val RSA_PSS_SHA256_SALT_SIZE

```mach
pub val RSA_PSS_SHA256_SALT_SIZE: usize = 32
```

## val RSA_PSS_SHA384_SALT_SIZE

```mach
pub val RSA_PSS_SHA384_SALT_SIZE: usize = 48
```

## rec RsaPublicKey

```mach
pub rec RsaPublicKey;
```

## rec RsaPrivateKey

```mach
pub rec RsaPrivateKey;
```

## def VerifyFun

```mach
pub def VerifyFun: fun(contracts.Bytes, contracts.Bytes, contracts.Bytes) contracts.Error
```

verification returns auth_failed for an invalid signature

## def SignFun

```mach
pub def SignFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Buffer) contracts.Operation
```

signing writes a wire-format signature with explicit capacity

## fun derive_ed25519_public

```mach
pub fun derive_ed25519_public(private_key: contracts.SecretBytes,
output: contracts.Buffer) contracts.Operation;
```

derive the rfc 8032 public key from a 32-byte private seed

## fun sign_ed25519

```mach
pub fun sign_ed25519(private_key: contracts.SecretBytes, message: contracts.Bytes,
output: contracts.Buffer) contracts.Operation;
```

sign the exact message with rfc 8032 ed25519

## fun verify_ed25519

```mach
pub fun verify_ed25519(public_key: contracts.Bytes, message: contracts.Bytes,
signature_bytes: contracts.Bytes) contracts.Error;
```

verify strict prime-subgroup rfc 8032 ed25519

## fun sign_rsa_pss_sha256

```mach
pub fun sign_rsa_pss_sha256(private_key: RsaPrivateKey, message: contracts.Bytes,
salt: contracts.SecretBytes, output: contracts.Buffer) contracts.Operation;
```

sign rsa-pss with an exact 32-byte caller-provided salt

## fun sign_rsa_pss_sha384

```mach
pub fun sign_rsa_pss_sha384(private_key: RsaPrivateKey, message: contracts.Bytes,
salt: contracts.SecretBytes, output: contracts.Buffer) contracts.Operation;
```

sign rsa-pss with an exact 48-byte caller-provided salt

## fun verify_rsa_pss_sha256

```mach
pub fun verify_rsa_pss_sha256(public_key: RsaPublicKey, message: contracts.Bytes,
signature_bytes: contracts.Bytes) contracts.Error;
```

## fun verify_rsa_pss_sha384

```mach
pub fun verify_rsa_pss_sha384(public_key: RsaPublicKey, message: contracts.Bytes,
signature_bytes: contracts.Bytes) contracts.Error;
```

## fun verify_rsa_pkcs1_sha256

```mach
pub fun verify_rsa_pkcs1_sha256(public_key: RsaPublicKey,
message: contracts.Bytes, signature_bytes: contracts.Bytes) contracts.Error;
```

verify exact rfc 8017 emsa-pkcs1-v1_5 with sha-256

## fun verify_rsa_pkcs1_sha384

```mach
pub fun verify_rsa_pkcs1_sha384(public_key: RsaPublicKey,
message: contracts.Bytes, signature_bytes: contracts.Bytes) contracts.Error;
```

verify exact rfc 8017 emsa-pkcs1-v1_5 with sha-384

## fun sign_ecdsa_p256_sha256

```mach
pub fun sign_ecdsa_p256_sha256(private_key: contracts.SecretBytes,
message: contracts.Bytes, output: contracts.Buffer) contracts.Operation;
```

sign sha-256(message) with a canonical p-256 scalar and rfc 6979 nonce

the signature is strict der. all failures leave output unchanged.

## fun verify_ecdsa_p256_sha256

```mach
pub fun verify_ecdsa_p256_sha256(public_key: contracts.Bytes,
message: contracts.Bytes, signature: contracts.Bytes) contracts.Error;
```

verify a strict der p-256 signature over sha-256(message)

