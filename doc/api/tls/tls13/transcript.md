# tls.tls13.transcript

## def State

```mach
pub def State: u8
```

## val EMPTY

```mach
pub val EMPTY:     State = 0
```

## val ACTIVE

```mach
pub val ACTIVE:    State = 1
```

## val FINALIZED

```mach
pub val FINALIZED: State = 2
```

## val DESTROYED

```mach
pub val DESTROYED: State = 3
```

## val SHA256_MAX_BYTES

```mach
pub val SHA256_MAX_BYTES: u64 = 0x1fffffffffffffff
```

## rec Transcript

```mach
pub rec Transcript;
```

## fun empty

```mach
pub fun empty() Transcript;
```

## fun digest_size

```mach
pub fun digest_size(value: *Transcript) usize;
```

## fun init

```mach
pub fun init(value: *Transcript,
algorithm: key_schedule.HashAlgorithm) error.Error;
```

## fun init_for_suite

```mach
pub fun init_for_suite(value: *Transcript,
suite: tls13.CipherSuite) error.Error;
```

## fun update

```mach
pub fun update(value: *Transcript, input: contracts.Bytes) error.Error;
```

## fun update_frame

```mach
pub fun update_frame(value: *Transcript, encoded: contracts.Bytes) error.Error;
```

## fun update_binder_client_hello

```mach
pub fun update_binder_client_hello(value: *Transcript, encoded: contracts.Bytes,
after_retry: bool) error.Error;
```

use a dedicated transcript so the complete client hello can advance the main transcript

## fun snapshot

```mach
pub fun snapshot(value: *Transcript, output: contracts.Buffer) error.Error;
```

## fun final

```mach
pub fun final(value: *Transcript, output: contracts.Buffer) error.Error;
```

## fun rewrite_for_retry

```mach
pub fun rewrite_for_retry(value: *Transcript,
hello_retry_request: contracts.Bytes) error.Error;
```

## fun destroy

```mach
pub fun destroy(value: *Transcript);
```

