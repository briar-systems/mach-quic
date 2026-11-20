[quic](README.md) / **transport_parameters**

# quic.transport_parameters

Source: [`src/transport_parameters.mach`](../../../src/transport_parameters.mach)

Uses types from [`quic.packet.packet`](packet/packet.md).

| Type | | |
| :--- | :--- | :--- |
| [`Parameter`](#parameter) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`PreferredAddress`](#preferredaddress) | `rec` |  |
| [`Parameters`](#parameters) | `rec` |  |
| [`Limits`](#limits) | `rec` |  |
| [`DecodeResult`](#decoderesult) | `rec` |  |
| [`EncodeResult`](#encoderesult) | `rec` |  |

| On `Parameters` | |
| :--- | :--- |
| [`defaults`](#defaults), [`has`](#has), [`set_present`](#set_present), [`encoded_size`](#encoded_size) | |
| [`encode`](#encode) | encodes a complete parameter block as one builder transaction |

| On `Limits` | |
| :--- | :--- |
| [`default_limits`](#default_limits) | |
| [`decode`](#decode) | decodes a complete tls quic transport-parameter block transactionally |

| Constants | |
| :--- | :--- |
| [`ORIGINAL_DESTINATION_CONNECTION_ID`](#constants), [`MAX_IDLE_TIMEOUT`](#constants), [`STATELESS_RESET_TOKEN`](#constants), [`MAX_UDP_PAYLOAD_SIZE`](#constants), [`INITIAL_MAX_DATA`](#constants), [`INITIAL_MAX_STREAM_DATA_BIDI_LOCAL`](#constants), [`INITIAL_MAX_STREAM_DATA_BIDI_REMOTE`](#constants), [`INITIAL_MAX_STREAM_DATA_UNI`](#constants), [`INITIAL_MAX_STREAMS_BIDI`](#constants), [`INITIAL_MAX_STREAMS_UNI`](#constants), [`ACK_DELAY_EXPONENT`](#constants), [`MAX_ACK_DELAY`](#constants), [`DISABLE_ACTIVE_MIGRATION`](#constants), [`PREFERRED_ADDRESS`](#constants), [`ACTIVE_CONNECTION_ID_LIMIT`](#constants), [`INITIAL_SOURCE_CONNECTION_ID`](#constants), [`RETRY_SOURCE_CONNECTION_ID`](#constants), [`MAX_DATAGRAM_FRAME_SIZE`](#constants), [`ROLE_ANY`](#constants), [`ROLE_CLIENT`](#constants), [`ROLE_SERVER`](#constants), [`STATUS_DONE`](#constants), [`STATUS_MORE`](#constants), [`STATUS_ERROR`](#constants), [`ERROR_NONE`](#constants), [`ERROR_TRUNCATED`](#constants), [`ERROR_DUPLICATE`](#constants), [`ERROR_ENCODING`](#constants), [`ERROR_VALUE`](#constants), [`ERROR_ROLE`](#constants), [`ERROR_LIMIT`](#constants), [`ERROR_OUTPUT`](#constants), [`MAX_PARAMETERS`](#constants) | |

---

## Parameter

```mach
pub rec Parameter {
    id:    u64;
    value: quic.packet.packet.Span;
}
```

## Storage

```mach
pub rec Storage {
    extensions:              *Parameter;
    extension_capacity:      usize;
    extension_bytes:         *u8;
    extension_byte_capacity: usize;
}
```

## PreferredAddress

```mach
pub rec PreferredAddress {
    ipv4:                  [4]u8;
    ipv4_port:             u16;
    ipv6:                  [16]u8;
    ipv6_port:             u16;
    connection_id:         quic.packet.packet.ConnectionId;
    stateless_reset_token: [16]u8;
}
```

## Parameters

```mach
pub rec Parameters {
    present:                             u64;
    original_destination_connection_id:  quic.packet.packet.ConnectionId;
    max_idle_timeout:                    u64;
    stateless_reset_token:               [16]u8;
    max_udp_payload_size:                u64;
    initial_max_data:                    u64;
    initial_max_stream_data_bidi_local:  u64;
    initial_max_stream_data_bidi_remote: u64;
    initial_max_stream_data_uni:         u64;
    initial_max_streams_bidi:            u64;
    initial_max_streams_uni:             u64;
    ack_delay_exponent:                  u64;
    max_ack_delay:                       u64;
    disable_active_migration:            bool;
    preferred_address:                   PreferredAddress;
    active_connection_id_limit:          u64;
    initial_source_connection_id:        quic.packet.packet.ConnectionId;
    retry_source_connection_id:          quic.packet.packet.ConnectionId;
    max_datagram_frame_size:             u64;
    extensions:                          *Parameter;
    extension_count:                     usize;
}
```

### defaults

```mach
pub fun defaults() Parameters
```

### has

```mach
pub fun has(parameters: *Parameters, id: u64) bool
```

### set_present

```mach
pub fun set_present(parameters: *Parameters, id: u64) bool
```

### encoded_size

```mach
pub fun encoded_size(parameters: *Parameters, role: u8, limits: Limits) EncodeResult
```

### encode

```mach
pub fun encode(b: *std.encoding.binary.Builder, parameters: *Parameters, role: u8, limits: Limits) EncodeResult
```

encodes a complete parameter block as one builder transaction

## Limits

```mach
pub rec Limits {
    max_total_size:     usize;
    max_parameters:     usize;
    max_extension_size: usize;
}
```

### default_limits

```mach
pub fun default_limits() Limits
```

### decode

```mach
pub fun decode(data: *u8, len: usize, final: bool, peer_role: u8, limits: Limits, storage: Storage, out: *Parameters) DecodeResult
```

decodes a complete tls quic transport-parameter block transactionally

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

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `ORIGINAL_DESTINATION_CONNECTION_ID` | `u64` | `0x00` |  |
| `MAX_IDLE_TIMEOUT` | `u64` | `0x01` |  |
| `STATELESS_RESET_TOKEN` | `u64` | `0x02` |  |
| `MAX_UDP_PAYLOAD_SIZE` | `u64` | `0x03` |  |
| `INITIAL_MAX_DATA` | `u64` | `0x04` |  |
| `INITIAL_MAX_STREAM_DATA_BIDI_LOCAL` | `u64` | `0x05` |  |
| `INITIAL_MAX_STREAM_DATA_BIDI_REMOTE` | `u64` | `0x06` |  |
| `INITIAL_MAX_STREAM_DATA_UNI` | `u64` | `0x07` |  |
| `INITIAL_MAX_STREAMS_BIDI` | `u64` | `0x08` |  |
| `INITIAL_MAX_STREAMS_UNI` | `u64` | `0x09` |  |
| `ACK_DELAY_EXPONENT` | `u64` | `0x0a` |  |
| `MAX_ACK_DELAY` | `u64` | `0x0b` |  |
| `DISABLE_ACTIVE_MIGRATION` | `u64` | `0x0c` |  |
| `PREFERRED_ADDRESS` | `u64` | `0x0d` |  |
| `ACTIVE_CONNECTION_ID_LIMIT` | `u64` | `0x0e` |  |
| `INITIAL_SOURCE_CONNECTION_ID` | `u64` | `0x0f` |  |
| `RETRY_SOURCE_CONNECTION_ID` | `u64` | `0x10` |  |
| `MAX_DATAGRAM_FRAME_SIZE` | `u64` | `0x20` |  |
| `ROLE_ANY` | `u8` | `0` |  |
| `ROLE_CLIENT` | `u8` | `1` |  |
| `ROLE_SERVER` | `u8` | `2` |  |
| `STATUS_DONE` | `u8` | `1` |  |
| `STATUS_MORE` | `u8` | `2` |  |
| `STATUS_ERROR` | `u8` | `3` |  |
| `ERROR_NONE` | `u8` | `0` |  |
| `ERROR_TRUNCATED` | `u8` | `1` |  |
| `ERROR_DUPLICATE` | `u8` | `2` |  |
| `ERROR_ENCODING` | `u8` | `3` |  |
| `ERROR_VALUE` | `u8` | `4` |  |
| `ERROR_ROLE` | `u8` | `5` |  |
| `ERROR_LIMIT` | `u8` | `6` |  |
| `ERROR_OUTPUT` | `u8` | `7` |  |
| `MAX_PARAMETERS` | `usize` | `256` |  |

