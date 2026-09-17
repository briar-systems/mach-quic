# quic.connection.negotiation

## def Status

```mach
pub def Status: u8
```

## val STATUS_RESTART

```mach
pub val STATUS_RESTART: Status = 1
```

## val STATUS_IGNORED

```mach
pub val STATUS_IGNORED: Status = 2
```

## val STATUS_ERROR

```mach
pub val STATUS_ERROR:   Status = 3
```

## def Error

```mach
pub def Error: u8
```

## val ERROR_NONE

```mach
pub val ERROR_NONE:     Error = 0
```

## val ERROR_STATE

```mach
pub val ERROR_STATE:    Error = 1
```

## val ERROR_CONFIG

```mach
pub val ERROR_CONFIG:   Error = 2
```

## val ERROR_PACKET

```mach
pub val ERROR_PACKET:   Error = 3
```

## val ERROR_IDENTITY

```mach
pub val ERROR_IDENTITY: Error = 4
```

## val ERROR_VERSION

```mach
pub val ERROR_VERSION:  Error = 5
```

## val ERROR_RETRY

```mach
pub val ERROR_RETRY:    Error = 6
```

## val ERROR_CAPACITY

```mach
pub val ERROR_CAPACITY: Error = 7
```

## val RESTART_VERSION

```mach
pub val RESTART_VERSION: u8 = 1
```

## val RESTART_RETRY

```mach
pub val RESTART_RETRY:   u8 = 2
```

## rec Config

```mach
pub rec Config;
```

## rec Storage

```mach
pub rec Storage;
```

## rec Client

```mach
pub rec Client;
```

## rec Result

```mach
pub rec Result;
```

## fun initialize

```mach
pub fun initialize(client: *Client, config: Config, storage: Storage, version: u32,
original_destination: packet.ConnectionId,
initial_local_source: packet.ConnectionId) bool;
```

## fun note_authenticated

```mach
pub fun note_authenticated(client: *Client) bool;
```

## fun version_negotiation

```mach
pub fun version_negotiation(client: *Client, data: *u8, length: usize) Result;
```

## fun retry

```mach
pub fun retry(client: *Client, data: *u8, length: usize) Result;
```

## fun token

```mach
pub fun token(client: *Client) packet.Span;
```

## fun finish

```mach
pub fun finish(client: *Client) bool;
```

wipes and lets go of the retry storage, which the caller may then release

