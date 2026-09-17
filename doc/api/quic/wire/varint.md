# quic.wire.varint

## val MAX

```mach
pub val MAX: u64 = 4611686018427387903
```

## val STATUS_DONE

```mach
pub val STATUS_DONE:  u8 = 1
```

## val STATUS_MORE

```mach
pub val STATUS_MORE:  u8 = 2
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: u8 = 3
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:        u8 = 0
```

## val ERROR_NON_MINIMAL

```mach
pub val ERROR_NON_MINIMAL: u8 = 1
```

## val ERROR_OVERFLOW

```mach
pub val ERROR_OVERFLOW:    u8 = 2
```

## val ERROR_WIDTH

```mach
pub val ERROR_WIDTH:       u8 = 3
```

## rec Decoded

```mach
pub rec Decoded;
```

## fun width

```mach
pub fun width(value: u64) u8;
```

## fun read

```mach
pub fun read(d: *binary.Decoder, canonical: bool) Decoded;
```

reads one rfc 9000 variable-length integer transactionally

## fun write

```mach
pub fun write(b: *binary.Builder, value: u64, encoded_width: u8) res[usize, u8];
```

writes one variable-length integer atomically, using width 0 for canonical

