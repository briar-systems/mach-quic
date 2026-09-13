# tls.session

## val KEY_NAME_SIZE

```mach
pub val KEY_NAME_SIZE: usize = 16
```

## val TICKET_KEY_SIZE

```mach
pub val TICKET_KEY_SIZE: usize = 32
```

## val TICKET_NONCE_SIZE

```mach
pub val TICKET_NONCE_SIZE: usize = 12
```

## val TICKET_TAG_SIZE

```mach
pub val TICKET_TAG_SIZE: usize = 16
```

## val MAX_TICKET_KEYS

```mach
pub val MAX_TICKET_KEYS: usize = 4
```

## val MAX_SECRET

```mach
pub val MAX_SECRET: usize = 48
```

## val MAX_ALPN

```mach
pub val MAX_ALPN: usize = 255
```

## val MAX_SERVER_NAME

```mach
pub val MAX_SERVER_NAME: usize = 253
```

## val NONCE_SIZE

```mach
pub val NONCE_SIZE: usize = 8
```

## val STATE_FIXED_SIZE

```mach
pub val STATE_FIXED_SIZE: usize = 2 + 2 + 1 + MAX_SECRET + 8 + 4 + 4 + 4 + 8 + 1
```

version, suite, secret length, secret, issued, lifetime, age add,
max early data, credential generation, flags, alpn, server name

## val MAX_STATE_BYTES

```mach
pub val MAX_STATE_BYTES: usize = STATE_FIXED_SIZE + 1 + MAX_ALPN + 1 +
MAX_SERVER_NAME
```

## val MAX_TICKET_BYTES

```mach
pub val MAX_TICKET_BYTES: usize = KEY_NAME_SIZE + TICKET_NONCE_SIZE +
MAX_STATE_BYTES + TICKET_TAG_SIZE
```

## val DEFAULT_MAX_TICKETS

```mach
pub val DEFAULT_MAX_TICKETS: usize = 8
```

## val MAX_REPLAY_ENTRIES

```mach
pub val MAX_REPLAY_ENTRIES: usize = 512
```

## val MAX_TICKET_LIFETIME_SECONDS

```mach
pub val MAX_TICKET_LIFETIME_SECONDS: u32 = 604800
```

## def ReplayPolicy

```mach
pub def ReplayPolicy: u8
```

## val REPLAY_PERMISSIVE

```mach
pub val REPLAY_PERMISSIVE: ReplayPolicy = 0
```

a ticket may be presented more than once; the default for compatibility

## val REPLAY_SINGLE_USE

```mach
pub val REPLAY_SINGLE_USE: ReplayPolicy = 1
```

a ticket binder is admitted exactly once inside its lifetime

## val STATE_CLIENT_AUTHENTICATED

```mach
pub val STATE_CLIENT_AUTHENTICATED: u8 = 1
```

## rec State

```mach
pub rec State;
```

the session a server seals into a ticket and recovers from one

## rec TicketKey

```mach
pub rec TicketKey;
```

## rec KeyRing

```mach
pub rec KeyRing;
```

one ring seals under exactly one key while older keys stay openable

## rec ReplayWindow

```mach
pub rec ReplayWindow;
```

## rec Ticket

```mach
pub rec Ticket;
```

one retained client ticket and everything needed to offer it again

## rec ClientStore

```mach
pub rec ClientStore;
```

## fun empty_state

```mach
pub fun empty_state() State;
```

## fun state_destroy

```mach
pub fun state_destroy(value: *State);
```

## fun keyring_init

```mach
pub fun keyring_init(ring: *KeyRing, entropy: *secret.Entropy, now: i64,
seal_lifetime_seconds: u32, overlap_seconds: u32,
ticket_lifetime_seconds: u32) bool;
```

## fun keyring_rotate

```mach
pub fun keyring_rotate(ring: *KeyRing, entropy: *secret.Entropy,
now: i64) bool;
```

retire the sealing key while every prior key stays openable for the overlap

## fun keyring_generation

```mach
pub fun keyring_generation(ring: *KeyRing) u64;
```

## fun keyring_openable

```mach
pub fun keyring_openable(ring: *KeyRing, now: i64) usize;
```

## fun keyring_destroy

```mach
pub fun keyring_destroy(ring: *KeyRing);
```

## fun seal

```mach
pub fun seal(ring: *KeyRing, value: *State, now: i64,
entropy: *secret.Entropy, output: contracts.Buffer) usize;
```

seal one session into an opaque ticket under the current ticket key

## fun open

```mach
pub fun open(ring: *KeyRing, ticket: contracts.Bytes, now: i64,
output: *State) bool;
```

recover a session from a ticket sealed by any key still inside its overlap

## fun replay_init

```mach
pub fun replay_init(window: *ReplayWindow) bool;
```

## fun replay_admit

```mach
pub fun replay_admit(window: *ReplayWindow, binder: contracts.Bytes,
expires_at: i64, now: i64) bool;
```

admit one opaque value exactly once inside its lifetime, and fail closed when
the bounded window is full. a server keys this on the ticket identity, which
is stable across presentations, rather than on a binder, which is not

## fun replay_live

```mach
pub fun replay_live(window: *ReplayWindow) usize;
```

## fun replay_destroy

```mach
pub fun replay_destroy(window: *ReplayWindow);
```

## fun client_store_init

```mach
pub fun client_store_init(store: *ClientStore) bool;
```

## fun client_store_save

```mach
pub fun client_store_save(store: *ClientStore, value: *Ticket) bool;
```

retain one ticket, evicting the oldest when the bounded ring is full

## fun client_store_take

```mach
pub fun client_store_take(store: *ClientStore, server_name: contracts.Bytes,
now: i64, output: *Ticket) bool;
```

take the freshest unexpired ticket for one name, removing it from the store

## fun client_store_count

```mach
pub fun client_store_count(store: *ClientStore) usize;
```

## fun client_store_destroy

```mach
pub fun client_store_destroy(store: *ClientStore);
```

## fun ticket_destroy

```mach
pub fun ticket_destroy(value: *Ticket);
```

