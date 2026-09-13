# tls.tls13.key_schedule

## def HashAlgorithm

```mach
pub def HashAlgorithm: u8
```

## def Stage

```mach
pub def Stage: u8
```

## val SHA256

```mach
pub val SHA256: HashAlgorithm = 1
```

## val SHA384

```mach
pub val SHA384: HashAlgorithm = 2
```

## val EMPTY

```mach
pub val EMPTY:       Stage = 0
```

## val EARLY

```mach
pub val EARLY:       Stage = 1
```

## val HANDSHAKE

```mach
pub val HANDSHAKE:   Stage = 2
```

## val APPLICATION

```mach
pub val APPLICATION: Stage = 3
```

## val DESTROYED

```mach
pub val DESTROYED:   Stage = 4
```

## val MAX_HASH_SIZE

```mach
pub val MAX_HASH_SIZE: usize = 48
```

## val IV_SIZE

```mach
pub val IV_SIZE: usize = 12
```

## val LABEL_PREFIX_SIZE

```mach
pub val LABEL_PREFIX_SIZE: usize = 6
```

## val MAX_LABEL_SIZE

```mach
pub val MAX_LABEL_SIZE: usize = 249
```

## val MAX_CONTEXT_SIZE

```mach
pub val MAX_CONTEXT_SIZE: usize = 255
```

## val MAX_INFO_SIZE

```mach
pub val MAX_INFO_SIZE: usize = 2 + 1 + 255 + 1 + 255
```

## rec Secret

```mach
pub rec Secret;
```

## rec Schedule

```mach
pub rec Schedule;
```

## fun algorithm_for_suite

```mach
pub fun algorithm_for_suite(suite: tls13.CipherSuite) HashAlgorithm;
```

## fun hash_size

```mach
pub fun hash_size(algorithm: HashAlgorithm) usize;
```

## fun key_size

```mach
pub fun key_size(suite: tls13.CipherSuite) usize;
```

## fun bytes

```mach
pub fun bytes(value: *Secret) contracts.SecretBytes;
```

## fun expand_label

```mach
pub fun expand_label(algorithm: HashAlgorithm, secret: contracts.SecretBytes,
label: contracts.Bytes, context: contracts.Bytes,
output: contracts.SecretBuffer) error.Error;
```

expand one tls 1.3 label into output.capacity secret bytes

## fun init

```mach
pub fun init(schedule: *Schedule, suite: tls13.CipherSuite,
psk: contracts.SecretBytes) error.Error;
```

## fun derive_early_traffic

```mach
pub fun derive_early_traffic(schedule: *Schedule,
client_hello_hash: contracts.Bytes) error.Error;
```

## fun binder

```mach
pub fun binder(schedule: *Schedule, resumption: bool,
transcript_hash: contracts.Bytes, output: contracts.Buffer) error.Error;
```

## fun advance_handshake

```mach
pub fun advance_handshake(schedule: *Schedule, shared_secret: contracts.SecretBytes,
transcript_hash: contracts.Bytes) error.Error;
```

## fun advance_application

```mach
pub fun advance_application(schedule: *Schedule,
server_finished_hash: contracts.Bytes) error.Error;
```

## fun derive_resumption

```mach
pub fun derive_resumption(schedule: *Schedule,
client_finished_hash: contracts.Bytes) error.Error;
```

## fun finished_key

```mach
pub fun finished_key(schedule: *Schedule, base: *Secret,
output: contracts.SecretBuffer) error.Error;
```

## fun finished

```mach
pub fun finished(schedule: *Schedule, base: *Secret,
transcript_hash: contracts.Bytes, output: contracts.Buffer) error.Error;
```

## fun verify_finished

```mach
pub fun verify_finished(schedule: *Schedule, base: *Secret,
transcript_hash: contracts.Bytes, received: contracts.Bytes) error.Error;
```

## fun traffic_key

```mach
pub fun traffic_key(schedule: *Schedule, traffic_secret: *Secret,
output: contracts.SecretBuffer) error.Error;
```

## fun traffic_iv

```mach
pub fun traffic_iv(schedule: *Schedule, traffic_secret: *Secret,
output: contracts.Buffer) error.Error;
```

## fun update_traffic

```mach
pub fun update_traffic(schedule: *Schedule, traffic_secret: *Secret) error.Error;
```

## fun resumption_psk

```mach
pub fun resumption_psk(schedule: *Schedule, ticket_nonce: contracts.Bytes,
output: contracts.SecretBuffer) error.Error;
```

## fun export_keying_material

```mach
pub fun export_keying_material(schedule: *Schedule, label: contracts.Bytes,
context_hash: contracts.Bytes, output: contracts.SecretBuffer) error.Error;
```

## fun discard_handshake

```mach
pub fun discard_handshake(schedule: *Schedule) error.Error;
```

## fun destroy

```mach
pub fun destroy(schedule: *Schedule);
```

