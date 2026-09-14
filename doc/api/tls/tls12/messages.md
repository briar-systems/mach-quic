# tls.tls12.messages

## val NAMED_CURVE

```mach
pub val NAMED_CURVE: u8 = 3
```

## val MAX_POINT

```mach
pub val MAX_POINT: usize = 65
```

## val MAX_SIGNATURE

```mach
pub val MAX_SIGNATURE: usize = 512
```

## val CERTIFICATE_TYPE_RSA

```mach
pub val CERTIFICATE_TYPE_RSA: u8 = 1
```

## val CERTIFICATE_TYPE_ECDSA

```mach
pub val CERTIFICATE_TYPE_ECDSA: u8 = 64
```

## rec ClientHello

```mach
pub rec ClientHello;
```

## rec ServerHello

```mach
pub rec ServerHello;
```

## rec CertificateMessage

```mach
pub rec CertificateMessage;
```

## rec CertificateIterator

```mach
pub rec CertificateIterator;
```

## rec ServerKeyExchange

```mach
pub rec ServerKeyExchange;
```

params is the exact signed prefix: curve type, curve, and point

## rec CertificateRequest

```mach
pub rec CertificateRequest;
```

## rec ClientKeyExchange

```mach
pub rec ClientKeyExchange;
```

## rec CertificateVerify

```mach
pub rec CertificateVerify;
```

## rec Finished

```mach
pub rec Finished;
```

## fun valid_signature_scheme

```mach
pub fun valid_signature_scheme(scheme: u16) bool;
```

## val RSA_PKCS1_SHA256

```mach
pub val RSA_PKCS1_SHA256: u16 = 0x0401
```

## val RSA_PKCS1_SHA384

```mach
pub val RSA_PKCS1_SHA384: u16 = 0x0501
```

## fun valid_named_curve

```mach
pub fun valid_named_curve(curve: u16) bool;
```

## fun decode_client_hello

```mach
pub fun decode_client_hello(message: *handshake.Message,
output: *ClientHello) error.Error;
```

## fun decode_server_hello

```mach
pub fun decode_server_hello(message: *handshake.Message,
output: *ServerHello) error.Error;
```

## fun encode_server_hello

```mach
pub fun encode_server_hello(value: *ServerHello,
output: contracts.Buffer) handshake.Progress;
```

## fun decode_certificate

```mach
pub fun decode_certificate(message: *handshake.Message,
output: *CertificateMessage) error.Error;
```

## fun certificate_iterator

```mach
pub fun certificate_iterator(message: *CertificateMessage) CertificateIterator;
```

## fun next_certificate

```mach
pub fun next_certificate(state: *CertificateIterator,
output: *contracts.Bytes) extensions.NextStatus;
```

## fun encode_certificate

```mach
pub fun encode_certificate(entries: contracts.Bytes,
output: contracts.Buffer) handshake.Progress;
```

## fun decode_server_key_exchange

```mach
pub fun decode_server_key_exchange(message: *handshake.Message,
output: *ServerKeyExchange) error.Error;
```

## fun encode_server_key_exchange

```mach
pub fun encode_server_key_exchange(value: *ServerKeyExchange,
output: contracts.Buffer) handshake.Progress;
```

## fun signed_params

```mach
pub fun signed_params(client_random: contracts.Bytes,
server_random: contracts.Bytes, params: contracts.Bytes, output: *u8,
capacity: usize, length: *usize) bool;
```

the exact bytes a server key exchange signature covers

## fun decode_certificate_request

```mach
pub fun decode_certificate_request(message: *handshake.Message,
output: *CertificateRequest) error.Error;
```

## fun encode_certificate_request

```mach
pub fun encode_certificate_request(value: *CertificateRequest,
output: contracts.Buffer) handshake.Progress;
```

## fun decode_server_hello_done

```mach
pub fun decode_server_hello_done(message: *handshake.Message) error.Error;
```

## fun encode_server_hello_done

```mach
pub fun encode_server_hello_done(output: contracts.Buffer) handshake.Progress;
```

## fun decode_client_key_exchange

```mach
pub fun decode_client_key_exchange(message: *handshake.Message, curve: u16,
output: *ClientKeyExchange) error.Error;
```

## fun encode_client_key_exchange

```mach
pub fun encode_client_key_exchange(value: contracts.Bytes,
output: contracts.Buffer) handshake.Progress;
```

## fun decode_certificate_verify

```mach
pub fun decode_certificate_verify(message: *handshake.Message,
output: *CertificateVerify) error.Error;
```

## fun encode_certificate_verify

```mach
pub fun encode_certificate_verify(value: *CertificateVerify,
output: contracts.Buffer) handshake.Progress;
```

## fun decode_finished

```mach
pub fun decode_finished(message: *handshake.Message,
output: *Finished) error.Error;
```

## fun encode_finished

```mach
pub fun encode_finished(value: contracts.Bytes,
output: contracts.Buffer) handshake.Progress;
```

## fun encode_client_hello

```mach
pub fun encode_client_hello(value: *ClientHello,
output: contracts.Buffer) handshake.Progress;
```

