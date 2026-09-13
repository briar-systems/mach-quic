# quic.transport_parameters

## val ORIGINAL_DESTINATION_CONNECTION_ID

```mach
pub val ORIGINAL_DESTINATION_CONNECTION_ID: u64 = 0x00
```

## val MAX_IDLE_TIMEOUT

```mach
pub val MAX_IDLE_TIMEOUT: u64 = 0x01
```

## val STATELESS_RESET_TOKEN

```mach
pub val STATELESS_RESET_TOKEN: u64 = 0x02
```

## val MAX_UDP_PAYLOAD_SIZE

```mach
pub val MAX_UDP_PAYLOAD_SIZE: u64 = 0x03
```

## val INITIAL_MAX_DATA

```mach
pub val INITIAL_MAX_DATA: u64 = 0x04
```

## val INITIAL_MAX_STREAM_DATA_BIDI_LOCAL

```mach
pub val INITIAL_MAX_STREAM_DATA_BIDI_LOCAL: u64 = 0x05
```

## val INITIAL_MAX_STREAM_DATA_BIDI_REMOTE

```mach
pub val INITIAL_MAX_STREAM_DATA_BIDI_REMOTE: u64 = 0x06
```

## val INITIAL_MAX_STREAM_DATA_UNI

```mach
pub val INITIAL_MAX_STREAM_DATA_UNI: u64 = 0x07
```

## val INITIAL_MAX_STREAMS_BIDI

```mach
pub val INITIAL_MAX_STREAMS_BIDI: u64 = 0x08
```

## val INITIAL_MAX_STREAMS_UNI

```mach
pub val INITIAL_MAX_STREAMS_UNI: u64 = 0x09
```

## val ACK_DELAY_EXPONENT

```mach
pub val ACK_DELAY_EXPONENT: u64 = 0x0a
```

## val MAX_ACK_DELAY

```mach
pub val MAX_ACK_DELAY: u64 = 0x0b
```

## val DISABLE_ACTIVE_MIGRATION

```mach
pub val DISABLE_ACTIVE_MIGRATION: u64 = 0x0c
```

## val PREFERRED_ADDRESS

```mach
pub val PREFERRED_ADDRESS: u64 = 0x0d
```

## val ACTIVE_CONNECTION_ID_LIMIT

```mach
pub val ACTIVE_CONNECTION_ID_LIMIT: u64 = 0x0e
```

## val INITIAL_SOURCE_CONNECTION_ID

```mach
pub val INITIAL_SOURCE_CONNECTION_ID: u64 = 0x0f
```

## val RETRY_SOURCE_CONNECTION_ID

```mach
pub val RETRY_SOURCE_CONNECTION_ID: u64 = 0x10
```

## val MAX_DATAGRAM_FRAME_SIZE

```mach
pub val MAX_DATAGRAM_FRAME_SIZE: u64 = 0x20
```

## val ROLE_ANY

```mach
pub val ROLE_ANY: u8 = 0
```

## val ROLE_CLIENT

```mach
pub val ROLE_CLIENT: u8 = 1
```

## val ROLE_SERVER

```mach
pub val ROLE_SERVER: u8 = 2
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

## val ERROR_DUPLICATE

```mach
pub val ERROR_DUPLICATE: u8 = 2
```

## val ERROR_ENCODING

```mach
pub val ERROR_ENCODING: u8 = 3
```

## val ERROR_VALUE

```mach
pub val ERROR_VALUE: u8 = 4
```

## val ERROR_ROLE

```mach
pub val ERROR_ROLE: u8 = 5
```

## val ERROR_LIMIT

```mach
pub val ERROR_LIMIT: u8 = 6
```

## val ERROR_OUTPUT

```mach
pub val ERROR_OUTPUT: u8 = 7
```

## val MAX_PARAMETERS

```mach
pub val MAX_PARAMETERS: usize = 256
```

## rec Parameter

```mach
pub rec Parameter;
```

## rec Storage

```mach
pub rec Storage;
```

## rec PreferredAddress

```mach
pub rec PreferredAddress;
```

## rec Parameters

```mach
pub rec Parameters;
```

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

## fun defaults

```mach
pub fun defaults() Parameters;
```

## fun has

```mach
pub fun has(parameters: *Parameters, id: u64) bool;
```

## fun set_present

```mach
pub fun set_present(parameters: *Parameters, id: u64) bool;
```

## fun decode

```mach
pub fun decode(data: *u8, len: usize, final: bool, peer_role: u8, limits: Limits, storage: Storage, out: *Parameters) DecodeResult;
```

decodes a complete tls quic transport-parameter block transactionally

## fun encoded_size

```mach
pub fun encoded_size(parameters: *Parameters, role: u8, limits: Limits) EncodeResult;
```

## fun encode

```mach
pub fun encode(b: *binary.Builder, parameters: *Parameters, role: u8, limits: Limits) EncodeResult;
```

encodes a complete parameter block as one builder transaction

