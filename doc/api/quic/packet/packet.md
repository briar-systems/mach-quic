[quic](../README.md) / [packet](README.md) / **packet**

# quic.packet.packet

Source: [`src/packet/packet.mach`](../../../../src/packet/packet.mach)

| Type | | |
| :--- | :--- | :--- |
| [`Span`](#span) | `rec` |  |
| [`ConnectionId`](#connectionid) | `rec` |  |
| [`Header`](#header) | `rec` |  |
| [`Packet`](#packet) | `rec` |  |
| [`DecodeContext`](#decodecontext) | `rec` |  |
| [`Limits`](#limits) | `rec` |  |
| [`DecodeResult`](#decoderesult) | `rec` |  |
| [`EncodeResult`](#encoderesult) | `rec` |  |
| [`ProtectedHeaderResult`](#protectedheaderresult) | `rec` |  |

| On `ConnectionId` | |
| :--- | :--- |
| [`set_connection_id`](#set_connection_id), [`connection_id_equal`](#connection_id_equal) | |

| On `Packet` | |
| :--- | :--- |
| [`version_at`](#version_at), [`encoded_size`](#encoded_size) | |
| [`encode`](#encode) | encodes one packet as a single builder transaction |
| [`protected_header_size`](#protected_header_size) | the count and packet number offset encode_protected_header gives the same arguments, with its refusals, and writes nothing |
| [`encode_protected_header`](#encode_protected_header) | encodes authenticated header bytes with the ciphertext length in the long header |

| On `DecodeContext` | |
| :--- | :--- |
| [`empty_decode_context`](#empty_decode_context) | every field is assigned by name: an empty record literal does not reliably clear one, and this context steers how many bytes a short header takes off the wire, so a caller with no prior state must still start from a defined one |
| [`decode`](#decode) | decodes one unprotected packet and publishes cursor and output only on success |

| On `Limits` | |
| :--- | :--- |
| [`default_limits`](#default_limits) | |

| Functions | |
| :--- | :--- |
| [`number_space`](#number_space), [`packet_number_width`](#packet_number_width), [`truncate_packet_number`](#truncate_packet_number), [`reconstruct_packet_number`](#reconstruct_packet_number) | |

| Constants | |
| :--- | :--- |
| [`VERSION_1`](#constants), [`VERSION_2`](#constants), [`MAX_CONNECTION_ID`](#constants), [`RETRY_INTEGRITY_TAG`](#constants), [`MAX_PACKET_NUMBER`](#constants), [`PACKET_VERSION_NEGOTIATION`](#constants), [`PACKET_INITIAL`](#constants), [`PACKET_ZERO_RTT`](#constants), [`PACKET_HANDSHAKE`](#constants), [`PACKET_RETRY`](#constants), [`PACKET_ONE_RTT`](#constants), [`PACKET_UNKNOWN_VERSION`](#constants), [`SPACE_INITIAL`](#constants), [`SPACE_HANDSHAKE`](#constants), [`SPACE_APPLICATION`](#constants), [`STATUS_DONE`](#constants), [`STATUS_MORE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_TRUNCATED`](#constants), [`ERROR_HEADER_FORM`](#constants), [`ERROR_FIXED_BIT`](#constants), [`ERROR_CONNECTION_ID`](#constants), [`ERROR_PACKET_NUMBER`](#constants), [`ERROR_PACKET_LENGTH`](#constants), [`ERROR_TOKEN_LENGTH`](#constants), [`ERROR_VERSION_LIST`](#constants), [`ERROR_RETRY`](#constants), [`ERROR_LIMIT`](#constants), [`ERROR_KIND`](#constants), [`ERROR_OUTPUT`](#constants) | |

---

## Span

```mach
pub rec Span {
    data: *u8;
    len:  usize;
}
```

## ConnectionId

```mach
pub rec ConnectionId {
    data: [20]u8;
    len:  u8;
}
```

### set_connection_id

```mach
pub fun set_connection_id(id: *ConnectionId, data: *u8, len: usize) bool
```

### connection_id_equal

```mach
pub fun connection_id_equal(a: *ConnectionId, b: *ConnectionId) bool
```

## Header

```mach
pub rec Header {
    kind:                    u8;
    version:                 u32;
    destination:             ConnectionId;
    source:                  ConnectionId;
    packet_number:           u64;
    truncated_packet_number: u32;
    packet_number_len:       u8;
    spin:                    bool;
    key_phase:               bool;
    retry_bits:              u8;
}
```

## Packet

```mach
pub rec Packet {
    header:        Header;
    token:         Span;
    payload:       Span;
    versions:      Span;
    integrity_tag: [16]u8;
}
```

### version_at

```mach
pub fun version_at(packet: *Packet, index: usize) u32
```

### encoded_size

```mach
pub fun encoded_size(packet: *Packet, limits: Limits) EncodeResult
```

### encode

```mach
pub fun encode(b: *std.encoding.binary.Builder, packet: *Packet, limits: Limits) EncodeResult
```

encodes one packet as a single builder transaction

### protected_header_size

```mach
pub fun protected_header_size(value: *Packet, ciphertext_length: usize,
    limits: Limits) ProtectedHeaderResult
```

the count and packet number offset encode_protected_header gives the same
arguments, with its refusals, and writes nothing. a full builder is the one
refusal it cannot see

### encode_protected_header

```mach
pub fun encode_protected_header(b: *std.encoding.binary.Builder, value: *Packet,
    ciphertext_length: usize,
    limits: Limits) ProtectedHeaderResult
```

encodes authenticated header bytes with the ciphertext length in the long header

## DecodeContext

```mach
pub rec DecodeContext {
    version:                u32;
    expected_packet_number: u64;
    short_destination_len:  u8;
}
```

### empty_decode_context

```mach
pub fun empty_decode_context() DecodeContext
```

every field is assigned by name: an empty record literal does not reliably
clear one, and this context steers how many bytes a short header takes off
the wire, so a caller with no prior state must still start from a defined one

### decode

```mach
pub fun decode(d: *std.encoding.binary.Decoder, final: bool, context: DecodeContext, limits: Limits, out: *Packet) DecodeResult
```

decodes one unprotected packet and publishes cursor and output only on success

## Limits

```mach
pub rec Limits {
    max_packet_size: usize;
    max_token_size:  usize;
    max_versions:    usize;
}
```

### default_limits

```mach
pub fun default_limits() Limits
```

## DecodeResult

```mach
pub rec DecodeResult {
    status:   u8;
    error:    u8;
    consumed: usize;
    needed:   usize;
}
```

## EncodeResult

```mach
pub rec EncodeResult {
    ok:    bool;
    error: u8;
    count: usize;
}
```

## ProtectedHeaderResult

```mach
pub rec ProtectedHeaderResult {
    ok:                   bool;
    error:                u8;
    count:                usize;
    packet_number_offset: usize;
}
```

## Functions

### number_space

```mach
pub fun number_space(kind: u8) u8
```

### packet_number_width

```mach
pub fun packet_number_width(number: u64, largest_acked: u64) u8
```

### truncate_packet_number

```mach
pub fun truncate_packet_number(number: u64, encoded_width: u8) u32
```

### reconstruct_packet_number

```mach
pub fun reconstruct_packet_number(expected: u64, truncated: u32, encoded_width: u8) u64
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `VERSION_1` | `u32` | `0x00000001` |  |
| `VERSION_2` | `u32` | `0x6b3343cf` |  |
| `MAX_CONNECTION_ID` | `usize` | `20` |  |
| `RETRY_INTEGRITY_TAG` | `usize` | `16` |  |
| `MAX_PACKET_NUMBER` | `u64` | `4611686018427387903` |  |
| `PACKET_VERSION_NEGOTIATION` | `u8` | `0` |  |
| `PACKET_INITIAL` | `u8` | `1` |  |
| `PACKET_ZERO_RTT` | `u8` | `2` |  |
| `PACKET_HANDSHAKE` | `u8` | `3` |  |
| `PACKET_RETRY` | `u8` | `4` |  |
| `PACKET_ONE_RTT` | `u8` | `5` |  |
| `PACKET_UNKNOWN_VERSION` | `u8` | `6` |  |
| `SPACE_INITIAL` | `u8` | `1` |  |
| `SPACE_HANDSHAKE` | `u8` | `2` |  |
| `SPACE_APPLICATION` | `u8` | `3` |  |
| `STATUS_DONE` | `u8` | `1` |  |
| `STATUS_MORE` | `u8` | `2` |  |
| `STATUS_ERROR` | `u8` | `3` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_TRUNCATED` | `u8` | `1` |  |
| `ERROR_HEADER_FORM` | `u8` | `2` |  |
| `ERROR_FIXED_BIT` | `u8` | `3` |  |
| `ERROR_CONNECTION_ID` | `u8` | `4` |  |
| `ERROR_PACKET_NUMBER` | `u8` | `5` |  |
| `ERROR_PACKET_LENGTH` | `u8` | `6` |  |
| `ERROR_TOKEN_LENGTH` | `u8` | `7` |  |
| `ERROR_VERSION_LIST` | `u8` | `8` |  |
| `ERROR_RETRY` | `u8` | `9` |  |
| `ERROR_LIMIT` | `u8` | `10` |  |
| `ERROR_KIND` | `u8` | `11` |  |
| `ERROR_OUTPUT` | `u8` | `12` |  |

