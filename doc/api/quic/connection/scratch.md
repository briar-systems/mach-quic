[quic](../README.md) / [connection](README.md) / **scratch**

# quic.connection.scratch

the buffers a connection needs only while one of its calls runs

every connection on a pump shares one pair. a connection binds the pair at
init and lends it to the core around each call. a second call while one is
running, whether reentry or another thread, is refused rather than allowed to
corrupt the first. the core leaves no secret byte behind when a call returns

Source: [`src/connection/scratch.mach`](../../../../src/connection/scratch.mach)

Uses types from [`quic.frame.frame`](../frame/frame.md), [`quic.recovery.recovery`](../recovery/recovery.md).

| Type | | |
| :--- | :--- | :--- |
| [`Scratch`](#scratch) | `rec` |  |
| [`SecretScratch`](#secretscratch) | `rec` |  |

| On `Scratch` | |
| :--- | :--- |
| [`lend`](#lend) | claims both halves for `holder`, or neither |
| [`give_back`](#give_back) | returns both halves |
| [`idle`](#idle) | |

| Constants | |
| :--- | :--- |
| [`PAYLOAD`](#constants) | the largest UDP payload a connection handles |
| [`ACK_RANGES`](#constants), [`EVENTS`](#constants) | |

---

## Scratch

```mach
pub rec Scratch {
    holder:           i64;
    receive_header:   [PAYLOAD]u8;
    receive_decoded:  [PAYLOAD]u8;
    send_plaintext:   [PAYLOAD]u8;
    frame_ack_ranges: [ACK_RANGES]quic.frame.frame.AckRange;
    recovery_events:  [EVENTS]quic.recovery.recovery.Event;
}
```

### lend

```mach
pub fun lend(public: *Scratch, secret: *SecretScratch, holder: u64) bool
```

claims both halves for `holder`, or neither

### give_back

```mach
pub fun give_back(public: *Scratch, secret: *SecretScratch, holder: u64)
```

returns both halves. a holder that does not match leaves them untouched

### idle

```mach
pub fun idle(public: *Scratch, secret: *SecretScratch) bool
```

## SecretScratch

```mach
pub rec SecretScratch {
    holder:            i64;
    receive_plaintext: [PAYLOAD]^u8;
    send_plaintext:    [PAYLOAD]^u8;
}
```

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `PAYLOAD` | `usize` | `1500` | the largest UDP payload a connection handles |
| `ACK_RANGES` | `usize` | `32` |  |
| `EVENTS` | `usize` | `32` |  |

