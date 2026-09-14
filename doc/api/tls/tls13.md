# tls.tls13

## def CipherSuite

```mach
pub def CipherSuite: u16
```

## def NamedGroup

```mach
pub def NamedGroup: u16
```

## def SignatureScheme

```mach
pub def SignatureScheme: u16
```

## val VERSION

```mach
pub val VERSION:        u16 = 0x0304
```

## val LEGACY_VERSION

```mach
pub val LEGACY_VERSION: u16 = 0x0303
```

## val AES_128_GCM_SHA256

```mach
pub val AES_128_GCM_SHA256:       CipherSuite = 0x1301
```

## val AES_256_GCM_SHA384

```mach
pub val AES_256_GCM_SHA384:       CipherSuite = 0x1302
```

## val CHACHA20_POLY1305_SHA256

```mach
pub val CHACHA20_POLY1305_SHA256: CipherSuite = 0x1303
```

## val SECP256R1

```mach
pub val SECP256R1: NamedGroup = 0x0017
```

## val X25519

```mach
pub val X25519:    NamedGroup = 0x001D
```

## val ECDSA_SECP256R1_SHA256

```mach
pub val ECDSA_SECP256R1_SHA256: SignatureScheme = 0x0403
```

## val ED25519

```mach
pub val ED25519:                 SignatureScheme = 0x0807
```

## val RSA_PSS_RSAE_SHA256

```mach
pub val RSA_PSS_RSAE_SHA256:    SignatureScheme = 0x0804
```

## val RSA_PSS_RSAE_SHA384

```mach
pub val RSA_PSS_RSAE_SHA384:    SignatureScheme = 0x0805
```

