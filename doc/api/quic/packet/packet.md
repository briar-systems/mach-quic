# quic.packet.packet

## val VERSION_1

```mach
pub val VERSION_1:           u32   = 0x00000001
```

## val VERSION_2

```mach
pub val VERSION_2:           u32   = 0x6b3343cf
```

## val MAX_CONNECTION_ID

```mach
pub val MAX_CONNECTION_ID:   usize = 20
```

## val RETRY_INTEGRITY_TAG

```mach
pub val RETRY_INTEGRITY_TAG: usize = 16
```

## val MAX_PACKET_NUMBER

```mach
pub val MAX_PACKET_NUMBER:   u64   = 4611686018427387903
```

## val PACKET_VERSION_NEGOTIATION

```mach
pub val PACKET_VERSION_NEGOTIATION: u8 = 0
```

## val PACKET_INITIAL

```mach
pub val PACKET_INITIAL:             u8 = 1
```

## val PACKET_ZERO_RTT

```mach
pub val PACKET_ZERO_RTT:            u8 = 2
```

## val PACKET_HANDSHAKE

```mach
pub val PACKET_HANDSHAKE:           u8 = 3
```

## val PACKET_RETRY

```mach
pub val PACKET_RETRY:               u8 = 4
```

## val PACKET_ONE_RTT

```mach
pub val PACKET_ONE_RTT:             u8 = 5
```

## val PACKET_UNKNOWN_VERSION

```mach
pub val PACKET_UNKNOWN_VERSION:     u8 = 6
```

## val SPACE_INITIAL

```mach
pub val SPACE_INITIAL:     u8 = 1
```

## val SPACE_HANDSHAKE

```mach
pub val SPACE_HANDSHAKE:   u8 = 2
```

## val SPACE_APPLICATION

```mach
pub val SPACE_APPLICATION: u8 = 3
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
pub val ERROR_NONE:          u8 = 0
```

## val ERROR_TRUNCATED

```mach
pub val ERROR_TRUNCATED:     u8 = 1
```

## val ERROR_HEADER_FORM

```mach
pub val ERROR_HEADER_FORM:   u8 = 2
```

## val ERROR_FIXED_BIT

```mach
pub val ERROR_FIXED_BIT:     u8 = 3
```

## val ERROR_CONNECTION_ID

```mach
pub val ERROR_CONNECTION_ID: u8 = 4
```

## val ERROR_PACKET_NUMBER

```mach
pub val ERROR_PACKET_NUMBER: u8 = 5
```

## val ERROR_PACKET_LENGTH

```mach
pub val ERROR_PACKET_LENGTH: u8 = 6
```

## val ERROR_TOKEN_LENGTH

```mach
pub val ERROR_TOKEN_LENGTH:  u8 = 7
```

## val ERROR_VERSION_LIST

```mach
pub val ERROR_VERSION_LIST:  u8 = 8
```

## val ERROR_RETRY

```mach
pub val ERROR_RETRY:         u8 = 9
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT:         u8 = 10
```

## val ERROR_KIND

```mach
pub val ERROR_KIND:          u8 = 11
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT:        u8 = 12
```

## rec Span

```mach
pub rec Span;
```

## rec ConnectionId

```mach
pub rec ConnectionId;
```

## rec Header

```mach
pub rec Header;
```

## rec Packet

```mach
pub rec Packet;
```

## rec DecodeContext

```mach
pub rec DecodeContext;
```

## rec Limits

```mach
pub rec Limits;
```

## fun empty_decode_context

```mach
pub fun empty_decode_context() DecodeContext;
```

every field is assigned by name: an empty record literal does not reliably
clear one, and this context steers how many bytes a short header takes off
the wire, so a caller with no prior state must still start from a defined one

## rec DecodeResult

```mach
pub rec DecodeResult;
```

## rec EncodeResult

```mach
pub rec EncodeResult;
```

## rec ProtectedHeaderResult

```mach
pub rec ProtectedHeaderResult;
```

## fun default_limits

```mach
pub fun default_limits() Limits;
```

## fun number_space

```mach
pub fun number_space(kind: u8) u8;
```

## fun set_connection_id

```mach
pub fun set_connection_id(id: *ConnectionId, data: *u8, len: usize) bool;
```

## fun connection_id_equal

```mach
pub fun connection_id_equal(a: *ConnectionId, b: *ConnectionId) bool;
```

## fun packet_number_width

```mach
pub fun packet_number_width(number: u64, largest_acked: u64) u8;
```

## fun truncate_packet_number

```mach
pub fun truncate_packet_number(number: u64, encoded_width: u8) u32;
```

## fun reconstruct_packet_number

```mach
pub fun reconstruct_packet_number(expected: u64, truncated: u32, encoded_width: u8) u64;
```

## fun version_at

```mach
pub fun version_at(packet: *Packet, index: usize) u32;
```

## fun decode

```mach
pub fun decode(d: *binary.Decoder, final: bool, context: DecodeContext, limits: Limits, out: *Packet) DecodeResult;
```

decodes one unprotected packet and publishes cursor and output only on success

## fun encoded_size

```mach
pub fun encoded_size(packet: *Packet, limits: Limits) EncodeResult;
```

## fun encode

```mach
pub fun encode(b: *binary.Builder, packet: *Packet, limits: Limits) EncodeResult;
```

encodes one packet as a single builder transaction

## fun encode_protected_header

```mach
pub fun encode_protected_header(b: *binary.Builder, value: *Packet,
ciphertext_length: usize,
limits: Limits) ProtectedHeaderResult;
```

encodes authenticated header bytes with the ciphertext length in the long header

