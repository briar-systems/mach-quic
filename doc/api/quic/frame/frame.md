# quic.frame.frame

## val PADDING

```mach
pub val PADDING: u64 = 0x00
```

## val PING

```mach
pub val PING: u64 = 0x01
```

## val ACK

```mach
pub val ACK: u64 = 0x02
```

## val ACK_ECN

```mach
pub val ACK_ECN: u64 = 0x03
```

## val RESET_STREAM

```mach
pub val RESET_STREAM: u64 = 0x04
```

## val STOP_SENDING

```mach
pub val STOP_SENDING: u64 = 0x05
```

## val CRYPTO

```mach
pub val CRYPTO: u64 = 0x06
```

## val NEW_TOKEN

```mach
pub val NEW_TOKEN: u64 = 0x07
```

## val STREAM_BASE

```mach
pub val STREAM_BASE: u64 = 0x08
```

## val STREAM_MAX

```mach
pub val STREAM_MAX: u64 = 0x0f
```

## val MAX_DATA

```mach
pub val MAX_DATA: u64 = 0x10
```

## val MAX_STREAM_DATA

```mach
pub val MAX_STREAM_DATA: u64 = 0x11
```

## val MAX_STREAMS_BIDI

```mach
pub val MAX_STREAMS_BIDI: u64 = 0x12
```

## val MAX_STREAMS_UNI

```mach
pub val MAX_STREAMS_UNI: u64 = 0x13
```

## val DATA_BLOCKED

```mach
pub val DATA_BLOCKED: u64 = 0x14
```

## val STREAM_DATA_BLOCKED

```mach
pub val STREAM_DATA_BLOCKED: u64 = 0x15
```

## val STREAMS_BLOCKED_BIDI

```mach
pub val STREAMS_BLOCKED_BIDI: u64 = 0x16
```

## val STREAMS_BLOCKED_UNI

```mach
pub val STREAMS_BLOCKED_UNI: u64 = 0x17
```

## val NEW_CONNECTION_ID

```mach
pub val NEW_CONNECTION_ID: u64 = 0x18
```

## val RETIRE_CONNECTION_ID

```mach
pub val RETIRE_CONNECTION_ID: u64 = 0x19
```

## val PATH_CHALLENGE

```mach
pub val PATH_CHALLENGE: u64 = 0x1a
```

## val PATH_RESPONSE

```mach
pub val PATH_RESPONSE: u64 = 0x1b
```

## val CONNECTION_CLOSE_TRANSPORT

```mach
pub val CONNECTION_CLOSE_TRANSPORT: u64 = 0x1c
```

## val CONNECTION_CLOSE_APPLICATION

```mach
pub val CONNECTION_CLOSE_APPLICATION: u64 = 0x1d
```

## val HANDSHAKE_DONE

```mach
pub val HANDSHAKE_DONE: u64 = 0x1e
```

## val DATAGRAM

```mach
pub val DATAGRAM: u64 = 0x30
```

## val DATAGRAM_LEN

```mach
pub val DATAGRAM_LEN: u64 = 0x31
```

## val STATUS_DONE

```mach
pub val STATUS_DONE: u8 = 1
```

## val STATUS_MORE

```mach
pub val STATUS_MORE: u8 = 2
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR: u8 = 3
```

## val ERROR_NONE

```mach
pub val ERROR_NONE: u8 = 0
```

## val ERROR_TRUNCATED

```mach
pub val ERROR_TRUNCATED: u8 = 1
```

## val ERROR_UNKNOWN_TYPE

```mach
pub val ERROR_UNKNOWN_TYPE: u8 = 2
```

## val ERROR_ENCODING

```mach
pub val ERROR_ENCODING: u8 = 3
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT: u8 = 4
```

## val ERROR_ACK_RANGE

```mach
pub val ERROR_ACK_RANGE: u8 = 5
```

## val ERROR_CONNECTION_ID

```mach
pub val ERROR_CONNECTION_ID: u8 = 6
```

## val ERROR_STREAM_LIMIT

```mach
pub val ERROR_STREAM_LIMIT: u8 = 7
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT: u8 = 8
```

## rec AckRange

```mach
pub rec AckRange;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Frame

```mach
pub rec Frame;
```

fields are interpreted by kind, keeping dispatch allocation-free

## rec Limits

```mach
pub rec Limits;
```

## rec DecodeResult

```mach
pub rec DecodeResult;
```

## rec EncodeResult

```mach
pub rec EncodeResult;
```

## fun default_limits

```mach
pub fun default_limits() Limits;
```

## fun is_stream

```mach
pub fun is_stream(kind: u64) bool;
```

## fun ack_eliciting

```mach
pub fun ack_eliciting(kind: u64) bool;
```

## fun decode

```mach
pub fun decode(d: *binary.Decoder, final: bool, limits: Limits, storage: Storage, out: *Frame) DecodeResult;
```

decodes one frame and commits output, ack storage, and cursor together

## fun encoded_size

```mach
pub fun encoded_size(frame: *Frame, limits: Limits) EncodeResult;
```

## fun encode

```mach
pub fun encode(b: *binary.Builder, frame: *Frame, limits: Limits) EncodeResult;
```

encodes one complete frame as a builder transaction

