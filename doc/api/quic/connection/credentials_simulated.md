[quic](../README.md) / [connection](README.md) / **credentials_simulated**

# quic.connection.credentials_simulated

the ed25519 test chain shared by every binding that needs a real mach-tls peer

Source: [`src/connection/credentials_simulated.mach`](../../../../src/connection/credentials_simulated.mach)

| Functions | |
| :--- | :--- |
| [`test_clock`](#test_clock) | one clock every test engine reads, frozen inside the test chain's validity |
| [`deterministic_entropy`](#deterministic_entropy) | |
| [`load_credentials`](#load_credentials) | an ed25519 chain for api.example.com valid from 2026-08-28 to 2027-08-28 |
| [`anchor`](#anchor) | the root the leaf chains to, for a client trust store |

| Constants | |
| :--- | :--- |
| [`VERIFICATION_TIME`](#constants), [`ROOT_LENGTH`](#constants), [`LEAF_LENGTH`](#constants) | |

---

## Functions

### test_clock

```mach
pub fun test_clock() *tls.clock.Source
```

one clock every test engine reads, frozen inside the test chain's validity

### deterministic_entropy

```mach
#[constant_time("soft")]
pub fun deterministic_entropy(context: ptr, secret_context: *^u8,
    destination: *^u8, length: usize) i64
```

### load_credentials

```mach
pub fun load_credentials(identity: *tls.cert.credentials.Identity,
    chain_storage: *pki.cert.Certificate,
    key: *crypto.encoding.keys.PrivateKey, owner: *crypto.secret.Allocator) bool
```

an ed25519 chain for api.example.com valid from 2026-08-28 to 2027-08-28

### anchor

```mach
pub fun anchor() pki.cert.Certificate
```

the root the leaf chains to, for a client trust store

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `VERIFICATION_TIME` | `i64` | `1800000000` |  |
| `ROOT_LENGTH` | `usize` | `341` |  |
| `LEAF_LENGTH` | `usize` | `393` |  |

