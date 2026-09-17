# quic.crypto.protection

## def Algorithm

```mach
pub def Algorithm: u8
```

## def Level

```mach
pub def Level:     u8
```

## def State

```mach
pub def State:     u8
```

## def Error

```mach
pub def Error:     u8
```

## val AES_128_GCM_SHA256

```mach
pub val AES_128_GCM_SHA256:       Algorithm = 1
```

## val AES_256_GCM_SHA384

```mach
pub val AES_256_GCM_SHA384:       Algorithm = 2
```

## val CHACHA20_POLY1305_SHA256

```mach
pub val CHACHA20_POLY1305_SHA256: Algorithm = 3
```

## val LEVEL_INITIAL

```mach
pub val LEVEL_INITIAL:     Level = 1
```

## val LEVEL_EARLY

```mach
pub val LEVEL_EARLY:       Level = 2
```

## val LEVEL_HANDSHAKE

```mach
pub val LEVEL_HANDSHAKE:   Level = 3
```

## val LEVEL_APPLICATION

```mach
pub val LEVEL_APPLICATION: Level = 4
```

## val STATE_EMPTY

```mach
pub val STATE_EMPTY:     State = 0
```

## val STATE_ACTIVE

```mach
pub val STATE_ACTIVE:    State = 1
```

## val STATE_DISCARDED

```mach
pub val STATE_DISCARDED: State = 2
```

## val OK

```mach
pub val OK:                    Error = 0
```

## val INVALID_INPUT

```mach
pub val INVALID_INPUT:         Error = 1
```

## val OUTPUT_TOO_SMALL

```mach
pub val OUTPUT_TOO_SMALL:      Error = 2
```

## val INVALID_KEY

```mach
pub val INVALID_KEY:           Error = 3
```

## val AUTH_FAILED

```mach
pub val AUTH_FAILED:           Error = 4
```

## val UNSUPPORTED_VERSION

```mach
pub val UNSUPPORTED_VERSION:   Error = 5
```

## val UNSUPPORTED_ALGORITHM

```mach
pub val UNSUPPORTED_ALGORITHM: Error = 6
```

## val KEYS_DISCARDED

```mach
pub val KEYS_DISCARDED:        Error = 7
```

## val PACKET_NUMBER_ERROR

```mach
pub val PACKET_NUMBER_ERROR:   Error = 8
```

## val SAMPLE_ERROR

```mach
pub val SAMPLE_ERROR:          Error = 9
```

## val KEY_UPDATE_ERROR

```mach
pub val KEY_UPDATE_ERROR:      Error = 10
```

## val RESERVED_BITS

```mach
pub val RESERVED_BITS:         Error = 11
```

## val MAX_SECRET_SIZE

```mach
pub val MAX_SECRET_SIZE:   usize = 48
```

## val MAX_KEY_SIZE

```mach
pub val MAX_KEY_SIZE:      usize = 32
```

## val IV_SIZE

```mach
pub val IV_SIZE:           usize = 12
```

## val SAMPLE_SIZE

```mach
pub val SAMPLE_SIZE:       usize = 16
```

## val MASK_SIZE

```mach
pub val MASK_SIZE:         usize = 5
```

## val TAG_SIZE

```mach
pub val TAG_SIZE:          usize = 16
```

## val MAX_CONNECTION_ID

```mach
pub val MAX_CONNECTION_ID: usize = 20
```

## rec Result

```mach
pub rec Result;
```

## rec OpenResult

```mach
pub rec OpenResult;
```

## rec KeySet

```mach
pub rec KeySet;
```

## rec InitialKeys

```mach
pub rec InitialKeys;
```

## rec SendKeys

```mach
pub rec SendKeys;
```

## rec ReceiveKeys

```mach
pub rec ReceiveKeys;
```

## fun hash_size

```mach
pub fun hash_size(algorithm: Algorithm) usize;
```

## fun key_size

```mach
pub fun key_size(algorithm: Algorithm) usize;
```

## fun destroy

```mach
pub fun destroy(value: *KeySet);
```

## fun derive_tls

```mach
pub fun derive_tls(output: *KeySet, version: u32, level: Level,
algorithm: Algorithm, traffic_secret: contracts.SecretBytes) Error;
```

