# crypto.contracts

## def Error

```mach
pub def Error: u8
```

## val OK

```mach
pub val OK:                 Error = 0
```

## val INVALID_INPUT

```mach
pub val INVALID_INPUT:      Error = 1
```

## val OUTPUT_TOO_SMALL

```mach
pub val OUTPUT_TOO_SMALL:   Error = 2
```

## val INVALID_KEY

```mach
pub val INVALID_KEY:        Error = 3
```

## val AUTH_FAILED

```mach
pub val AUTH_FAILED:        Error = 4
```

## val UNSUPPORTED

```mach
pub val UNSUPPORTED:        Error = 5
```

## val ENTROPY_UNAVAILABLE

```mach
pub val ENTROPY_UNAVAILABLE: Error = 6
```

## val ALLOCATION_FAILED

```mach
pub val ALLOCATION_FAILED:   Error = 7
```

## val DEALLOCATION_FAILED

```mach
pub val DEALLOCATION_FAILED: Error = 8
```

## val INVALID_STATE

```mach
pub val INVALID_STATE:       Error = 9
```

## rec Bytes

```mach
pub rec Bytes;
```

public bytes with a stable address for an operation's duration

## rec Buffer

```mach
pub rec Buffer;
```

mutable public storage with a caller-owned capacity

## rec SecretBytes

```mach
pub rec SecretBytes;
```

secret bytes with a stable public address

## rec SecretBuffer

```mach
pub rec SecretBuffer;
```

mutable secret storage with a caller-owned capacity

## rec Operation

```mach
pub rec Operation;
```

result shared by fixed-buffer operations

