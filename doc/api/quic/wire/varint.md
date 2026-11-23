[quic](../README.md) / [wire](README.md) / **varint**

# quic.wire.varint

Source: [`src/wire/varint.mach`](../../../../src/wire/varint.mach)

| Type | | |
| :--- | :--- | :--- |
| [`Decoded`](#decoded) | `rec` |  |

| On `Decoded` | |
| :--- | :--- |
| [`read`](#read) | reads one rfc 9000 variable-length integer transactionally |

| Functions | |
| :--- | :--- |
| [`width`](#width) | |
| [`write`](#write) | writes one variable-length integer atomically, using width 0 for canonical |

| Constants | |
| :--- | :--- |
| [`MAX`](#constants), [`STATUS_DONE`](#constants), [`STATUS_MORE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_NON_MINIMAL`](#constants), [`ERROR_OVERFLOW`](#constants), [`ERROR_WIDTH`](#constants) | |

---

## Decoded

```mach
pub rec Decoded {
    status: u8;
    error:  u8;
    value:  u64;
    width:  u8;
}
```

### read

```mach
pub fun read(d: *std.encoding.binary.Decoder, canonical: bool) Decoded
```

reads one rfc 9000 variable-length integer transactionally

## Functions

### width

```mach
pub fun width(value: u64) u8
```

### write

```mach
pub fun write(b: *std.encoding.binary.Builder, value: u64, encoded_width: u8) res[usize, u8]
```

writes one variable-length integer atomically, using width 0 for canonical

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `MAX` | `u64` | `4611686018427387903` |  |
| `STATUS_DONE` | `u8` | `1` |  |
| `STATUS_MORE` | `u8` | `2` |  |
| `STATUS_ERROR` | `u8` | `3` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_NON_MINIMAL` | `u8` | `1` |  |
| `ERROR_OVERFLOW` | `u8` | `2` |  |
| `ERROR_WIDTH` | `u8` | `3` |  |

