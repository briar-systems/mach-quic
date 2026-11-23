[quic](../README.md) / [connection](README.md) / **negotiation**

# quic.connection.negotiation

client version negotiation and Retry restart lifecycle

Source: [`src/connection/negotiation.mach`](../../../../src/connection/negotiation.mach)

Uses types from [`quic.packet.packet`](../packet/packet.md).

| Type | | |
| :--- | :--- | :--- |
| [`Status`](#status) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`Config`](#config) | `rec` |  |
| [`Storage`](#storage) | `rec` |  |
| [`Client`](#client) | `rec` |  |
| [`Result`](#result) | `rec` |  |

| On `Status` | |
| :--- | :--- |
| [`STATUS_RESTART`](#status), [`STATUS_IGNORED`](#status), [`STATUS_ERROR`](#status) | |

| On `Error` | |
| :--- | :--- |
| [`ERROR_NONE`](#error), [`ERROR_STATE`](#error), [`ERROR_CONFIG`](#error), [`ERROR_PACKET`](#error), [`ERROR_IDENTITY`](#error), [`ERROR_VERSION`](#error), [`ERROR_RETRY`](#error), [`ERROR_CAPACITY`](#error) | |

| On `Client` | |
| :--- | :--- |
| [`initialize`](#initialize), [`note_authenticated`](#note_authenticated), [`version_negotiation`](#version_negotiation), [`retry`](#retry), [`token`](#token) | |
| [`finish`](#finish) | wipes and lets go of the retry storage, which the caller may then release |

| Constants | |
| :--- | :--- |
| [`RESTART_VERSION`](#constants), [`RESTART_RETRY`](#constants) | |

---

## Status

```mach
pub def Status: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATUS_RESTART` | `1` |  |
| `STATUS_IGNORED` | `2` |  |
| `STATUS_ERROR` | `3` |  |

## Error

```mach
pub def Error: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `ERROR_NONE` | `0` |  |
| `ERROR_STATE` | `1` |  |
| `ERROR_CONFIG` | `2` |  |
| `ERROR_PACKET` | `3` |  |
| `ERROR_IDENTITY` | `4` |  |
| `ERROR_VERSION` | `5` |  |
| `ERROR_RETRY` | `6` |  |
| `ERROR_CAPACITY` | `7` |  |

## Config

```mach
pub rec Config {
    supported_versions:      *u32;
    supported_version_count: usize;
}
```

## Storage

```mach
pub rec Storage {
    retry_token:           *u8;
    retry_token_capacity:  usize;
    retry_pseudo:          *u8;
    retry_pseudo_capacity: usize;
}
```

## Client

```mach
pub rec Client {
    config:                        Config;
    storage:                       Storage;
    original_destination:          quic.packet.packet.ConnectionId;
    initial_local_source:          quic.packet.packet.ConnectionId;
    peer_destination:              quic.packet.packet.ConnectionId;
    version:                       u32;
    retry_token_length:            usize;
    authenticated_packet_received: bool;
    version_negotiated:            bool;
    retry_accepted:                bool;
    initialized:                   bool;
}
```

### initialize

```mach
pub fun initialize(client: *Client, config: Config, storage: Storage, version: u32,
    original_destination: quic.packet.packet.ConnectionId,
    initial_local_source: quic.packet.packet.ConnectionId) bool
```

### note_authenticated

```mach
pub fun note_authenticated(client: *Client) bool
```

### version_negotiation

```mach
pub fun version_negotiation(client: *Client, data: *u8, length: usize) Result
```

### retry

```mach
pub fun retry(client: *Client, data: *u8, length: usize) Result
```

### token

```mach
pub fun token(client: *Client) quic.packet.packet.Span
```

### finish

```mach
pub fun finish(client: *Client) bool
```

wipes and lets go of the retry storage, which the caller may then release

## Result

```mach
pub rec Result {
    status:           Status;
    error:            Error;
    restart:          u8;
    version:          u32;
    peer_destination: quic.packet.packet.ConnectionId;
    token:            quic.packet.packet.Span;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `RESTART_VERSION` | `u8` | `1` |  |
| `RESTART_RETRY` | `u8` | `2` |  |

