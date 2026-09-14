# tls.tls12

## val VERSION

```mach
pub val VERSION: u16 = 0x0303
```

## val ECDHE_ECDSA_AES_128_GCM_SHA256

```mach
pub val ECDHE_ECDSA_AES_128_GCM_SHA256: u16 = 0xC02B
```

## val ECDHE_RSA_AES_128_GCM_SHA256

```mach
pub val ECDHE_RSA_AES_128_GCM_SHA256:   u16 = 0xC02F
```

## val ECDHE_ECDSA_AES_256_GCM_SHA384

```mach
pub val ECDHE_ECDSA_AES_256_GCM_SHA384: u16 = 0xC02C
```

## val ECDHE_RSA_AES_256_GCM_SHA384

```mach
pub val ECDHE_RSA_AES_256_GCM_SHA384:   u16 = 0xC030
```

## val ECDHE_RSA_CHACHA20_POLY1305

```mach
pub val ECDHE_RSA_CHACHA20_POLY1305:    u16 = 0xCCA8
```

## val ECDHE_ECDSA_CHACHA20_POLY1305

```mach
pub val ECDHE_ECDSA_CHACHA20_POLY1305:  u16 = 0xCCA9
```

## val EMPTY_RENEGOTIATION_INFO_SCSV

```mach
pub val EMPTY_RENEGOTIATION_INFO_SCSV: u16 = 0x00FF
```

the signalling value a client sends to say it is not renegotiating

## val FALLBACK_SCSV

```mach
pub val FALLBACK_SCSV: u16 = 0x5600
```

the value a client sends when it deliberately offers less than it supports

## val MAX_PLAINTEXT

```mach
pub val MAX_PLAINTEXT: usize = 16384
```

## val VERIFY_DATA_SIZE

```mach
pub val VERIFY_DATA_SIZE: usize = 12
```

## val MASTER_SECRET_SIZE

```mach
pub val MASTER_SECRET_SIZE: usize = 48
```

## val DOWNGRADE_TLS12

```mach
pub val DOWNGRADE_TLS12: [8]u8 = [8]u8;
```

the last eight bytes a tls 1.3 capable server writes into its random when it
negotiates a lower version, so a downgraded client can notice

## val DOWNGRADE_TLS11

```mach
pub val DOWNGRADE_TLS11: [8]u8 = [8]u8;
```

## fun valid_suite

```mach
pub fun valid_suite(suite: u16) bool;
```

## fun suite_hash

```mach
pub fun suite_hash(suite: u16) key_schedule.HashAlgorithm;
```

## fun suite_key_size

```mach
pub fun suite_key_size(suite: u16) usize;
```

## fun suite_iv_size

```mach
pub fun suite_iv_size(suite: u16) usize;
```

gcm carries an explicit per-record nonce, so only four bytes are derived

## fun suite_aead

```mach
pub fun suite_aead(suite: u16) record.Algorithm;
```

## fun suite_requires_ecdsa

```mach
pub fun suite_requires_ecdsa(suite: u16) bool;
```

an ecdsa suite authenticates with an ecdsa or eddsa certificate

