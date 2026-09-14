# tls.error

## def Error

```mach
pub def Error: u16
```

## val OK

```mach
pub val OK:                    Error = 0
```

## val CLOSED

```mach
pub val CLOSED:                Error = 1
```

## val CANCELLED

```mach
pub val CANCELLED:             Error = 2
```

## val TIMEOUT

```mach
pub val TIMEOUT:               Error = 3
```

## val DECODE_ERROR

```mach
pub val DECODE_ERROR:          Error = 4
```

## val UNEXPECTED_MESSAGE

```mach
pub val UNEXPECTED_MESSAGE:    Error = 5
```

## val ILLEGAL_PARAMETER

```mach
pub val ILLEGAL_PARAMETER:     Error = 6
```

## val BAD_RECORD_MAC

```mach
pub val BAD_RECORD_MAC:        Error = 7
```

## val HANDSHAKE_FAILURE

```mach
pub val HANDSHAKE_FAILURE:     Error = 8
```

## val BAD_CERTIFICATE

```mach
pub val BAD_CERTIFICATE:       Error = 9
```

## val CERTIFICATE_EXPIRED

```mach
pub val CERTIFICATE_EXPIRED:   Error = 10
```

## val UNKNOWN_CA

```mach
pub val UNKNOWN_CA:            Error = 11
```

## val HOSTNAME_MISMATCH

```mach
pub val HOSTNAME_MISMATCH:     Error = 12
```

## val UNSUPPORTED_ALGORITHM

```mach
pub val UNSUPPORTED_ALGORITHM: Error = 13
```

## val RESOURCE_LIMIT

```mach
pub val RESOURCE_LIMIT:        Error = 14
```

## val INTERNAL_ERROR

```mach
pub val INTERNAL_ERROR:        Error = 15
```

## val RECORD_OVERFLOW

```mach
pub val RECORD_OVERFLOW:       Error = 16
```

## val SEQUENCE_EXHAUSTED

```mach
pub val SEQUENCE_EXHAUSTED:    Error = 17
```

## val ALERT_RECEIVED

```mach
pub val ALERT_RECEIVED:        Error = 18
```

## val PROTOCOL_VERSION

```mach
pub val PROTOCOL_VERSION:      Error = 19
```

## val MISSING_EXTENSION

```mach
pub val MISSING_EXTENSION:     Error = 20
```

## val UNSUPPORTED_EXTENSION

```mach
pub val UNSUPPORTED_EXTENSION: Error = 21
```

## val NO_APPLICATION_PROTOCOL

```mach
pub val NO_APPLICATION_PROTOCOL: Error = 22
```

## val DECRYPT_ERROR

```mach
pub val DECRYPT_ERROR:         Error = 23
```

## val UNRECOGNIZED_NAME

```mach
pub val UNRECOGNIZED_NAME:     Error = 24
```

## val CERTIFICATE_REQUIRED

```mach
pub val CERTIFICATE_REQUIRED:  Error = 25
```

## val INAPPROPRIATE_FALLBACK

```mach
pub val INAPPROPRIATE_FALLBACK: Error = 26
```

## val NO_RENEGOTIATION

```mach
pub val NO_RENEGOTIATION:      Error = 27
```

## val INSUFFICIENT_SECURITY

```mach
pub val INSUFFICIENT_SECURITY: Error = 28
```

