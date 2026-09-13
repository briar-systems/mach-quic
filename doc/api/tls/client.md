# tls.client

## def Level

```mach
pub def Level: u8
```

## val INITIAL

```mach
pub val INITIAL: Level = engine.INITIAL
```

## val HANDSHAKE

```mach
pub val HANDSHAKE: Level = engine.HANDSHAKE
```

## val APPLICATION

```mach
pub val APPLICATION: Level = engine.APPLICATION
```

## def Direction

```mach
pub def Direction: u8
```

## val SEND

```mach
pub val SEND: Direction = engine.SEND
```

## val RECEIVE

```mach
pub val RECEIVE: Direction = engine.RECEIVE
```

## def EventKind

```mach
pub def EventKind: u8
```

## val CRYPTO

```mach
pub val CRYPTO: EventKind = engine.CRYPTO
```

## val TRAFFIC_SECRET

```mach
pub val TRAFFIC_SECRET: EventKind = engine.TRAFFIC_SECRET
```

## val PEER_PARAMETERS

```mach
pub val PEER_PARAMETERS: EventKind = engine.PEER_PARAMETERS
```

## val EARLY_DATA

```mach
pub val EARLY_DATA: EventKind = engine.EARLY_DATA
```

## val AUTHENTICATION

```mach
pub val AUTHENTICATION: EventKind = engine.AUTHENTICATION
```

## val HANDSHAKE_COMPLETE

```mach
pub val HANDSHAKE_COMPLETE: EventKind = engine.HANDSHAKE_COMPLETE
```

## val ALERT

```mach
pub val ALERT: EventKind = engine.ALERT
```

## def Status

```mach
pub def Status: u8
```

## val OK

```mach
pub val OK: Status = engine.OK
```

## val MORE

```mach
pub val MORE: Status = engine.MORE
```

## val BLOCKED

```mach
pub val BLOCKED: Status = engine.BLOCKED
```

## val COMPLETE

```mach
pub val COMPLETE: Status = engine.COMPLETE
```

## val FAILED

```mach
pub val FAILED: Status = engine.FAILED
```

## val CLOSED

```mach
pub val CLOSED: Status = engine.CLOSED
```

## val EARLY_NOT_OFFERED

```mach
pub val EARLY_NOT_OFFERED: u8 = engine.EARLY_NOT_OFFERED
```

## val EARLY_ACCEPTED

```mach
pub val EARLY_ACCEPTED: u8 = engine.EARLY_ACCEPTED
```

## val EARLY_REJECTED

```mach
pub val EARLY_REJECTED: u8 = engine.EARLY_REJECTED
```

## val AUTHENTICATED

```mach
pub val AUTHENTICATED: u8 = engine.AUTHENTICATED
```

## val AUTHENTICATION_FAILED

```mach
pub val AUTHENTICATION_FAILED: u8 = engine.AUTHENTICATION_FAILED
```

## val RESTART_RETRY

```mach
pub val RESTART_RETRY: u8 = 1
```

## val RESTART_VERSION_NEGOTIATION

```mach
pub val RESTART_VERSION_NEGOTIATION: u8 = 2
```

## val MAX_KEY_SHARE

```mach
pub val MAX_KEY_SHARE: usize = 65
```

## val MAX_PUBLIC_KEY

```mach
pub val MAX_PUBLIC_KEY: usize = 512
```

## val MAX_TRUST_ANCHORS

```mach
pub val MAX_TRUST_ANCHORS: usize = 256
```

## val MAX_SIGNATURE

```mach
pub val MAX_SIGNATURE: usize = 512
```

## val MAX_SIGNED_CONTEXT

```mach
pub val MAX_SIGNED_CONTEXT: usize = 64 + 34 + 1 + 48
```

## val QUIC_TRANSPORT_PARAMETERS

```mach
pub val QUIC_TRANSPORT_PARAMETERS: u16 = 0x0039
```

## rec ExtraExtension

```mach
pub rec ExtraExtension;
```

## rec Storage

```mach
pub rec Storage;
```

all variable-size handshake storage is caller-owned and remains borrowed

## rec Client

```mach
pub rec Client;
```

## fun aliases_borrowed

```mach
pub fun aliases_borrowed(client: *Client, data: *u8, len: usize) bool;
```

## fun aliases_configuration

```mach
pub fun aliases_configuration(client: *Client, data: *u8, len: usize) bool;
```

## fun init

```mach
pub fun init(client: *Client, configuration: *config.ClientConfig,
storage: Storage, extra: ExtraExtension, peer_extension: u16) bool;
```

## fun start

```mach
pub fun start(client: *Client, verification_time: i64) engine.Result;
```

## fun restart

```mach
pub fun restart(client: *Client, reason: u8) engine.Result;
```

## fun request_key_update

```mach
pub fun request_key_update(client: *Client, request: u8) engine.Result;
```

ask the peer for a fresh send key, and optionally for one of its own

## fun ingest

```mach
pub fun ingest(client: *Client, level: Level, data: *u8,
length: usize) engine.Result;
```

## fun poll

```mach
pub fun poll(client: *Client) engine.Result;
```

## fun next_event

```mach
pub fun next_event(client: *Client, output: *engine.Event) bool;
```

## fun complete_event

```mach
pub fun complete_event(client: *Client, token: u64, accepted: bool) bool;
```

## fun close

```mach
pub fun close(client: *Client, description: record.AlertDescription) engine.Result;
```

## fun destroy

```mach
pub fun destroy(client: *Client) bool;
```

## fun traffic_keys

```mach
pub fun traffic_keys(client: *Client, event: *engine.Event,
key: contracts.SecretBuffer, iv: contracts.Buffer,
key_length: *usize) bool;
```

derive the record keys for the borrowed traffic-secret event

## fun snapshot

```mach
pub fun snapshot(client: *Client) engine.Snapshot;
```

## fun receive_record_limit

```mach
pub fun receive_record_limit(client: *Client) usize;
```

## fun send_record_limit

```mach
pub fun send_record_limit(client: *Client) usize;
```

