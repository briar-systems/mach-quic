# quic.connection.credentials_simulated

## val VERIFICATION_TIME

```mach
pub val VERIFICATION_TIME: i64 = 1800000000
```

## val ROOT_LENGTH

```mach
pub val ROOT_LENGTH: usize = 341
```

## val LEAF_LENGTH

```mach
pub val LEAF_LENGTH: usize = 393
```

## fun deterministic_entropy

```mach
pub fun deterministic_entropy(context: ptr, secret_context: *^u8,
destination: *^u8, length: usize) i64;
```

## fun load_credentials

```mach
pub fun load_credentials(identity: *credentials.Identity,
chain_storage: *cert.Certificate,
key: *keys.PrivateKey, owner: *secret.Allocator) bool;
```

an ed25519 chain for api.example.com valid from 2026-08-28 to 2027-08-28

## fun anchor

```mach
pub fun anchor() cert.Certificate;
```

the root the leaf chains to, for a client trust store

