# tls.record

## def ContentType

```mach
pub def ContentType: u8
```

## val INVALID

```mach
pub val INVALID:            ContentType = 0
```

## val CHANGE_CIPHER_SPEC

```mach
pub val CHANGE_CIPHER_SPEC: ContentType = 20
```

## val ALERT

```mach
pub val ALERT:              ContentType = 21
```

## val HANDSHAKE

```mach
pub val HANDSHAKE:          ContentType = 22
```

## val APPLICATION_DATA

```mach
pub val APPLICATION_DATA:   ContentType = 23
```

## def Protocol

```mach
pub def Protocol: u8
```

## val TLS12

```mach
pub val TLS12: Protocol = 12
```

## val TLS13

```mach
pub val TLS13: Protocol = 13
```

## def Algorithm

```mach
pub def Algorithm: u8
```

## val AES_128_GCM

```mach
pub val AES_128_GCM:       Algorithm = 1
```

## val AES_256_GCM

```mach
pub val AES_256_GCM:       Algorithm = 2
```

## val CHACHA20_POLY1305

```mach
pub val CHACHA20_POLY1305: Algorithm = 3
```

## def AlertLevel

```mach
pub def AlertLevel: u8
```

## val WARNING

```mach
pub val WARNING: AlertLevel = 1
```

## val FATAL

```mach
pub val FATAL:   AlertLevel = 2
```

## def AlertDescription

```mach
pub def AlertDescription: u8
```

## val CLOSE_NOTIFY

```mach
pub val CLOSE_NOTIFY:                   AlertDescription = 0
```

## val UNEXPECTED_MESSAGE_ALERT

```mach
pub val UNEXPECTED_MESSAGE_ALERT:       AlertDescription = 10
```

## val BAD_RECORD_MAC_ALERT

```mach
pub val BAD_RECORD_MAC_ALERT:           AlertDescription = 20
```

## val RECORD_OVERFLOW_ALERT

```mach
pub val RECORD_OVERFLOW_ALERT:          AlertDescription = 22
```

## val HANDSHAKE_FAILURE_ALERT

```mach
pub val HANDSHAKE_FAILURE_ALERT:        AlertDescription = 40
```

## val BAD_CERTIFICATE_ALERT

```mach
pub val BAD_CERTIFICATE_ALERT:          AlertDescription = 42
```

## val UNSUPPORTED_CERTIFICATE_ALERT

```mach
pub val UNSUPPORTED_CERTIFICATE_ALERT:  AlertDescription = 43
```

## val CERTIFICATE_REVOKED_ALERT

```mach
pub val CERTIFICATE_REVOKED_ALERT:      AlertDescription = 44
```

## val CERTIFICATE_EXPIRED_ALERT

```mach
pub val CERTIFICATE_EXPIRED_ALERT:      AlertDescription = 45
```

## val CERTIFICATE_UNKNOWN_ALERT

```mach
pub val CERTIFICATE_UNKNOWN_ALERT:      AlertDescription = 46
```

## val ILLEGAL_PARAMETER_ALERT

```mach
pub val ILLEGAL_PARAMETER_ALERT:        AlertDescription = 47
```

## val UNKNOWN_CA_ALERT

```mach
pub val UNKNOWN_CA_ALERT:               AlertDescription = 48
```

## val ACCESS_DENIED_ALERT

```mach
pub val ACCESS_DENIED_ALERT:            AlertDescription = 49
```

## val DECODE_ERROR_ALERT

```mach
pub val DECODE_ERROR_ALERT:             AlertDescription = 50
```

## val DECRYPT_ERROR_ALERT

```mach
pub val DECRYPT_ERROR_ALERT:            AlertDescription = 51
```

## val PROTOCOL_VERSION_ALERT

```mach
pub val PROTOCOL_VERSION_ALERT:         AlertDescription = 70
```

## val INSUFFICIENT_SECURITY_ALERT

```mach
pub val INSUFFICIENT_SECURITY_ALERT:    AlertDescription = 71
```

## val INTERNAL_ERROR_ALERT

```mach
pub val INTERNAL_ERROR_ALERT:           AlertDescription = 80
```

## val INAPPROPRIATE_FALLBACK_ALERT

```mach
pub val INAPPROPRIATE_FALLBACK_ALERT:   AlertDescription = 86
```

## val USER_CANCELED_ALERT

```mach
pub val USER_CANCELED_ALERT:            AlertDescription = 90
```

## val NO_RENEGOTIATION_ALERT

```mach
pub val NO_RENEGOTIATION_ALERT:          AlertDescription = 100
```

## val MISSING_EXTENSION_ALERT

```mach
pub val MISSING_EXTENSION_ALERT:        AlertDescription = 109
```

## val UNSUPPORTED_EXTENSION_ALERT

```mach
pub val UNSUPPORTED_EXTENSION_ALERT:    AlertDescription = 110
```

## val UNRECOGNIZED_NAME_ALERT