## fun derive_initial

```mach
pub fun derive_initial(output: *InitialKeys, version: u32,
destination_connection_id: contracts.Bytes) Error;
```

## fun destroy_initial

```mach
pub fun destroy_initial(value: *InitialKeys);
```

## fun make_nonce

```mach
pub fun make_nonce(value: *KeySet, packet_number: u64,
output: contracts.Buffer) Error;
```

## fun seal

```mach
pub fun seal(value: *KeySet, packet_number: u64, aad: contracts.Bytes,
plaintext: contracts.SecretBytes, output: contracts.Buffer) Result;
```

## fun open

```mach
pub fun open(value: *KeySet, packet_number: u64, aad: contracts.Bytes,
input: contracts.Bytes, output: contracts.SecretBuffer) Result;
```

## fun header_mask

```mach
pub fun header_mask(value: *KeySet, sample: contracts.Bytes,
output: contracts.SecretBuffer) Result;
```

## fun protect_header

```mach
pub fun protect_header(value: *KeySet, data: *u8, len: usize,
packet_number_offset: usize, packet_number_len: u8) Error;
```

## fun seal_packet

```mach
pub fun seal_packet(value: *KeySet, packet_number: u64, header: contracts.Bytes,
packet_number_offset: usize, plaintext: contracts.SecretBytes,
output: contracts.Buffer) Result;
```

## fun open_packet

```mach
pub fun open_packet(value: *KeySet, expected_packet_number: u64,
input: contracts.Bytes, packet_number_offset: usize,
header_scratch: contracts.Buffer, plaintext: contracts.SecretBuffer) OpenResult;
```

## fun destroy_send

```mach
pub fun destroy_send(value: *SendKeys);
```

## fun init_send

```mach
pub fun init_send(output: *SendKeys, version: u32, algorithm: Algorithm,
traffic_secret: contracts.SecretBytes) Error;
```

## fun confirm_handshake_send

```mach
pub fun confirm_handshake_send(value: *SendKeys) Error;
```

## fun note_sent

```mach
pub fun note_sent(value: *SendKeys, packet_number: u64) Error;
```

## fun note_acknowledged

```mach
pub fun note_acknowledged(value: *SendKeys, packet_number: u64) Error;
```

## fun initiate_update

```mach
pub fun initiate_update(value: *SendKeys) Error;
```

## fun respond_to_update

```mach
pub fun respond_to_update(value: *SendKeys, receive_generation: u64) Error;
```

## fun destroy_receive

```mach
pub fun destroy_receive(value: *ReceiveKeys);
```

## fun init_receive

```mach
pub fun init_receive(output: *ReceiveKeys, version: u32, algorithm: Algorithm,
traffic_secret: contracts.SecretBytes) Error;
```

## fun confirm_handshake_receive

```mach
pub fun confirm_handshake_receive(value: *ReceiveKeys) Error;
```

## fun seal_send_packet

```mach
pub fun seal_send_packet(value: *SendKeys, packet_number: u64,
header: contracts.Bytes, packet_number_offset: usize,
plaintext: contracts.SecretBytes, output: contracts.Buffer) Result;
```

## fun open_receive_packet

```mach
pub fun open_receive_packet(value: *ReceiveKeys, expected_packet_number: u64,
input: contracts.Bytes, packet_number_offset: usize,
header_scratch: contracts.Buffer, plaintext: contracts.SecretBuffer) OpenResult;
```

## fun discard_previous

```mach
pub fun discard_previous(value: *ReceiveKeys) Error;
```

## fun confirm_update_response

```mach
pub fun confirm_update_response(value: *ReceiveKeys, generation: u64,
acknowledged_packet_number: u64) Error;
```

## fun retry_tag

```mach
pub fun retry_tag(version: u32, original_destination_connection_id: contracts.Bytes,
retry_without_tag: contracts.Bytes, pseudo_packet: contracts.Buffer,
output: contracts.SecretBuffer) Result;
```

## fun verify_retry

```mach
pub fun verify_retry(version: u32, original_destination_connection_id: contracts.Bytes,
retry_without_tag: contracts.Bytes, tag: contracts.Bytes,
pseudo_packet: contracts.Buffer) Error;
```

