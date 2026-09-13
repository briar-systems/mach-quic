# tls.handshake.extensions

## def ExtensionType

```mach
pub def ExtensionType: u16
```

## def Context

```mach
pub def Context: u8
```

## def NextStatus

```mach
pub def NextStatus: u8
```

## val SERVER_NAME

```mach
pub val SERVER_NAME:                    ExtensionType = 0
```

## val MAX_FRAGMENT_LENGTH

```mach
pub val MAX_FRAGMENT_LENGTH:            ExtensionType = 1
```

## val STATUS_REQUEST

```mach
pub val STATUS_REQUEST:                 ExtensionType = 5
```

## val SUPPORTED_GROUPS

```mach
pub val SUPPORTED_GROUPS:               ExtensionType = 10
```

## val SIGNATURE_ALGORITHMS

```mach
pub val SIGNATURE_ALGORITHMS:           ExtensionType = 13
```

## val APPLICATION_LAYER_PROTOCOL

```mach
pub val APPLICATION_LAYER_PROTOCOL:     ExtensionType = 16
```

## val SIGNED_CERTIFICATE_TIMESTAMP

```mach
pub val SIGNED_CERTIFICATE_TIMESTAMP:   ExtensionType = 18
```

## val PADDING

```mach
pub val PADDING:                        ExtensionType = 21
```

## val RECORD_SIZE_LIMIT

```mach
pub val RECORD_SIZE_LIMIT:              ExtensionType = 28
```

## val PRE_SHARED_KEY

```mach
pub val PRE_SHARED_KEY:                 ExtensionType = 41
```

## val EARLY_DATA

```mach
pub val EARLY_DATA:                     ExtensionType = 42
```

## val SUPPORTED_VERSIONS

```mach
pub val SUPPORTED_VERSIONS:             ExtensionType = 43
```

## val COOKIE

```mach
pub val COOKIE:                         ExtensionType = 44
```

## val PSK_KEY_EXCHANGE_MODES

```mach
pub val PSK_KEY_EXCHANGE_MODES:         ExtensionType = 45
```

## val CERTIFICATE_AUTHORITIES

```mach
pub val CERTIFICATE_AUTHORITIES:        ExtensionType = 47
```

## val OID_FILTERS

```mach
pub val OID_FILTERS:                    ExtensionType = 48
```

## val POST_HANDSHAKE_AUTH

```mach
pub val POST_HANDSHAKE_AUTH:            ExtensionType = 49
```

## val SIGNATURE_ALGORITHMS_CERT

```mach
pub val SIGNATURE_ALGORITHMS_CERT:      ExtensionType = 50
```

## val KEY_SHARE

```mach
pub val KEY_SHARE:                      ExtensionType = 51
```

## val EC_POINT_FORMATS

```mach
pub val EC_POINT_FORMATS:               ExtensionType = 11
```

## val EXTENDED_MASTER_SECRET

```mach
pub val EXTENDED_MASTER_SECRET:         ExtensionType = 23
```

## val RENEGOTIATION_INFO

```mach
pub val RENEGOTIATION_INFO:             ExtensionType = 0xFF01
```

## val CLIENT_HELLO

```mach
pub val CLIENT_HELLO:         Context = 1
```

## val SERVER_HELLO

```mach
pub val SERVER_HELLO:         Context = 2
```

## val HELLO_RETRY_REQUEST

```mach
pub val HELLO_RETRY_REQUEST:  Context = 3
```

## val ENCRYPTED_EXTENSIONS

```mach
pub val ENCRYPTED_EXTENSIONS: Context = 4
```

## val CERTIFICATE_REQUEST

```mach
pub val CERTIFICATE_REQUEST:  Context = 5
```

## val CERTIFICATE_ENTRY

```mach
pub val CERTIFICATE_ENTRY:    Context = 6
```

## val NEW_SESSION_TICKET

```mach
pub val NEW_SESSION_TICKET:   Context = 7
```

## val TLS12_SERVER_HELLO

```mach
pub val TLS12_SERVER_HELLO:   Context = 8
```

a tls 1.2 server hello carries extensions tls 1.3 forbids there, so it is a
context of its own rather than a relaxation of the tls 1.3 rules

## val NEXT_ITEM

```mach
pub val NEXT_ITEM:    NextStatus = 0
```

## val NEXT_DONE

```mach
pub val NEXT_DONE:    NextStatus = 1
```

## val NEXT_INVALID

```mach
pub val NEXT_INVALID: NextStatus = 2
```

## rec Extension

```mach
pub rec Extension;
```

## rec List

```mach
pub rec List;
```

## rec Iterator

```mach
pub rec Iterator;
```

## fun list

```mach
pub fun list(data: *u8, len: usize, context: Context) List;
```

## fun iterator

```mach
pub fun iterator(value: List) Iterator;
```

## fun next

```mach
pub fun next(state: *Iterator, output: *Extension) NextStatus;
```

## fun offers_tls13

```mach
pub fun offers_tls13(value: List) bool;
```

## fun validate

```mach
pub fun validate(value: List) error.Error;
```

## fun find

```mach
pub fun find(value: List, kind: ExtensionType, output: *Extension) bool;
```

## fun contains

```mach
pub fun contains(value: List, kind: ExtensionType) bool;
```

