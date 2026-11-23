[quic](../README.md) / [frame](README.md) / **frame**

# quic.frame.frame

Source: [`src/frame/frame.mach`](../../../../src/frame/frame.mach)

Uses types from [`quic.packet.packet`](../packet/packet.md).

| Type | | |
| :--- | :--- | :--- |
| [`AckRange`](#ackrange) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`Frame`](#frame) | `rec` | fields are interpreted by kind, keeping dispatch allocation-free |
| [`Limits`](#limits) | `rec` |  |
| [`DecodeResult`](#decoderesult) | `rec` |  |
| [`EncodeResult`](#encoderesult) | `rec` |  |

| On `Frame` | |
| :--- | :--- |
| [`encoded_size`](#encoded_size) | |
| [`encode`](#encode) | encodes one complete frame as a builder transaction |

| On `Limits` | |
| :--- | :--- |
| [`default_limits`](#default_limits) | |
| [`decode`](#decode) | decodes one frame and commits output, ack storage, and cursor together |

| Functions | |
| :--- | :--- |
| [`is_stream`](#is_stream), [`ack_eliciting`](#ack_eliciting) | |

| Constants | |
| :--- | :--- |
| [`PADDING`](#constants), [`PING`](#constants), [`ACK`](#constants), [`ACK_ECN`](#constants), [`RESET_STREAM`](#constants), [`STOP_SENDING`](#constants), [`CRYPTO`](#constants), [`NEW_TOKEN`](#constants), [`STREAM_BASE`](#constants), [`STREAM_MAX`](#constants), [`MAX_DATA`](#constants), [`MAX_STREAM_DATA`](#constants), [`MAX_STREAMS_BIDI`](#constants), [`MAX_STREAMS_UNI`](#constants), [`DATA_BLOCKED`](#constants), [`STREAM_DATA_BLOCKED`](#constants), [`STREAMS_BLOCKED_BIDI`](#constants), [`STREAMS_BLOCKED_UNI`](#constants), [`NEW_CONNECTION_ID`](#constants), [`RETIRE_CONNECTION_ID`](#constants), [`PATH_CHALLENGE`](#constants), [`PATH_RESPONSE`](#constants), [`CONNECTION_CLOSE_TRANSPORT`](#constants), [`CONNECTION_CLOSE_APPLICATION`](#constants), [`HANDSHAKE_DONE`](#constants), [`DATAGRAM`](#constants), [`DATAGRAM_LEN`](#constants), [`STATUS_DONE`](#constants), [`STATUS_MORE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_TRUNCATED`](#constants), [`ERROR_UNKNOWN_TYPE`](#constants), [`ERROR_ENCODING`](#constants), [`ERROR_LIMIT`](#constants), [`ERROR_ACK_RANGE`](#constants), [`ERROR_CONNECTION_ID`](#constants), [`ERROR_STREAM_LIMIT`](#constants), [`ERROR_OUTPUT`](#constants) | |

---

## AckRange

```mach
pub rec AckRange {
    gap:   u64;
    range: u64;
}
```

## Storage

```mach
pub rec Storage {
    ack_ranges:   *AckRange;
    ack_capacity: usize;
}
```

## Frame

```mach
pub rec Frame {
    kind:                  u64;
    padding_count:         usize;
    stream_id:             u64;
    error_code:            u64;
    final_size:            u64;
    offset:                u64;
    maximum:               u64;
    sequence:              u64;
    retire_prior_to:       u64;
    frame_type:            u64;
    data:                  quic.packet.packet.Span;
    fin:                   bool;
    bidirectional:         bool;
    largest_acknowledged:  u64;
    ack_delay:             u64;
    first_ack_range:       u64;
    ack_ranges:            *AckRange;
    ack_range_count:       usize;
    ect0:                  u64;
    ect1:                  u64;
    ecn_ce:                u64;
    connection_id:         quic.packet.packet.ConnectionId;
    stateless_reset_token: [16]u8;
    path_data:             [8]u8;
}
```

fields are interpreted by kind, keeping dispatch allocation-free

### encoded_size

```mach
pub fun encoded_size(frame: *Frame, limits: Limits) EncodeResult
```

### encode

```mach
pub fun encode(b: *std.encoding.binary.Builder, frame: *Frame, limits: Limits) EncodeResult
```

encodes one complete frame as a builder transaction

## Limits

```mach
pub rec Limits {
    max_frame_size:   usize;
    max_payload_size: usize;
    max_ack_ranges:   usize;
    max_token_size:   usize;
    max_reason_size:  usize;
}
```

### default_limits

```mach
pub fun default_limits() Limits
```

### decode

```mach
pub fun decode(d: *std.encoding.binary.Decoder, final: bool, limits: Limits, storage: Storage, out: *Frame) DecodeResult
```

decodes one frame and commits output, ack storage, and cursor together

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

## Functions

### is_stream

```mach
pub fun is_stream(kind: u64) bool
```

### ack_eliciting

```mach
pub fun ack_eliciting(kind: u64) bool
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `PADDING` | `u64` | `0x00` |  |
| `PING` | `u64` | `0x01` |  |
| `ACK` | `u64` | `0x02` |  |
| `ACK_ECN` | `u64` | `0x03` |  |
| `RESET_STREAM` | `u64` | `0x04` |  |
| `STOP_SENDING` | `u64` | `0x05` |  |
| `CRYPTO` | `u64` | `0x06` |  |
| `NEW_TOKEN` | `u64` | `0x07` |  |
| `STREAM_BASE` | `u64` | `0x08` |  |
| `STREAM_MAX` | `u64` | `0x0f` |  |
| `MAX_DATA` | `u64` | `0x10` |  |
| `MAX_STREAM_DATA` | `u64` | `0x11` |  |
| `MAX_STREAMS_BIDI` | `u64` | `0x12` |  |
| `MAX_STREAMS_UNI` | `u64` | `0x13` |  |
| `DATA_BLOCKED` | `u64` | `0x14` |  |
| `STREAM_DATA_BLOCKED` | `u64` | `0x15` |  |
| `STREAMS_BLOCKED_BIDI` | `u64` | `0x16` |  |
| `STREAMS_BLOCKED_UNI` | `u64` | `0x17` |  |
| `NEW_CONNECTION_ID` | `u64` | `0x18` |  |
| `RETIRE_CONNECTION_ID` | `u64` | `0x19` |  |
| `PATH_CHALLENGE` | `u64` | `0x1a` |  |
| `PATH_RESPONSE` | `u64` | `0x1b` |  |
| `CONNECTION_CLOSE_TRANSPORT` | `u64` | `0x1c` |  |
| `CONNECTION_CLOSE_APPLICATION` | `u64` | `0x1d` |  |
| `HANDSHAKE_DONE` | `u64` | `0x1e` |  |
| `DATAGRAM` | `u64` | `0x30` |  |
| `DATAGRAM_LEN` | `u64` | `0x31` |  |
| `STATUS_DONE` | `u8` | `1` |  |
| `STATUS_MORE` | `u8` | `2` |  |
| `STATUS_ERROR` | `u8` | `3` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_TRUNCATED` | `u8` | `1` |  |
| `ERROR_UNKNOWN_TYPE` | `u8` | `2` |  |
| `ERROR_ENCODING` | `u8` | `3` |  |
| `ERROR_LIMIT` | `u8` | `4` |  |
| `ERROR_ACK_RANGE` | `u8` | `5` |  |
| `ERROR_CONNECTION_ID` | `u8` | `6` |  |
| `ERROR_STREAM_LIMIT` | `u8` | `7` |  |
| `ERROR_OUTPUT` | `u8` | `8` |  |

