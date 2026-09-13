# tls.handshake

## def MessageType

```mach
pub def MessageType: u8
```

## def ProgressStatus

```mach
pub def ProgressStatus: u8
```

## val CLIENT_HELLO

```mach
pub val CLIENT_HELLO:         MessageType = 1
```

## val SERVER_HELLO

```mach
pub val SERVER_HELLO:         MessageType = 2
```

## val NEW_SESSION_TICKET

```mach
pub val NEW_SESSION_TICKET:   MessageType = 4
```

## val END_OF_EARLY_DATA

```mach
pub val END_OF_EARLY_DATA:    MessageType = 5
```

## val ENCRYPTED_EXTENSIONS

```mach
pub val ENCRYPTED_EXTENSIONS: MessageType = 8
```

## val CERTIFICATE

```mach
pub val CERTIFICATE:          MessageType = 11
```

## val CERTIFICATE_REQUEST

```mach
pub val CERTIFICATE_REQUEST:  MessageType = 13
```

## val CERTIFICATE_VERIFY

```mach
pub val CERTIFICATE_VERIFY:   MessageType = 15
```

## val FINISHED

```mach
pub val FINISHED:             MessageType = 20
```

## val KEY_UPDATE

```mach
pub val KEY_UPDATE:           MessageType = 24
```

## val MESSAGE_HASH

```mach
pub val MESSAGE_HASH:         MessageType = 254
```

## val HELLO_REQUEST

```mach
pub val HELLO_REQUEST:        MessageType = 0
```

## val SERVER_KEY_EXCHANGE

```mach
pub val SERVER_KEY_EXCHANGE:  MessageType = 12
```

## val SERVER_HELLO_DONE

```mach
pub val SERVER_HELLO_DONE:    MessageType = 14
```

## val CLIENT_KEY_EXCHANGE

```mach
pub val CLIENT_KEY_EXCHANGE:  MessageType = 16
```

## val PROGRESSED

```mach
pub val PROGRESSED:  ProgressStatus = 0
```

## val NEED_INPUT

```mach
pub val NEED_INPUT:  ProgressStatus = 1
```

## val NEED_OUTPUT

```mach
pub val NEED_OUTPUT: ProgressStatus = 2
```

## val COMPLETE

```mach
pub val COMPLETE:    ProgressStatus = 3
```

## val REJECTED

```mach
pub val REJECTED:    ProgressStatus = 4
```

## val HEADER_SIZE

```mach
pub val HEADER_SIZE: usize = 4
```

## val MAX_BODY_SIZE

```mach
pub val MAX_BODY_SIZE: usize = 0xFFFFFF
```

## rec Header

```mach
pub rec Header;
```

## rec Message

```mach
pub rec Message;
```

## rec Progress

```mach
pub rec Progress;
```

## fun parse

```mach
pub fun parse(input: *u8, length: usize, limit: usize, output: *Message) Progress;
```

parse one complete handshake frame without consuming partial input

## fun parse_version

```mach
pub fun parse_version(input: *u8, length: usize, limit: usize, tls12: bool,
output: *Message) Progress;
```

the tls 1.2 message set is disjoint enough that each version keeps its own

## fun serialize

```mach
pub fun serialize(message_type: MessageType, body: contracts.Bytes,
output: contracts.Buffer) Progress;
```

serialize one frame transactionally into caller-owned storage

## fun serialize_version

```mach
pub fun serialize_version(message_type: MessageType, body: contracts.Bytes,
tls12: bool, output: contracts.Buffer) Progress;
```

