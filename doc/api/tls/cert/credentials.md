# tls.cert.credentials

## val NO_DEFAULT

```mach
pub val NO_DEFAULT: usize = 0 - 1
```

## rec Identity

```mach
pub rec Identity;
```

## rec Generation

```mach
pub rec Generation;
```

copying a generation duplicates synchronization state and is invalid

## rec Store

```mach
pub rec Store;
```

## rec Lease

```mach
pub rec Lease;
```

a lease must be released before its generation storage is reclaimed

## fun empty_generation

```mach
pub fun empty_generation() Generation;
```

## fun empty_store

```mach
pub fun empty_store() Store;
```

## fun empty_lease

```mach
pub fun empty_lease() Lease;
```

## fun key_matches

```mach
pub fun key_matches(chain: *cert.Chain, private_key: *keys.PrivateKey) bool;
```

## fun initialize

```mach
pub fun initialize(value: *Generation, identities: *Identity,
identity_len: usize, default_index: usize, client_trust: *cert.TrustStore,
require_client_auth: bool) contracts.Error;
```

## fun initialize_store

```mach
pub fun initialize_store(value: *Store,
initial: *Generation) contracts.Error;
```

## fun acquire

```mach
pub fun acquire(value: *Store, server_name: contracts.Bytes,
output: *Lease) contracts.Error;
```

## fun acquire_client_trust

```mach
pub fun acquire_client_trust(value: *Store, output: *Lease,
trust: **cert.TrustStore, required: *bool) contracts.Error;
```

## fun release

```mach
pub fun release(value: *Lease) contracts.Error;
```

## fun rotate

```mach
pub fun rotate(value: *Store, replacement: *Generation,
retired: **Generation) contracts.Error;
```

## fun retire_store

```mach
pub fun retire_store(value: *Store,
retired: **Generation) contracts.Error;
```

## fun reclaimable

```mach
pub fun reclaimable(value: *Generation) bool;
```

## fun clear

```mach
pub fun clear(value: *Generation) contracts.Error;
```

