# tls.server

## val MAX_KEY_SHARE

```mach
pub val MAX_KEY_SHARE: usize = 65
```

## val MAX_PUBLIC_KEY

```mach
pub val MAX_PUBLIC_KEY: usize = 512
```

## val MAX_SIGNATURE

```mach
pub val MAX_SIGNATURE: usize = 512
```

## val MAX_SIGNED_CONTEXT

```mach
pub val MAX_SIGNED_CONTEXT: usize = 64 + 34 + 1 + 48
```

## val MAX_QUEUED_EVENTS

```mach
pub val MAX_QUEUED_EVENTS: usize = 12
```

## val MAX_TICKETS_PER_CONNECTION

```mach
pub val MAX_TICKETS_PER_CONNECTION: u8 = 4
```

## val TICKET_MESSAGE_BYTES

```mach
pub val TICKET_MESSAGE_BYTES: usize = 4 + 4 + 4 + 1 + session.NONCE_SIZE + 2 +
session.MAX_TICKET_BYTES + 2
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

## rec Server

```mach
pub rec Server;
```

## fun aliases_borrowed

```mach
pub fun aliases_borrowed(server: *Server, data: *u8, len: usize) bool;
```

## fun aliases_configuration

```mach
pub fun aliases_configuration(server: *Server, data: *u8, len: usize) bool;
```

## fun storage_requirements

```mach
pub fun storage_requirements(value: *config.ServerConfig, extra: ExtraExtension,
hello: *usize, flight: *usize) bool;
```

exact output storage a listener needs before it can accept a connection

## fun config_valid

```mach
pub fun config_valid(value: *config.ServerConfig, storage: *Storage,
extra: ExtraExtension, peer_extension: u16) bool;
```

## fun init

```mach
pub fun init(server: *Server, configuration: *config.ServerConfig,
storage: Storage, extra: ExtraExtension, peer_extension: u16) bool;
```

## fun start

```mach
pub fun start(server: *Server, verification_time: i64) engine.Result;
```

## fun request_key_update

```mach
pub fun request_key_update(server: *Server, request: u8) engine.Result;
```

ask the peer for a fresh send key, and optionally for one of its own

## fun ingest

```mach
pub fun ingest(server: *Server, level: engine.Level, data: *u8,
length: usize) engine.Result;
```

## fun poll

```mach
pub fun poll(server: *Server) engine.Result;
```

## fun next_event

```mach
pub fun next_event(server: *Server, output: *engine.Event) bool;
```

## fun complete_event

```mach
pub fun complete_event(server: *Server, token: u64, accepted: bool) bool;
```

## fun traffic_keys

```mach
pub fun traffic_keys(server: *Server, event: *engine.Event,
key: contracts.SecretBuffer, iv: contracts.Buffer,
key_length: *usize) bool;
```

## fun close

```mach
pub fun close(server: *Server,
description: record.AlertDescription) engine.Result;
```

## fun destroy

```mach
pub fun destroy(server: *Server) bool;
```

## fun snapshot

```mach
pub fun snapshot(server: *Server) engine.Snapshot;
```

## fun receive_record_limit

```mach
pub fun receive_record_limit(server: *Server) usize;
```

## fun send_record_limit

```mach
pub fun send_record_limit(server: *Server) usize;
```

