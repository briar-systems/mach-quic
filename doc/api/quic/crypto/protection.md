[quic](../README.md) / [crypto](README.md) / **protection**

# quic.crypto.protection

rfc 9001 and rfc 9369 packet protection over caller-owned storage

Source: [`src/crypto/protection.mach`](../../../../src/crypto/protection.mach)

| Type | | |
| :--- | :--- | :--- |
| [`Algorithm`](#algorithm) | `def` |  |
| [`Level`](#level) | `def` |  |
| [`State`](#state) | `def` |  |
| [`Error`](#error) | `def` |  |
| [`Result`](#result) | `rec` |  |
| [`OpenResult`](#openresult) | `rec` |  |
| [`KeySet`](#keyset) | `rec` |  |
| [`Contexts`](#contexts) | `rec` | one direction's expanded aead and header protection keys, never copied |
| [`InitialKeys`](#initialkeys) | `rec` |  |
| [`SendKeys`](#sendkeys) | `rec` |  |
| [`ReceiveKeys`](#receivekeys) | `rec` |  |

| On `Algorithm` | |
| :--- | :--- |
| [`AES_128_GCM_SHA256`](#algorithm), [`AES_256_GCM_SHA384`](#algorithm), [`CHACHA20_POLY1305_SHA256`](#algorithm), [`hash_size`](#hash_size), [`key_size`](#key_size) | |

| On `Level` | |
| :--- | :--- |
| [`LEVEL_INITIAL`](#level), [`LEVEL_EARLY`](#level), [`LEVEL_HANDSHAKE`](#level), [`LEVEL_APPLICATION`](#level) | |

| On `State` | |
| :--- | :--- |
| [`STATE_EMPTY`](#state), [`STATE_ACTIVE`](#state), [`STATE_DISCARDED`](#state) | |

| On `Error` | |
| :--- | :--- |
| [`OK`](#error), [`INVALID_INPUT`](#error), [`OUTPUT_TOO_SMALL`](#error), [`INVALID_KEY`](#error), [`AUTH_FAILED`](#error), [`UNSUPPORTED_VERSION`](#error), [`UNSUPPORTED_ALGORITHM`](#error), [`KEYS_DISCARDED`](#error), [`PACKET_NUMBER_ERROR`](#error), [`SAMPLE_ERROR`](#error), [`KEY_UPDATE_ERROR`](#error), [`RESERVED_BITS`](#error), [`verify_retry`](#verify_retry) | |

| On `Result` | |
| :--- | :--- |
| [`retry_tag`](#retry_tag) | |

| On `KeySet` | |
| :--- | :--- |
| [`destroy`](#destroy) | wipes the key material and the contexts it was expanded into |
| [`bind`](#bind) | binds a set to the contexts it protects packets with, expanding its keys into them when it holds any |
| [`unbind`](#unbind) | wipes a set's contexts and forgets them, before their storage goes away |
| [`derive_tls`](#derive_tls), [`make_nonce`](#make_nonce), [`seal`](#seal), [`open`](#open), [`header_mask`](#header_mask), [`protect_header`](#protect_header), [`seal_packet`](#seal_packet), [`open_packet`](#open_packet) | |

| On `InitialKeys` | |
| :--- | :--- |
| [`derive_initial`](#derive_initial), [`destroy_initial`](#destroy_initial) | |

| On `SendKeys` | |
| :--- | :--- |
| [`destroy_send`](#destroy_send), [`init_send`](#init_send), [`confirm_handshake_send`](#confirm_handshake_send), [`note_sent`](#note_sent), [`note_acknowledged`](#note_acknowledged), [`initiate_update`](#initiate_update), [`respond_to_update`](#respond_to_update), [`seal_send_packet`](#seal_send_packet) | |

| On `ReceiveKeys` | |
| :--- | :--- |
| [`destroy_receive`](#destroy_receive), [`init_receive`](#init_receive), [`confirm_handshake_receive`](#confirm_handshake_receive), [`open_receive_packet`](#open_receive_packet), [`discard_previous`](#discard_previous), [`confirm_update_response`](#confirm_update_response) | |

| Functions | |
| :--- | :--- |
| [`expansion_count`](#expansion_count) | packet protection key expansions since the process started, a debug hook for tests |

| Constants | |
| :--- | :--- |
| [`MAX_SECRET_SIZE`](#constants), [`MAX_KEY_SIZE`](#constants), [`IV_SIZE`](#constants), [`SAMPLE_SIZE`](#constants), [`MASK_SIZE`](#constants), [`TAG_SIZE`](#constants), [`MAX_CONNECTION_ID`](#constants) | |

---

## Algorithm

```mach
pub def Algorithm: u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `AES_128_GCM_SHA256` | `1` |  |
| `AES_256_GCM_SHA384` | `2` |  |
| `CHACHA20_POLY1305_SHA256` | `3` |  |

### hash_size

```mach
pub fun hash_size(algorithm: Algorithm) usize
```

### key_size

```mach
pub fun key_size(algorithm: Algorithm) usize
```

## Level

```mach
pub def Level:     u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `LEVEL_INITIAL` | `1` |  |
| `LEVEL_EARLY` | `2` |  |
| `LEVEL_HANDSHAKE` | `3` |  |
| `LEVEL_APPLICATION` | `4` |  |

## State

```mach
pub def State:     u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `STATE_EMPTY` | `0` |  |
| `STATE_ACTIVE` | `1` |  |
| `STATE_DISCARDED` | `2` |  |

## Error

```mach
pub def Error:     u8
```

| Name | Value | |
| :--- | :--- | :--- |
| `OK` | `0` |  |
| `INVALID_INPUT` | `1` |  |
| `OUTPUT_TOO_SMALL` | `2` |  |
| `INVALID_KEY` | `3` |  |
| `AUTH_FAILED` | `4` |  |
| `UNSUPPORTED_VERSION` | `5` |  |
| `UNSUPPORTED_ALGORITHM` | `6` |  |
| `KEYS_DISCARDED` | `7` |  |
| `PACKET_NUMBER_ERROR` | `8` |  |
| `SAMPLE_ERROR` | `9` |  |
| `KEY_UPDATE_ERROR` | `10` |  |
| `RESERVED_BITS` | `11` |  |

### verify_retry

```mach
pub fun verify_retry(version: u32, original_destination_connection_id: crypto.contracts.Bytes,
    retry_without_tag: crypto.contracts.Bytes, tag: crypto.contracts.Bytes,
    pseudo_packet: crypto.contracts.Buffer) Error
```

## Result

```mach
pub rec Result {
    error:   Error;
    written: usize;
}
```

### retry_tag

```mach
pub fun retry_tag(version: u32, original_destination_connection_id: crypto.contracts.Bytes,
    retry_without_tag: crypto.contracts.Bytes, pseudo_packet: crypto.contracts.Buffer,
    output: crypto.contracts.SecretBuffer) Result
```

## OpenResult

```mach
pub rec OpenResult {
    error:             Error;
    written:           usize;
    header_len:        usize;
    packet_number:     u64;
    packet_number_len: u8;
    key_phase:         bool;
    reserved_bits:     bool;
    key_updated:       bool;
    generation:        u64;
}
```

## KeySet

```mach
pub rec KeySet {
    secret:     [48]^u8;
    key:        [32]^u8;
    iv:         [12]^u8;
    hp:         [32]^u8;
    secret_len: usize;
    key_len:    usize;
    hp_len:     usize;
    version:    u32;
    algorithm:  Algorithm;
    level:      Level;
    generation: u64;
    state:      State;
    # the contexts this set protects packets with, owned by whoever holds the
    # set and kept when the key material is wiped. a set nobody bound, such as
    # one sealing a single stateless packet, expands per packet
    aead:   *crypto.aead.aes_gcm.Context;
    header: *crypto.cipher.aes.Context;
}
```

### destroy

```mach
pub fun destroy(value: *KeySet)
```

wipes the key material and the contexts it was expanded into. the set stays
bound to them

### bind

```mach
pub fun bind(value: *KeySet, contexts: *Contexts) Error
```

binds a set to the contexts it protects packets with, expanding its keys
into them when it holds any

### unbind

```mach
pub fun unbind(value: *KeySet)
```

wipes a set's contexts and forgets them, before their storage goes away.
the key material is left as it is

### derive_tls

```mach
pub fun derive_tls(output: *KeySet, version: u32, level: Level,
    algorithm: Algorithm, traffic_secret: crypto.contracts.SecretBytes) Error
```

### make_nonce

```mach
pub fun make_nonce(value: *KeySet, packet_number: u64,
    output: crypto.contracts.Buffer) Error
```

### seal

```mach
pub fun seal(value: *KeySet, packet_number: u64, aad: crypto.contracts.Bytes,
    plaintext: crypto.contracts.SecretBytes, output: crypto.contracts.Buffer) Result
```

### open

```mach
pub fun open(value: *KeySet, packet_number: u64, aad: crypto.contracts.Bytes,
    input: crypto.contracts.Bytes, output: crypto.contracts.SecretBuffer) Result
```

### header_mask

```mach
pub fun header_mask(value: *KeySet, sample: crypto.contracts.Bytes,
    output: crypto.contracts.SecretBuffer) Result
```

### protect_header

```mach
pub fun protect_header(value: *KeySet, data: *u8, len: usize,
    packet_number_offset: usize, packet_number_len: u8) Error
```

### seal_packet

```mach
pub fun seal_packet(value: *KeySet, packet_number: u64, header: crypto.contracts.Bytes,
    packet_number_offset: usize, plaintext: crypto.contracts.SecretBytes,
    output: crypto.contracts.Buffer) Result
```

### open_packet

```mach
pub fun open_packet(value: *KeySet, expected_packet_number: u64,
    input: crypto.contracts.Bytes, packet_number_offset: usize,
    header_scratch: crypto.contracts.Buffer, plaintext: crypto.contracts.SecretBuffer) OpenResult
```

## Contexts

```mach
pub rec Contexts {
    aead:   crypto.aead.aes_gcm.Context;
    header: crypto.cipher.aes.Context;
}
```

one direction's expanded aead and header protection keys, never copied

## InitialKeys

```mach
pub rec InitialKeys {
    client: KeySet;
    server: KeySet;
    state:  State;
}
```

### derive_initial

```mach
pub fun derive_initial(output: *InitialKeys, version: u32,
    destination_connection_id: crypto.contracts.Bytes) Error
```

### destroy_initial

```mach
pub fun destroy_initial(value: *InitialKeys)
```

## SendKeys

```mach
pub rec SendKeys {
    current:              KeySet;
    phase:                bool;
    generation:           u64;
    updates:              u64;
    first_sent:           u64;
    largest_acked:        u64;
    largest_sent:         u64;
    handshake_confirmed:  bool;
    sent_current:         bool;
    acknowledged_current: bool;
    have_sent:            bool;
    state:                State;
    # header protection keys survive a key update, so only the aead context is
    # expanded again
    contexts: Contexts;
}
```

### destroy_send

```mach
pub fun destroy_send(value: *SendKeys)
```

### init_send

```mach
pub fun init_send(output: *SendKeys, version: u32, algorithm: Algorithm,
    traffic_secret: crypto.contracts.SecretBytes) Error
```

### confirm_handshake_send

```mach
pub fun confirm_handshake_send(value: *SendKeys) Error
```

### note_sent

```mach
pub fun note_sent(value: *SendKeys, packet_number: u64) Error
```

### note_acknowledged

```mach
pub fun note_acknowledged(value: *SendKeys, packet_number: u64) Error
```

### initiate_update

```mach
pub fun initiate_update(value: *SendKeys) Error
```

### respond_to_update

```mach
pub fun respond_to_update(value: *SendKeys, receive_generation: u64) Error
```

### seal_send_packet

```mach
pub fun seal_send_packet(value: *SendKeys, packet_number: u64,
    header: crypto.contracts.Bytes, packet_number_offset: usize,
    plaintext: crypto.contracts.SecretBytes, output: crypto.contracts.Buffer) Result
```

## ReceiveKeys

```mach
pub rec ReceiveKeys {
    previous:                  KeySet;
    current:                   KeySet;
    next:                      KeySet;
    phase:                     bool;
    generation:                u64;
    current_floor:             u64;
    largest_current:           u64;
    update_packet_number:      u64;
    updates:                   u64;
    have_previous:             bool;
    have_current_packet:       bool;
    handshake_confirmed:       bool;
    update_response_confirmed: bool;
    state:                     State;
    # one aead context per key phase, bound to the set using it and moved with
    # it on rotation. next is expanded by the first packet that needs it
    aead: [3]crypto.aead.aes_gcm.Context;
    # header protection keys never change on a key update (rfc 9001 section
    # 6), so one context serves every phase, bound to current
    header: crypto.cipher.aes.Context;
}
```

### destroy_receive

```mach
pub fun destroy_receive(value: *ReceiveKeys)
```

### init_receive

```mach
pub fun init_receive(output: *ReceiveKeys, version: u32, algorithm: Algorithm,
    traffic_secret: crypto.contracts.SecretBytes) Error
```

### confirm_handshake_receive

```mach
pub fun confirm_handshake_receive(value: *ReceiveKeys) Error
```

### open_receive_packet

```mach
pub fun open_receive_packet(value: *ReceiveKeys, expected_packet_number: u64,
    input: crypto.contracts.Bytes, packet_number_offset: usize,
    header_scratch: crypto.contracts.Buffer, plaintext: crypto.contracts.SecretBuffer) OpenResult
```

### discard_previous

```mach
pub fun discard_previous(value: *ReceiveKeys) Error
```

### confirm_update_response

```mach
pub fun confirm_update_response(value: *ReceiveKeys, generation: u64,
    acknowledged_packet_number: u64) Error
```

## Functions

### expansion_count

Only where `$mach.build.mode == $mach.mode.debug`.

```mach
pub fun expansion_count() u64
```

packet protection key expansions since the process started, a debug hook
for tests

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `MAX_SECRET_SIZE` | `usize` | `48` |  |
| `MAX_KEY_SIZE` | `usize` | `32` |  |
| `IV_SIZE` | `usize` | `12` |  |
| `SAMPLE_SIZE` | `usize` | `16` |  |
| `MASK_SIZE` | `usize` | `5` |  |
| `TAG_SIZE` | `usize` | `16` |  |
| `MAX_CONNECTION_ID` | `usize` | `20` |  |