```mach
pub val UNRECOGNIZED_NAME_ALERT:        AlertDescription = 112
```

## val BAD_CERT_STATUS_RESPONSE_ALERT

```mach
pub val BAD_CERT_STATUS_RESPONSE_ALERT: AlertDescription = 113
```

## val UNKNOWN_PSK_IDENTITY_ALERT

```mach
pub val UNKNOWN_PSK_IDENTITY_ALERT:     AlertDescription = 115
```

## val CERTIFICATE_REQUIRED_ALERT

```mach
pub val CERTIFICATE_REQUIRED_ALERT:     AlertDescription = 116
```

## val NO_APPLICATION_PROTOCOL_ALERT

```mach
pub val NO_APPLICATION_PROTOCOL_ALERT:  AlertDescription = 120
```

## val NO_ALERT

```mach
pub val NO_ALERT:                       AlertDescription = 255
```

## val HEADER_SIZE

```mach
pub val HEADER_SIZE: usize = 5
```

## val TAG_SIZE

```mach
pub val TAG_SIZE: usize = 16
```

## val MAX_PLAINTEXT

```mach
pub val MAX_PLAINTEXT: usize = 16384
```

## val MAX_CIPHERTEXT_EXTRA

```mach
pub val MAX_CIPHERTEXT_EXTRA: usize = 256
```

## val MAX_CIPHERTEXT

```mach
pub val MAX_CIPHERTEXT: usize = MAX_PLAINTEXT + MAX_CIPHERTEXT_EXTRA
```

## val MAX_INNER_PLAINTEXT

```mach
pub val MAX_INNER_PLAINTEXT: usize = MAX_CIPHERTEXT - TAG_SIZE
```

## val TLS12_MAX_CIPHERTEXT

```mach
pub val TLS12_MAX_CIPHERTEXT: usize = MAX_PLAINTEXT + 2048
```

## val TLS12_AES_EXPLICIT_NONCE

```mach
pub val TLS12_AES_EXPLICIT_NONCE: usize = 8
```

## def ParseStatus

```mach
pub def ParseStatus: u8
```

## val PARSE_MORE

```mach
pub val PARSE_MORE:   ParseStatus = 0
```

## val PARSE_READY

```mach
pub val PARSE_READY:  ParseStatus = 1
```

## val PARSE_FAILED

```mach
pub val PARSE_FAILED: ParseStatus = 2
```

## rec Header

```mach
pub rec Header;
```

## rec Frame

```mach
pub rec Frame;
```

## rec Parsed

```mach
pub rec Parsed;
```

## rec AlertMessage

```mach
pub rec AlertMessage;
```

## def SealFun

```mach
pub def SealFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Bytes,
contracts.SecretBytes, contracts.Buffer) contracts.Operation
```

## def OpenFun

```mach
pub def OpenFun: fun(contracts.SecretBytes, contracts.Bytes, contracts.Bytes,
contracts.Bytes, contracts.SecretBuffer) contracts.Operation
```

## rec Aead

```mach
pub rec Aead;
```

## rec Cipher

```mach
pub rec Cipher;
```

## rec Sealed

```mach
pub rec Sealed;
```

## rec Opened

```mach
pub rec Opened;
```

## fun valid_tls13_alert

```mach
pub fun valid_tls13_alert(value: AlertDescription) bool;
```

## fun inspect

```mach
pub fun inspect(input: *u8, length: usize, protocol: Protocol, protected: bool) Parsed;
```

## fun encode_plain

```mach
pub fun encode_plain(content_type: ContentType, protocol: Protocol, content: contracts.Bytes, output: contracts.Buffer) Sealed;
```

## fun encode_alert

```mach
pub fun encode_alert(protocol: Protocol, description: AlertDescription, output: contracts.Buffer) Sealed;
```

## fun decode_alert

```mach
pub fun decode_alert(protocol: Protocol, data: *u8, length: usize, output: *AlertMessage) tls_error.Error;
```

## fun aead

```mach
pub fun aead(kind: Algorithm, seal: SealFun, open: OpenFun) Aead;
```

## fun aes_128_gcm

```mach
pub fun aes_128_gcm() Aead;
```

## fun aes_256_gcm

```mach
pub fun aes_256_gcm() Aead;
```

## fun chacha20_poly1305

```mach
pub fun chacha20_poly1305() Aead;
```

## fun destroy

```mach
pub fun destroy(cipher: *Cipher);
```

## fun install

```mach
pub fun install(cipher: *Cipher, protocol: Protocol, algorithm: Aead, key: contracts.SecretBytes, iv: contracts.Bytes) bool;
```

## fun seal

```mach
pub fun seal(
cipher: *Cipher,
content_type: ContentType,
content: contracts.SecretBytes,
padding: usize,
scratch: contracts.SecretBuffer,
output: contracts.Buffer,
) Sealed;
```

## fun open

```mach
pub fun open(cipher: *Cipher, input: *u8, length: usize, output: contracts.SecretBuffer) Opened;
```

