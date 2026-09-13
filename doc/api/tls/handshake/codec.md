# tls.handshake.codec

## val HELLO_RETRY_RANDOM

```mach
pub val HELLO_RETRY_RANDOM: [32]u8 = [32]u8;
```

## val MAX_TICKET_LIFETIME

```mach
pub val MAX_TICKET_LIFETIME: u32 = 604800
```

## val UPDATE_NOT_REQUESTED

```mach
pub val UPDATE_NOT_REQUESTED: u8 = 0
```

## val UPDATE_REQUESTED

```mach
pub val UPDATE_REQUESTED: u8 = 1
```

## rec ClientHello

```mach
pub rec ClientHello;
```

## rec ServerHello

```mach
pub rec ServerHello;
```

## rec EncryptedExtensions

```mach
pub rec EncryptedExtensions;
```

## rec CertificateRequest

```mach
pub rec CertificateRequest;
```

## rec CertificateMessage

```mach
pub rec CertificateMessage;
```

## rec CertificateEntry

```mach
pub rec CertificateEntry;
```

## rec CertificateIterator

```mach
pub rec CertificateIterator;
```

## rec CertificateVerify

```mach
pub rec CertificateVerify;
```

## rec Finished

```mach
pub rec Finished;
```

## rec NewSessionTicket

```mach
pub rec NewSessionTicket;
```

## rec KeyUpdate

```mach
pub rec KeyUpdate;
```

## fun valid_cipher_suite

```mach
pub fun valid_cipher_suite(suite: tls13.CipherSuite) bool;
```

## fun valid_named_group

```mach
pub fun valid_named_group(group: tls13.NamedGroup) bool;
```

## fun valid_signature_scheme

```mach
pub fun valid_signature_scheme(scheme: tls13.SignatureScheme) bool;
```

## fun decode_client_hello

```mach
pub fun decode_client_hello(message: *handshake.Message, after_retry: bool,
output: *ClientHello) error.Error;
```

## fun decode_server_hello

```mach
pub fun decode_server_hello(message: *handshake.Message, output: *ServerHello) error.Error;
```

## fun decode_encrypted_extensions

```mach
pub fun decode_encrypted_extensions(message: *handshake.Message,
output: *EncryptedExtensions) error.Error;
```

## fun decode_certificate_request

```mach
pub fun decode_certificate_request(message: *handshake.Message,
output: *CertificateRequest) error.Error;
```

## fun decode_certificate

```mach
pub fun decode_certificate(message: *handshake.Message, allow_empty: bool,
output: *CertificateMessage) error.Error;
```

## fun certificate_iterator

```mach
pub fun certificate_iterator(message: *CertificateMessage) CertificateIterator;
```

## fun next_certificate

```mach
pub fun next_certificate(state: *CertificateIterator, output: *CertificateEntry) extensions.NextStatus;
```

## fun decode_certificate_verify

```mach
pub fun decode_certificate_verify(message: *handshake.Message,
output: *CertificateVerify) error.Error;
```

## fun decode_finished

```mach
pub fun decode_finished(message: *handshake.Message, hash_length: usize,
output: *Finished) error.Error;
```

## fun decode_new_session_ticket

```mach
pub fun decode_new_session_ticket(message: *handshake.Message,
output: *NewSessionTicket) error.Error;
```

## fun decode_key_update

```mach
pub fun decode_key_update(message: *handshake.Message, output: *KeyUpdate) error.Error;
```

## fun decode_empty

```mach
pub fun decode_empty(message: *handshake.Message, expected: handshake.MessageType) error.Error;
```

## fun decode_message_hash

```mach
pub fun decode_message_hash(message: *handshake.Message, hash_length: usize,
output: *contracts.Bytes) error.Error;
```

## fun validate_client

```mach
pub fun validate_client(value: *ClientHello) error.Error;
```

## fun encode_client_hello

```mach
pub fun encode_client_hello(value: *ClientHello, output: contracts.Buffer) handshake.Progress;
```

## fun client_hello_binder_prefix

```mach
pub fun client_hello_binder_prefix(encoded: contracts.Bytes, after_retry: bool,
output: *contracts.Bytes) error.Error;
```

return the encoded prefix covered by psk binder transcript hashes

## fun validate_server

```mach
pub fun validate_server(value: *ServerHello) error.Error;
```

## fun encode_server_hello

```mach
pub fun encode_server_hello(value: *ServerHello, output: contracts.Buffer) handshake.Progress;
```

## fun encode_extension_message

```mach
pub fun encode_extension_message(message_type: handshake.MessageType,
value: extensions.List, output: contracts.Buffer) handshake.Progress;
```

## fun encode_certificate_request

```mach
pub fun encode_certificate_request(value: *CertificateRequest,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_certificate

```mach
pub fun encode_certificate(value: *CertificateMessage, allow_empty: bool,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_certificate_verify

```mach
pub fun encode_certificate_verify(value: *CertificateVerify,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_finished

```mach
pub fun encode_finished(value: *Finished, output: contracts.Buffer) handshake.Progress;
```

## fun encode_message_hash

```mach
pub fun encode_message_hash(value: contracts.Bytes,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_new_session_ticket

```mach
pub fun encode_new_session_ticket(value: *NewSessionTicket,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_key_update

```mach
pub fun encode_key_update(value: KeyUpdate, output: contracts.Buffer) handshake.Progress;
```

## fun encode_empty

```mach
pub fun encode_empty(message_type: handshake.MessageType,
output: contracts.Buffer) handshake.Progress;
```

