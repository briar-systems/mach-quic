# Changelog

## [Unreleased]

## [0.20.1] - 2026-09-25

### Fixed

- A lost PATH_CHALLENGE or PATH_RESPONSE no longer fails path validation (#236). A challenge was sent once, so one lost datagram left the path unvalidated until its deadline of three probe timeouts, and a rebound client whose new port failed that way lost the connection with NO_VIABLE_PATH once the check of its old port failed too. A sent challenge now arms a resend a probe timeout later. If no response has arrived by then, the core queues a new challenge with fresh data for the same purpose, and each later wait doubles, as a probe timeout backs off (RFC 9000 8.2.1 and 9.4). No resend is armed past the validation deadline, so the default factor of three sends two challenges. A response to any of them validates the path. `path.on_timeout` reports a due resend in `TimeoutResult.resend` and `resend_purpose`, and the core's path timer covers resends. `path.Path` gains `challenge_resend_ns` and `challenge_backoff_ns`, and `path.Challenge` gains `resend_ns`. Once every challenge slot is held, a new challenge takes the slot of the oldest one sent for the same path and purpose. `assembly.Storage` is 4,656 bytes, up from 4,560, and `assembly.Connection` stays at 16,976.
- A path validated by an unpadded PATH_CHALLENGE now has its MTU validated (#237). Since #232 only a padded challenge validates the MTU, and a challenge the amplification limit kept below 1200 bytes left the path with `address_validated` but never `mtu_validated`, so MTU probing stayed blocked on it for the life of the connection. `path.receive_response` now sets the new `ValidationResult.validate_mtu` when it validates a path whose MTU is not validated, and the core queues a padded MTU challenge on that path with fresh data (RFC 9000 8.2.1 and 8.2.3). The validated address lifts the amplification limit, so the challenge goes out at once, and the resend from #236 covers its loss.
- A path whose validation failed no longer blocks its address for the rest of the connection (#238). `path.observe` answered every later packet from a PATH_FAILED address with STATUS_BLOCKED and offered no retry, so a peer that returned to it, for example after its challenges were lost, could never use that address again. A server now gives up the failed path on a non-probing packet from its address, once the handshake is confirmed, and handles the packet as one from a new address. Packets still in flight on the failed path do not hold it, because only the peer's packets from that address, which were being refused, could settle them. `path.Observation.released` names such a path, and the core detaches those packets' owners so they settle without charging any path (RFC 9000 9.4). That creates a fresh path and starts a fresh validation, subject to the same limits: amplification, the highest-numbered non-probing packet rule for migration, and a fresh generation, so stale tokens stay stale (RFC 9000 9.3). A probing packet from a failed address, a packet before handshake confirmation, one on a client, and one arriving while the failed path holds prepared work are still answered with STATUS_BLOCKED.
- A connection whose peer rebinds more than once no longer closes with NO_VIABLE_PATH (#235). The assembly holds two paths and never gave one up, so a second rebinding found no free slot, `path.observe` reported ERROR_CAPACITY as STATUS_ERROR and the core closed the connection. With every slot held, `observe` now gives up a path the connection no longer needs: not selected, not the validated fallback, and holding no prepared challenge, response, send reservation or MTU probe. A failed path goes first, then the one heard from least recently, and any validation under way on it is abandoned (RFC 9000 9.3). Packets still in flight on it no longer hold the slot. `path.Observation.released` names the path, and the core detaches those packets' owners so they settle without charging any path, since a new path may now hold the slot (RFC 9000 9.4). When nothing can be given up, the packet is refused with STATUS_BLOCKED and ERROR_CAPACITY and the connection stays open.

## [0.20.0] - 2026-09-25

### Changed

- **Breaking.** quic moves to mach-std 8 and requires mach 5.12 (#230). `[dep.std] version = "^8.0"` realized at v8.0.0, `[dep.crypto] version = "^0.22"` at v0.22.0 and `[dep.tls] version = "^0.12"` at v0.12.0, and the manifest requires `mach = "^5.12"`. Resolution is flat, so a consumer must move to std 8, crypto 0.22, tls 0.12 and mach 5.12 with this release. std 8 carries the typed secret view (mach-std#905) the handshake-level key contexts live in.
- Packet protection keeps its expanded keys instead of rebuilding them for every packet (#230). `protection.KeySet` refers to an AEAD context and a header-protection context through `aead` and `header`. `protection.bind` points them at a `protection.Contexts` its holder owns and expands the set's keys into it, and `protection.unbind` wipes and forgets them. `SendKeys` holds its direction's contexts inline, and `ReceiveKeys` holds one AEAD context per generation (previous, current and next) and one header-protection context, since header-protection keys do not change on a key update (RFC 9001 section 6). Installing 1-RTT keys expands them once, a key update expands only the new AEAD key, and the receive side expands its next generation on the first packet that needs it, so forged packets in a new key phase cost at most one expansion per phase. The Initial, 0-RTT and Handshake levels each take one secret pool chunk when their keys install, view it through std's typed secret view as two `Contexts` (`storage.source.view_secret`), and bind both directions' sets to them. No level of a connection expands a key per packet. A set nobody bound, such as the one the listener seals a single stateless packet with, still expands its keys for that packet. ChaCha20-Poly1305 has no expanded AEAD context and is unchanged. A debug-only `protection.expansion_count()` counts expansions. One test holds the 1-RTT counts, and another holds a live handshake at 24 expansions, once per key per level per peer, and none once it settles. Header protection uses `crypto.cipher.aes` and no longer imports `crypto.internal.aes`.
- Per-packet cost, measured on one linux-x86_64 machine in release builds with mach 5.12.0 against dev (`107f349`) built with the same compiler (#230). Each run seals and opens a 1,200-byte payload 20,000 times, in five interleaved rounds under an exclusive lock at load averages between 7 and 10. An AES-128-GCM 1-RTT packet took 194.7 microseconds before and 163.0 after (2.69 and 2.28 million user instructions). A Handshake-level packet went from 194.8 to 162.7, and a `KeySet` left unbound on this change still took 197.1, so the dependency moves alone do not change the cost. ChaCha20-Poly1305 went from 62.9 to 61.5. The same dev source built with mach 5.10.0 takes 131.5 microseconds and 1.96 million instructions for the AES packet, so under 5.12 this change is still slower than dev under 5.10. mach 5.12 accounts for that difference, not quic.
- Keep-alive cost, measured with hedge `fc6c51b` and hedge#274's probe, holding 5,000 QUIC connections with a one-second keep-alive (#230). The before build used hedge's pins with quic at dev (`107f349`). The after build moved hedge to std 8, crypto 0.22, http 0.19, tls 0.12, acme 0.8 and laurel 0.17, with quic at this change. Both were built with mach 5.12.0 and run in three interleaved 20 s windows under an exclusive lock, at load averages between 7 and 17. Hedge used 13,757 ms of CPU before and 10,760 after, and 81.4 and 44.3 billion user instructions. Per UDP datagram delivered on the host, that is 69.9 and 54.4 microseconds, and 414 and 224 thousand instructions. No window dropped a datagram. The before build under mach 5.10.0 took 68.1 microseconds and 347 thousand instructions per datagram.
- **Breaking.** `assembly.init_client` and `init_server` take a `std.memory.buffers.SecretSource` as `secret_chunks`, directly after the chunk source (#230). It must serve the same pool as the chunk source and bind typed views (`fn_bind`). Init refuses a nil one, one over another pool, or one without `fn_bind`, at `STAGE_STORAGE`. Handshake-level key contexts are charged to the connection's account on the send lane. `storage.source` gains `SecretProvider`, `SecretSource`, `take_secret`, `give_secret` and `view_secret`, and `supply.classes` names a fourth class, a secret 4,096-byte one (`CLASS_COUNT` is 4). `core.SecretStorage.context_chunks` is required, and core initialization refuses one without `fn_bind` or a chunk source without an account. `core.release_secret_chunks` gives back what a connection still holds.
- `assembly.Connection` is 16,976 bytes, up from 10,640 (#230). Most of that is the inline 1-RTT contexts, 1,992 bytes to send and 4,008 to receive. The rest is the handshake levels' chunk handles, the key sets' context pointers and the secret source, which std 8's `fn_bind` grows by 8 bytes. `assembly.Storage` stays at 4,560. During the handshake the dialer holds at most six send-lane chunks, up from five, and the listener eight, up from six. The extra chunks are the secret chunks of the handshake levels whose keys are live, and each goes back when its level's keys are discarded. A connection that accepted 0-RTT keeps those keys and their chunk until teardown.
- Tests run through a test-only `tests` artifact, `mach test . --lib tests` (#230). mach 5.12 tests only the selected artifact's closure (briar-systems/mach#3813), and the library does not reach `connection.assembly_live` or the simulated congestion, path, recovery and stream modules. `tools/test-selection` fails when a test declared under `src` is collected on no manifest target, and CI runs it. `mach build .` still builds the library alone.
- A transport callback no longer costs a system call (#231). The re-entry guard, which refuses a callback's own thread calling back into its driver and lets any other thread block on the driver lock, named the thread with `os.thread_current_id`, a `gettid` system call on linux, on every callback and every guarded entry point. It now uses `std.sync.thread.current_token`, which has the same contract (positive, never 0, distinct across live threads) and reads the thread pointer. `transport.Driver.callback_owner` is a `thread.Token`. On linux x86_64 only the main thread or a thread std spawned may call into a driver, since std 7.5.0 installs the thread pointer on those alone. Measured with hedge (`70b3ee1` on std 7.5.0, release build, linux-x86_64) and hedge#274's keep-alive probe. Over its whole run holding 2,000 QUIC connections with a one-second keep-alive, hedge under `strace -c` made 538,709 `gettid` calls before and none after. Holding 5,000 such connections, three interleaved 20 s windows per build gave a median of 9,367 ms of CPU before and 8,638 ms after, 47.5 and 43.7 microseconds per UDP datagram delivered on the host.
- Dependencies: `[dep.std] version = "^7.5"` realized at v7.5.0 (#231), for `sync.thread.current_token`. std 7.4.0 hands out a buffer slot never used before one given back, so the stream test that proves a reused chunk is untouched by the stream that released it now draws on a pool that keeps one released chunk per class.

### Fixed

- Connection setup no longer leaves a copy of the Initial keys on the stack (#242). `core.initialize` built the whole `Secrets` record in a local, derived the Initial keys into it and copied it out with an assignment, so the dead frame kept the key material. The keys now derive straight into the caller's `Secrets`, and a refusal after derivation wipes them and leaves the caller's record empty. Nothing in initialization copies a `Secrets` record holding keys or expanded contexts by assignment.

## [0.19.1] - 2026-09-23

### Fixed

- A bare FIN that arrives after the owner has read every byte is reported (#225). `receive_stream` closed the receive side as soon as such a FIN arrived, so no news was queued, `ready_stream` never named the stream and nothing prompted the owner to call `read_stream`, which would have returned the end. The same held for a peer stream opened by a bare FIN, which `accept_stream` handed over with no news. The receive side now closes only when `read_stream` hands the owner the end, as it already did for a FIN carrying data, so the FIN is readable news, `pending_stream_news` answers true until it is taken, and `accept_stream` queues it for a stream it opened. An owner must now read that end before `release_stream` accepts the stream, and `stream_snapshot` reports `receive_closed` only after it has.
- A server validates a peer's new address, so a rebound connection no longer stalls at the amplification limit (#232). `path.observe` reported `needs_validation` and `validate_previous` and the core acted on neither, so a path the peer moved to stayed unvalidated and the server could never send it more than three times what it received. The core now queues a PATH_CHALLENGE on the new path when the observation asks for one and on the validated path the peer left when it asks for that (RFC 9000 9.3 and 9.3.3), with data from the OS entropy source, and wakes the driver. A path already being validated gets no second challenge. A matching PATH_RESPONSE validates the path and lifts the cap. `path.validating_scoped` answers whether a path has a challenge queued or in flight.
- A peer's first application packet from a new address is no longer ignored when its packet number is at or below one the peer used in the Handshake space (#232). The core handed `path.observe` every packet's number as a migration candidate, so Initial and Handshake numbers raised the largest migration packet that a new path must exceed. A client that rebinds before its application packet numbers pass its handshake ones stayed on the old path. Only application-space packets now count as non-probing for migration (RFC 9000 9.3).
- An unpadded PATH_CHALLENGE is padded to 1200 bytes whenever the path's amplification allowance permits it, as a PATH_RESPONSE already was (RFC 9000 8.2.1), and a response validates the path's MTU only when its challenge went out padded, recorded in the new `path.Challenge.sent_padded`. A challenge queued as padded still waits until it can be padded. `assembly.Connection` stays at 10,640 bytes and `assembly.Storage` at 4,560.

## [0.19.0] - 2026-09-23

### Added

- `transport.pending_output(driver, now)` and `transport.pending_stream_news(driver)` answer whether a connection holds work its host must act on, with nothing changed and nothing allocated (#221). `pending_output` is whether the next `generate` at `now` would produce a datagram, for a buffer of at least the connection's maximum UDP payload. It is exact but for three documented edges: pending handshake work answers true, a pool refusal not yet answered by `storage_ready` answers false, and a cancellation recorded but not yet applied answers true. `pending_stream_news` is O(1): a stream has news its owner has not taken through `ready_stream`, or a peer stream waits for `accept_stream`. The README's "Pending work" section has the full table. Consumer: hedge's debug audit (hedge#182).
- `transport.Protocol` gains `pending_output: fun(*T, u64) bool`, served by `binding` from the new `core.pending_output`. `core.handshake_pending` names the handshake edge.
- Pure selections beside each prepare, each answering what the prepare would take without taking it: `stream.peek_scoped`, `peek_control_scoped` and `attempts_held`, `datagram.peek_scoped`, `handshake.peek_scoped`, and `path.peek_response_scoped`, `peek_challenge_scoped`, `peek_mtu_probe_scoped`, `peek_send_scoped`, `peek_mtu_send_scoped` and `peek_transport_scoped`. `stream.pending_news`, `ack.frame_size` and `packet.protected_header_size` size or answer without writing.

### Changed

- `generate` chooses its frame and checks its packet before it takes anything (#221). The choice (`select_frame`) and the packet's size, padding, header, history room, congestion admission, pacing and amplification check (`plan_packet`) are pure, and the frame is taken only once the plan says it would be sent, so a send held by congestion or the pacer no longer claims and then returns its frame. `generate` checks that the packet it encodes is the one planned.
- A send the pool refused a chunk waits for `storage_ready` before asking the pool again (#221). `generate` asked on every call. The pool registers the account on refusal, so the wake comes. A host that does not route the account's wake to `transport.storage_ready` stops sending on that path until it does, which #198 already requires.
- `assembly.Connection` is 10,640 bytes, from 10,624 (#221): the stream manager counts unaccepted peer streams, the core records the pool refusal and whether the provider's last poll ended waiting for input, and `Protocol` holds one more callback. `assembly.Storage` stays at 4,560.

## [0.18.1] - 2026-09-22

### Changed

- A connection checks the ranges it owns once, not on every call (#125). The storage lent at init cannot move while the connection is leased, so the core, the transport driver, the stream manager, the datagram queue and the handshake adapter each keep their owned ranges as a field, built at init after the init validation has proven them valid and disjoint, and the connection ID manager and handshake adapter no longer prove their storage disjoint again on every call. The core refreshes the entries backed by pool chunks (the owner table, each space's packet history, the two NEW_TOKEN chunks and the handshake-only storage) where it takes or gives those chunks, the driver empties its scope's entry when `finish_close` hands the scope back, and a send slot records its buffer's range when it is claimed. Per call, only the caller's buffers and the records' own addresses are checked. `ownership.secret_disjoint` compares the two ranges' ends instead of walking every byte address. Refusals and their codes are unchanged. On a loop of 300 handshakes (`establish_direct`, settle, close, release) in a release build, time in `ownership.*` falls from 5.7% to 1.6% of samples and the loop from 1.73 s to 1.69 s.
- `assembly.Connection` is 10,624 bytes, from 9,784, and `assembly.Storage` 4,560, from 4,464, for those cached ranges (#125). `transport.SendSlot` gains `range` and `transport.Driver` gains `owned`.

## [0.18.0] - 2026-09-20

### Changed

- Dependencies: `[dep.std] version = "^7.0"` realized at v7.0.2, `[dep.crypto] version = "^0.20"` at v0.20.0 and `[dep.tls] version = "^0.10"` at v0.10.0, all committed as gitlinks (#216). std 7.0.0 made `io.runtime.make(runtime, a, initial)` take the allocator every one of the runtime's allocations comes from and keep a copy of it, so the allocator's context must outlive the runtime. quic's only callers are two native transport tests in `transport.simulated`, which now hand the runtime a page allocator declared in the same scope ahead of it. Nothing in quic stores `data.toml.Value`, so its growth needed only the rebuild. `assembly.Connection` stays at 9,784 bytes and `assembly.Storage` at 4,464.

## [0.17.0] - 2026-09-19

### Added

- `listener.ClassifiedDatagram.token_length` (#212). For `DATAGRAM_INITIAL` it is the token length the Initial header carries, taken from the parse `classify_datagram` already does, and 0 for every other class, so a socket owner that classifies before admission learns whether an Initial carries a token without a second header parse. Consumer: briar-systems/hedge#242.

## [0.16.0] - 2026-09-19

### Added

- `listener.refuse(listener, request, error_code)` answers a client Initial with a stateless CONNECTION_CLOSE (#206). It writes one Initial packet to `request.output`, protected with the Initial keys the Initial's Destination Connection ID derives (RFC 9000 10.2.3): Destination and Source Connection IDs swapped from the request, no token, packet number 0, and one transport `CONNECTION_CLOSE` (0x1c) with `error_code`, frame type 0 and an empty reason. It creates no connection, takes no pending slot, charge or token, and composes with whatever `preflight` answered, so a server that decides at admission not to serve an Initial can refuse it with `core.CONNECTION_REFUSED` instead of dropping it and the client learns in one RTT rather than after PTO backoff. `Result.action` is `ACTION_REFUSE` with `output_count`, `ACTION_DROP` for a datagram that is not a well-formed Initial of a supported version, and `ACTION_ERROR` when the output cannot be produced. Consumer: briar-systems/hedge#231.

### Fixed

- A client no longer drops a server Initial carried in a datagram under 1200 bytes (#206). RFC 9000 14.1 has the server discard short Initial datagrams, and a server's own Initial need only be padded when ack-eliciting, so a stateless CONNECTION_CLOSE from a server is short and the client read none of them.
- `transport.begin_close`, `generate`, `receive_datagram` and `receive_native` on a driver whose close has settled answer `STATUS_CLOSED` (#207). They checked the caller's buffers against the driver's owned ranges before consulting its state, and a closed driver has handed its operation scope back, so that range was invalid and every such call failed with `ERROR_BUFFER`. A closed driver now answers closed before any buffer, ownership or scope check, and the owned-range set describes the scope only while the driver holds one. Found by mach-http (briar-systems/mach-http#145): after a deadline teardown the h3 engine's close never reached `CLOSED`.

## [0.15.0] - 2026-09-19

### Changed

- Dependencies: `[dep.std] version = "^6.0"` realized at v6.0.0, `[dep.crypto] version = "^0.18"` at v0.18.0 and `[dep.tls] version = "^0.9"` at v0.9.0, all committed as gitlinks, and `mach = "^5.9"` (#202). std 6.0.0 made `buffers.source_open_account` take a `buffers.Budgets` value that carries its lane count, which `supply.open_connection` now composes from quic's three lanes and the caller's extra ones. Its own signature and `assembly.Config` are unchanged. Nothing else std's migration guide names (sort, heap, map, set, the `ct` width names) is used here. crypto 0.14 through 0.18 and tls 0.9.0 changed no API quic calls: SHA-2 runs on std's hardware-dispatched states, secret word products use the processor multiply where mach admits it, and x25519 and Ed25519 compute on `u128`, so a handshake costs about a third of the instructions it did on crypto 0.13.
- `buffers.Source` grew a word in std 5.7.0 (`fn_measure`), so `assembly.Connection` is 9,784 bytes, from 9,776 (#202). `assembly.Storage` stays at 4,464.
- On aarch64-linux and aarch64-darwin, a program linking quic turns PSTATE.DIT on before `main` and refuses to start, with status 255, on a processor or kernel without the mode. This is crypto 0.17's DIT-required start through std 5.8; x86_64 and riscv64 are unaffected. CI passes `dit: required` to the shared pipeline, so the aarch64 legs test under `qemu-aarch64 -cpu max` on a runner without FEAT_DIT (#202).

## [0.14.0] - 2026-09-18

### Added

- A connection's account can be composed with the host's own lanes and handle (#198). `assembly.Config.extra_budgets` and `extra_lanes` append the host's budgets after quic's three lanes, and the source must declare exactly `supply.LANES + extra_lanes` lanes. A total above `supply.MAX_LANES` (8) is refused at `STAGE_CONFIG`. `assembly.Config.account_handle` is the handle the account is opened under, `source` by default, and a wake the source reports for it must reach `transport.storage_ready`. `supply.open_connection` takes the extra budgets, and `supply.pool_config_lanes`, `test_pool_lanes`, `make_test_lanes` and `source_lanes_of` are new.

### Changed

- **Breaking:** `supply.open_connection` takes two more arguments, the caller's budgets and their count (#198). `supply.open` is unchanged.

## [0.13.2] - 2026-09-18

### Fixed

- A datagram received between `generate` and its send completion no longer fails the connection (#190). `settle_flight` reclaimed a space's packet history as soon as nothing was tracked in it, but a prepared packet only enters the history at its completion, so the completion then failed with ERROR_HISTORY_FULL and INTERNAL_ERROR. A space's history now stays lent while any owner in that space is prepared. Found by hedge: about one HTTP/3 request in two failed on its interop lane.

## [0.13.1] - 2026-09-17

### Security

- `storage.source.open_connection` and `open`, and so `assembly.init_client` and `init_server`, now refuse a source that does not declare exactly `supply.LANES` (3) lanes, read through `buffers.source_lanes` (#180). A source that declares none is refused too, so a wrapping source must forward `fn_lanes`.

### Changed

- Dependencies: mach-std v5.4.0. `Source` grew by one word, so `assembly.Connection` is 9,776 bytes again.

## [0.13.0] - 2026-09-17

### Security

- `storage.source.open_connection` and `open`, and so `assembly.init_client` and `init_server`, require a source that declares exactly `supply.LANES` (3) lanes, and now say so (#180). They pass three budgets, and std reads one per declared lane, so a caller's pool with more lanes gave the extra lanes whatever followed the three on the stack as their budgets. A refusal follows once mach-std can report a source's lane count.

### Changed

- **Breaking:** `assembly.Config.verification_time_unix` and the `verification_time_unix` fields of the tls client and server configs are gone. mach-tls 0.8 reads certificate time from `ClientConfig.clock` or `ServerConfig.clock`, which the caller sets when it builds the tls config. The clock is wall time for certificate validity, and quic's deadlines stay on the monotonic `Instant`. The binding checks that the clock record and its context do not overlap connection storage (#183).
- Dependencies: mach-tls v0.8.1 and mach-crypto v0.13.2 (#183). `assembly.Connection` shrinks from 9,776 to 9,768 bytes, and the tls handshake records grow to 6,424 bytes (client) and 6,224 (server).
- `mach.toml` declares `mach = "^5.3"`. mach-std 5.3.0 already required mach 5.3, so 0.12.1 needed it too. Its manifest now says so, and mach 5.2 refuses the key.

## [0.12.1] - 2026-09-17

### Security

- A cancelled or timed-out send whose datagram went out whole is now settled as sent (#174). mach-std 5.3.0 reports the transfer that finished before a cancellation, and `transport.complete_native` used to discard it. The core then refunded the datagram's anti-amplification credit, so a server facing an unvalidated peer could exceed its 3× budget. It also left the bytes out of congestion control, and sent the packet's frames again, which could deliver an application DATAGRAM twice. A partial datagram is still settled as not sent.

### Changed

- Dependencies: mach-std v5.3.0, whose completions carry the bytes transferred before a cancellation or timeout (#174).

## [0.12.0] - 2026-09-17

### Security

- Secret packet plaintext no longer outlives the call that sealed or opened it (#137). Before, the last packet's plaintext stayed in the connection's secret buffers until close. The core now wipes exactly the bytes it wrote on every exit path.

### Changed

- **Breaking.** Stream bytes live in pool chunks taken on demand, not in fixed per-stream rings (#137). `assembly.init_client` and `init_server` take a `std.memory.buffers.Source` by value, and each connection opens one account on it through `source_open_account`. Budgets come from the stream windows, and `Config.chunk_reserve` is held from init. `assembly.Storage` drops from 552,392 to 166,728 bytes.
- **Breaking.** CRYPTO bytes live in the same chunks (#137). Initial and Handshake levels are released when their keys are discarded, even with retransmissions in flight, and 1-RTT CRYPTO is released once it is acknowledged. `handshake.Storage` is now its attempts plus the pool and account. `assembly.CRYPTO_LENGTH` and `CRYPTO_STRIDE` are replaced by `CRYPTO_PER_LEVEL`. `assembly.Storage` drops from 166,728 to 52,168 bytes, and an idle connection holds no chunks.
- **Breaking.** The encoded local transport parameters, both extension tables, and the client's Retry token and pseudo-packet move out of `assembly.Storage` into one pool chunk. The core releases that chunk when the handshake is confirmed, and `release_closed` releases it if the connection closes first (#137). `assembly.Storage` drops to 48,328 bytes. Parsed peer and local parameters keep their values, but their extension lists are dropped at confirmation.
- `core.Owner` holds only the token of the frame it carries, in a `core.OwnerToken` union, so it shrinks from 440 to 240 bytes (#137).
- **Breaking.** The core takes its owner table and each space's packet history from the pool only while packets are in flight (#137). They are released once nothing is tracked, so an idle connection holds neither. `core.Storage` leaves `owners` and history `packets` nil to ask for that, and names the source in `chunk_source`. Storage that is lent keeps working as before. A refused chunk is backpressure: `generate` puts the frame back and returns `STATUS_BLOCKED`. `assembly.Storage` drops to 35,144 bytes, and `core.release_chunks` gives back what a dead core still holds.
- **Breaking.** Stream records and attempts come from the pool while streams are live and attempts are in use, five records per chunk and every attempt in one chunk (#137). `stream.Storage.streams` and `attempts` may be nil to ask for that. A frame that would open peer streams with no record chunk available is refused before acknowledgement, as are RESET_STREAM, STOP_SENDING, MAX_STREAM_DATA and STREAM_DATA_BLOCKED frames that open streams. Record and attempt generations come from manager-wide counters, so a reused chunk never revives a stale handle or token. `assembly.Storage` drops to 23,240 bytes.
- **Breaking.** Per-call buffers move out of each connection into a scratch pair shared by every connection on a pump (#137). `assembly.SecretStorage` is replaced by `assembly.Scratch` and `assembly.SecretScratch`, and `init_client` and `init_server` take `scratch: *Scratch, secret_scratch: *SecretScratch` in its place. A connection binds the pair at init and lends it to the core around each call. A call that finds it in use is refused with `ERROR_STATE` before the core runs, and init reports `STAGE_SCRATCH`. `assembly.Storage` drops from 13,832 to 6,512 bytes, and the 3,008-byte secret pair is paid once per pump rather than once per connection.
- **Breaking.** NEW_TOKEN payloads live in chunks held only while a token waits, rather than in two 512-byte arrays for the connection's lifetime (#137).
  - `core.queue_new_token` returns a `transport.Status`. `STATUS_EARLY` means an earlier token is still unacknowledged: repeat once the new `core.Snapshot.new_token_pending` clears. `STATUS_BLOCKED` means no chunk was free: the connection's account is woken once one is, and the call can be repeated. The token is released when its frame is acknowledged.
  - `core.received_token` is replaced by `core.take_received_token(core, output, capacity)`, which copies the token out and releases its chunk. It returns `STATUS_EMPTY` when none is waiting, and a `length` to size the buffer when `capacity` is too small.
  - A NEW_TOKEN that finds no chunk is refused before its packet is acknowledged, so the server sends it again. Tokens are no longer capped at 512 bytes.
  - `core.Storage` loses its token fields, and `assembly.Storage` drops from 5,488 to 4,464 bytes.
- The Initial and Handshake ACK range tables move into the handshake chunk and are released at confirmation, holding 8 ranges each instead of 32 (#137). A space that fragments further evicts its oldest ranges as before. `ack.detach_space` drops a discarded space's storage. `assembly.Storage` drops from 6,512 to 5,488 bytes.
- A stream record shrinks from 728 to 648 bytes, so six fit one chunk and an idle connection's six H3 control streams hold one record chunk instead of two (#137). `chunks.Slot`, `chunks.Chunks`, `chunks.Reserved` and `ranges.RangeSet` no longer repeat the data pointer their `supply.Chunk` already holds, and the stream flags share one run. `stream.RECORDS_PACKED` names the packing, and a test fails if the record outgrows it.
- `transport.CoreResult` and `CoreDatagram` carry a `refusal` error. A protocol that refuses a call without changing state reports it there, and the transport returns it instead of `ERROR_PROTOCOL` (#137).
- **Breaking.** Application DATAGRAM payloads live in chunks taken when a datagram is queued and released when it is published, cancelled or released (#137). `datagram.Storage` loses its byte arrays and names the chunk source and account instead, and a stride may be up to `supply.BYTES`. A send with no chunk returns `STATUS_BLOCKED`, and a received DATAGRAM with no chunk is dropped, as RFC 9221 allows. Connections that negotiate datagrams get `DATAGRAM_CAPACITY` more chunks on each lane. `assembly.Storage` drops from 23,240 to 13,832 bytes.
- **Breaking.** mach-quic requires mach-std 5.0.0 and mach 5.2.0 or later (#137). Connection storage comes from any `std.memory.buffers.Source`, and `quic.storage.source` is the only module that calls it. `quic.storage.pool` is removed. quic's own budgets are counted in chunks of `supply.BYTES` on the send and receive lanes.
- **Breaking.** Public time is `std.chrono.time.Instant` and configured spans are `std.chrono.duration.Duration` (#137). `transport.Datagram.received_at`, every `now` taken by `receive_native`, `generate`, `complete_send`, `cancel_send`, `complete_native`, `on_timeout` and `begin_close`, `transport.Timer.deadline`, `assembly.init_client`, `init_server` and `finish`, `listener.Request.now`, `listener.issue_address_token`, and `token.seal` and `open` take or report instants. `assembly.Config.max_idle_timeout` and `drain_timeout` and `token.Config.retry_max_age` and `address_max_age` are durations, and `assembly.Config.tls_deadline` is an `opt[time.Instant]`. The core keeps u64 nanoseconds, and `quic.clock` converts at the boundary. Protocol cores receive `transport.CoreInput`, which carries `received_at_ns`.
- Per-byte send and receive state is replaced by bounded interval sets. A peer that fragments a stream or CRYPTO level past its interval cap, or whose data finds no storage, has its packet refused before it is acknowledged, so the data is sent again rather than lost (#137). `stream.Manager.receive_storage_refusals`, `handshake.Adapter.receive_storage_refusals` and `core.refused_packets` count these refusals.
- CRYPTO output that finds no storage waits: `handshake.complete_event` returns `STATUS_BLOCKED` with `ERROR_STORAGE`, and `next_event` offers the same event again (#137).

- **Breaking.** Dependencies: mach-std v5.0.1, mach-crypto v0.13.1, mach-tls v0.7.0 (#137).
- **Breaking.** mach-tls 0.7.0 takes its memory from the connection's buffer source (#137).
  - Before `init_client` or `init_server`, initialize the engine with `assembly.tls_lease(c)`. It points into `c`, so `c` must not move or be copied from then until `release_closed` succeeds. Init refuses an engine holding any other lease with `STAGE_HANDSHAKE`.
  - tls charges the connection's single account on a new lane, `supply.TLS`, bounded by `assembly.Config.tls_budget` (default `assembly.TLS_BUDGET`, 64 KiB). `supply.LANES` is 3. A source must offer the classes `supply.classes` names: 512, 4,096 and 17,408 bytes. quic itself still takes only 4,096-byte chunks.
  - `supply.open_connection` opens an account with the tls budget, and `supply.pool_config` takes its global budget in bytes. `supply.chunk_class` is replaced by `supply.classes`.
  - `connection.tls_client.initialize`, `tls_server.initialize` and `handshake.initialize_tls_client` and `initialize_tls_server` take the lease after the engine.
  - A failed init that already started the engine destroys it, since its memory is on the account being closed. Initialize it again to reuse it.
  - The tls handshake record must stay put only until `assembly.tls_released(c)`, after which the connection no longer refers to it and it may be reused. Owners need one record per connection in handshake, not per connection.
  - `assembly.Connection` grows from 9,168 to 9,776 bytes. It now holds tls's established core, which the adapter moves out of the engine once the handshake has handed everything over, so an established connection holds no tls memory.
- **Breaking.** `transport.Protocol` gains `storage_ready`, which `transport.storage_ready` calls. A core refused memory retries once it is called (#137).
- A handshake provider may return `handshake.STATUS_WAITING` from start, ingest or poll when it is refused memory and consumed nothing (#137). The adapter keeps the bytes it could not hand over and stops polling until the connection is woken. It then repeats the same call and feeds every level in order. `core.Snapshot` reports `handshake_waiting` and `handshake_settled`.
- A small request, such as a datagram payload or a NEW_TOKEN, gets the smallest class that fits, and the account is charged what it got. Budgets are bytes, so they stay exact, and entry tables cap how many payloads wait (#137).

### Added

- A third guard pins what a handshake holds after any driver call (#137). The dialer holds five send-lane chunks and 8,704 bytes on the tls lane, and the listener six and 18,944. The tls handshake records are 6,416 bytes (client) and 6,216 (server).
- A second guard pins what a 64 KiB transfer on one stream holds, sampled after every driver call (#137): five send-lane chunks on the sending end, and four send-lane plus one receive-lane on the receiving end. After the bytes are read, each end holds one record chunk.
- A size guard pins what an idle connection costs (#137): `assembly.Storage` at 4,464 bytes and `Connection` at 9,776, no chunks and no tls memory held by an established idle connection, and one record chunk once the six H3 control streams are open and drained.
- `transport.ready_stream`, which reports streams that became readable, writable or reset in O(1) per call, oldest first, and `transport.storage_ready` for when the pool wakes a connection (#137, mach-http#103).
- `quic.storage.chunks`, the chunk lists shared by stream and CRYPTO buffers (#137).
- `handshake.discard` releases a level once its keys are gone, and the core calls it at both RFC 9001 discard points (#137).

## [0.11.0] - 2026-09-17

### Security

- The listener's replay store has a hard bound on every configuration (#148). With `token.Config.max_replay` unset, a peer holding many valid Retry tokens could grow the store without limit, which is a memory-exhaustion denial of service. At the bound a Retry token is now refused and nothing is kept: the Initial is blocked with `token.ERROR_REPLAY_FULL`, no live nonce is evicted, and replay protection holds. The client retransmits and is admitted once expiry frees room. `token.Snapshot.replay_full` counts the refusals.

### Changed

- **Breaking.** `token.Config.max_replay` is a required `usize` instead of `opt[usize]`, and 0 is refused (#148).

## [0.10.1] - 2026-09-17

### Fixed

- An ACK timer that already fired is no longer reported again (#137). `timer` kept returning the passed deadline under a new generation until the next `generate`, so an owner that re-armed first spun on it.

### Changed

- `generate` on a connection with nothing to send returns `STATUS_EMPTY` without any selection work, until a core input, a stream or datagram mutation, or an ACK or pacing deadline gives it work (#137). Before, every call polled TLS and scanned owners, paths, CIDs and every unacknowledged stream byte.
- Once the handshake is confirmed, TLS is polled only after new CRYPTO data arrives, not on every `generate` and `receive` (#137).
- `timer` returns a cached answer until an input changes the connection (#137).
- `receive_native` checks its packet against the connection's storage once instead of three times, and each protocol callback reads the calling thread once instead of twice. `gettid` is a system call on Linux (#137, #125).
- The stream manager and datagram queue carry a `send_revision` counter, bumped whenever send work appears.
- Dependencies: mach-crypto v0.12.0 (faster X25519 key generation), mach-tls v0.5.1.

### Added

- `quic.storage.pool`, a per-pump pool of pinned 4096-byte chunks with per-account budgets, reservations and FIFO wake registration, and `quic.storage.ranges`, bounded interval sets that spill into pool chunks (#137). Nothing uses them yet; they are the foundation of the storage work planned for 0.12.0.

## [0.10.0] - 2026-09-17

### Changed

- **Breaking.** Dependencies: mach-std v4.0.1, mach-crypto v0.11.0, mach-tls v0.5.0 (#134). They require mach 5.2.0 or later.
- `transport.submit_native` builds its own refusals with `io.error.make` and names their kind (`BUSY` for callback reentry, `INVALID` for a missing argument or a stale token, `CANCELLED` for an inactive scope), with `code` 0. Before, it borrowed errnos through `io.error.from_code`, which std 4 removes.
- A native send batch that std refuses whole (std 4.0.1) settles that send as failed, and the connection keeps sending. The batch always carries one packet, so the refusal never splits it.

## [0.9.3] - 2026-09-17

### Fixed

- A stream no longer counts bytes as delivered that were never sent (#136). A send reserved for an earlier offset range was published after acknowledgements had reclaimed those ring slots and new bytes had been written into them. Its bookkeeping then claimed the new lap, which was never sent and was later marked acknowledged. hedge saw 64 KiB transfers stall with gaps on 4096-byte boundaries. A published send now keeps only the offsets that are still live.

## [0.9.2] - 2026-09-16

### Fixed

- An acknowledged MTU probe, or a black-hole MTU reduction, no longer fails a connection whose congestion window has grown past ten datagrams (#129). The pacer was reconfigured with the live window as its burst, which the pacer refuses above its cap. The burst now derives from the datagram size at every call site.
- A failure while settling one recovery event no longer strands the owners of the events after it (#130). The connection still fails, but every owner is released and every event settled. A draining connection reaches CLOSED even when a step fails, so `finish_close` completes.

## [0.9.1] - 2026-09-16

### Fixed

- The TLS handshake deadline (`tls_deadline_ns`) now bounds only the handshake (#124). It still applied after completion, so every connection that outlived it failed on its next `generate` or `receive`. A slow 64 KiB transfer died at exactly the default 10 s. The idle timeout and loss recovery now govern an established connection.

## [0.9.0] - 2026-09-16

### Changed

- Dependencies: mach-std v3.2.0, mach-crypto v0.10.1, mach-tls v0.4.1. No mach-quic source changed. std 3.0 made the io runtime growable and 3.1 narrowed `io.runtime.wait`, but mach-quic never makes or waits on a runtime, and it settles each native completion on its own.

## [0.8.1] - 2026-09-16

### Fixed

- A peer's 1-RTT key update now moves our send keys before anything else is sent, so its update packet is acknowledged under the new key phase, as RFC 9001 6.2 requires (#116). Before this, quic-go closed every such connection with KEY_UPDATE_ERROR.
- A peer may update its keys again once we have acknowledged its previous update from new-phase packets (#116). The second update was refused.
- A refused key update closes the connection with KEY_UPDATE_ERROR instead of PROTOCOL_VIOLATION.

## [0.8.0] - 2026-09-16

### Fixed

- A connection whose `max_udp_payload` is above 1200 no longer stops sending after the handshake (#108). `generate` sized packets by the negotiated payload instead of the path's validated MTU, so a full STREAM packet was refused by the pacer and the path on every attempt. MTU probes were refused the same way, and an acknowledged or lost probe would have failed the congestion controller. Packets are now sized to the path MTU, probes and packets sent before an MTU reduction are paced and accounted like any other, and every path's search ceiling follows the peer's limit.
- A pacing delay arms the connection timer, so a paced sender wakes without waiting for another event (#108).
- `max_udp_payload` is only the receive limit it advertises (#109). The send ceiling is the send storage capped by the peer's limit, and `transport.generate` no longer clamps sends by the receive limit. `assembly.default_config` advertises the full receive storage (`MAX_UDP_PAYLOAD`, 1500) instead of 1200, which refused quic-go's and browsers' Initials.
- `receive_datagram` drops a datagram above `max_udp_payload` and reports `STATUS_OK`, as RFC 9000 18.2 allows, instead of failing with `ERROR_BUFFER` (#109).
- `receive` advances the handshake after each packet, so keys its crypto data unlocks are installed before the next coalesced packet or batched datagram is opened (#110). The server no longer drops a client request coalesced with its Finished, and connections no longer start with a collapsed congestion window.

- A client Initial with a zero-length source connection ID is accepted (#111). quic-go uses one by default, and the listener dropped it. A peer addressed by a zero-length ID is reached by its path alone, and a NEW_CONNECTION_ID from it is refused as RFC 9000 19.15 requires.

### Changed

- A client may choose a zero-length local connection ID (#111). It cannot issue another (`cid.ERROR_ZERO_LENGTH`), and its route carries an empty key, so the owner finds the connection by address. A server still needs a non-empty ID, because it is routed by its IDs.
- **Breaking.** Core initialization refuses a path manager whose `maximum_mtu` exceeds the send storage (`INIT_PRECONDITION`), and the send storage only needs 1200 bytes rather than `max_udp_payload`.

### Added

- `cid.local_zero_length`, `cid.peer_zero_length` and `cid.ERROR_ZERO_LENGTH`.
- `path.limit_mtu` and `path.limit_mtu_scoped`, which lower the send ceiling and every path's MTU search ceiling together.

## [0.7.0] - 2026-09-15

### Changed

- **Breaking.** `admission.initialize`, `token.initialize` and `listener.initialize_result` take an allocator in place of caller-sized arrays, and the storage they own grows on demand (#100). A server no longer sizes its peer, charge, replay and pending-initial tables up front, and no lookup scans to capacity: peers and replay nonces are found through a keyed SipHash-2-4 index, charges and pending initials come from free lists, and replay entries expire through a deadline heap.
- **Breaking.** `admission`'s `max_connections` and `max_connections_per_peer` are `opt[usize]` policy counts, where absent means unbounded.
- A refused growth blocks exactly one Initial and nothing else: `ERROR_MEMORY` from the listener before any charge exists, or a token `ERROR_MEMORY` surfaced as `ACTION_BLOCKED` with the admission charge released.
- Charge generations continue across reinitialization, so a handle from before cannot reach the new storage.
- Dependencies: mach-std v2.1.0. The v0.6.1 manifest still named mach-crypto v0.9.0 and mach-tls v0.3.0 although its gitlinks were already the v0.9.1 and v0.3.1 commits; the manifest now names them.

### Fixed

- An expired retry reservation is no longer freed under its owner. The old sweep released the slot, so the listener's commit failed and its cleanup was retained forever, which also blocked `finish_close`. Expiry now only stops remembering the nonce and the owner's commit or cancel frees the slot.
- A directory at exactly the minimum capacity grew by one slot per claim, so every admission past it reallocated. Directories double from the minimum.

### Removed

- **Breaking.** `admission.Storage`, `admission.ERROR_PEER_CAPACITY`, `admission.ERROR_CHARGE_CAPACITY` and the renumbering of the admission error values after `ERROR_PEER_LIMIT`.
- **Breaking.** `token.Storage`, `listener.Storage`, `Pending.listener_source`, `Pending.listener_generation` and `listener.ERROR_CAPACITY`. `listener.ERROR_MEMORY` takes value 9.

### Added

- `token.Config.max_replay`, an optional count limit on remembered replay nonces.

## [0.6.1] - 2026-09-15

### Fixed

- `complete_send` accepts the completion of a datagram the operating system sent whole even when the recovery space it was built for has since been discarded, rather than reporting `ERROR_PROTOCOL` and failing the connection (#93).

### Changed

- Dependencies: mach-crypto v0.9.1, mach-tls v0.3.1.

## [0.6.0] - 2026-09-13

### Changed

- Migrated to mach 5.0 and std 2.0.0 (#95): every fallible or absent outcome is a `res`, `opt` or `err` tag, `:^` is the typed `:>T` strip, the manifest is on the 5.0 schema and the dependency pins are the committed gitlinks under `dep/`.
- Dependencies: mach-crypto v0.9.0, mach-tls v0.3.0.
- The cancel reason the cancellation callback publishes atomically is mapped to an integer explicitly, since a tag cannot be cast.


### Changed

- Dependencies: mach-tls v0.2.5.

## [0.5.8] - 2026-09-05

### Removed

- `tools/check-version.sh`. The manifest-against-constant comparison it did now
  runs inline in CI, which is the only place it was ever run.
- `tools/partial_literal_sweep.py`. It enumerated record literals naming fewer
  fields than their record declares, which is a workaround for
  briar-systems/mach#3108; that defect is being fixed in the compiler.

### Added

- GitHub Actions CI: every pull request builds the library, runs the suite in both profiles, checks the release version constant, and verifies IR across all six targets.

### Changed

- Dependencies: mach-tls v0.2.4, mach-crypto v0.8.2.

## [0.5.7] - 2026-09-02

### Changed

- `mach-tls` advances to `v0.2.3`, whose engines clear every per-handshake
  field on destroy so a reused connection record completes a second handshake.

### Changed

- Removed the unreachable settle branch for attempts on released streams added
  in 0.5.6; a stream cannot be released while an attempt is still in flight,
  so the branch and its test described a state the API does not permit.

## [0.5.6] - 2026-09-02

### Fixed

- Recovery bounds acknowledgements by the highest packet number handed to the
  driver, so an ACK that arrives before the packet's send completion is
  accepted instead of closing the connection with PROTOCOL_VIOLATION.
- Settling a send attempt whose stream has already been released succeeds and
  frees the attempt instead of failing the connection.

## [0.5.5] - 2026-09-02

### Fixed

- `transport.release_stream` no longer refuses once the driver is CLOSED.
  A stream whose last attempt was settled by the drain could be released
  neither before it (something in flight) nor after it (driver closed), which
  left HTTP/3 engines and their connections unreleasable.

## [0.5.4] - 2026-09-02

### Fixed

- A closing stream manager releases a stream as soon as nothing of it is
  still in flight, instead of waiting for send and receive completions the
  peer can no longer acknowledge. A peer that closes right after the last
  data left the server's FIN-only frame unacknowledged and the stream, its
  HTTP/3 engine, and the connection unreleasable.

## [0.5.3] - 2026-09-02

### Fixed

- Recovery now records the number of every sent packet, including ack-only
  packets that carry nothing recoverable, so a peer acknowledging such a
  packet is no longer treated as acknowledging an unsent number and closed
  with PROTOCOL_VIOLATION.

## [0.5.2] - 2026-09-02

### Fixed

- A send completion for an ack-only packet whose acknowledgement generation
  was superseded by a packet received in the meantime no longer closes the
  connection with INTERNAL_ERROR. The loopback seam completes sends
  synchronously and could not reach this state; a real socket reaches it as
  soon as traffic is dense in both directions.

## [0.5.1] - 2026-09-01

### Fixed

- `quic.VERSION` now reports the manifest version, `tools/check-version.sh`
  fails a release when the two disagree, and the version test pins the
  `major.minor.patch` shape instead of a literal.

## [0.5.0] - 2026-09-01

### Changed

- `assembly.Connection` is now a small deep-secret control record. Large
  public arrays live in caller-supplied `assembly.Storage`, which an ordinary
  allocator can provide at the configured capacity, and secret plaintext
  backing lives in `assembly.SecretStorage`.
- Backing storage is validated through numeric extents and public-field
  anchors with no public byte aliases over secret fields, and initialization
  refuses nil, misaligned, overlapping, copied-live, and competing backing.
- Both backing records are retained through failed cleanup with
  generation-tracked leases, and rollback and `release_closed` release them
  exactly once.
- QUIC plaintext storage is checked against every welded key set.
- `mach-crypto` advances to `v0.8.1` and `mach-tls` to `v0.2.2`, adopting the
  wiped deallocation retry contract.

### Added

- Listener coverage for retained pending-storage cleanup that retries only the
  leg that failed.
- Typed secret pool coverage proving cleanup-pending control and secret
  storage stay wiped across a failed deallocation.

## [0.4.4] - 2026-09-01

### Fixed

- Failed connection assembly initialization is now transactional and safely
  reusable, rolling back core, manager, routing, and handshake-adapter
  ownership after any failed init stage.
- Failure during initialization preserves the caller's ownership of the TLS
  provider.

### Changed

- Anti-ABA route and transport generations are retained across stable-record
  reuse.

### Added

- Live test coverage for a late driver-stage failure followed by successful
  reuse.

## [0.4.3] - 2026-08-31

### Added

- A terminal reuse contract for bounded QUIC servers. A fully closed
  assembled connection can be released transactionally and initialized
  again at the same stable address.

### Changed

- Release now refuses until sends, stream and datagram ownership,
  cancellation, routes, core managers, secrets, and the TLS provider are
  all terminal.
- Successful reuse preserves route epochs and send-token generations, so
  delayed first-generation identities remain stale.

## [0.4.2] - 2026-08-31

### Added

- The production HTTP/3 assembly boundary required by Hedge, with bounded
  H3 stream capacity, a generation-safe routing inventory for its stable
  local connection ID, and a transactional server acceptance path that
  preserves Initial, original destination, and Retry identities.

### Changed

- The public transport maps unsettled stream release to a blocked outcome.
- Close finalization now respects protocol ownership.

## [0.4.1] - 2026-08-31

### Changed

- Pinned `mach-tls` to `v0.2.0` and `mach-crypto` to `v0.7.0` on their exact
  published commits, making the ALPN-aware TLS credential-selector contract
  available to downstream consumers without changing mach-quic behavior.
- Clarified the scope of the live assembly test and the current
  interoperability evidence.

## [0.4.0] - 2026-08-29

### Changed

- `Protocol[T]` now carries `context: *T` and the eight callbacks as
  `fun(*T, ...)`. `Driver[T]` follows, and every public driver function
  takes the type parameter, so call sites must name the context type.
- `Protocol.context_size` is replaced by `context_range: fun(*T)
  ownership.Range`, so the provider answers for its own memory instead of
  the driver casting the context's range.
- A cancelled scope no longer closes the connection from its callback. It
  records the cancellation, and the owner's next call performs the close
  on the thread that owns the protocol. `cancel_connection` stays
  synchronous.

### Added

- `quic.transport.binding`, the production `Protocol[Binding]` over a real
  `Core` and `Secrets`.
- `quic.connection.assembly`, which builds a core, every manager it owns,
  the binding, and the driver from one `Config`, deriving the manager
  configurations and encoded transport parameters from the same record.

### Fixed

- 51 partial record literals in shipping code. `handshake.Result` omitted
  `provider_error` at eleven sites, so a real TLS failure reached the
  caller as `INTERNAL_ERROR` decided by stack residue. Every affected
  record is now built through a constructor taking all its fields.
- `handshake.poll` treated a blocked provider as a failed one, closing the
  adapter on the first poll of a healthy client waiting for the server.

## [0.3.0] - 2026-08-29

### Added

- `InitResult` gains `reason`, `reason_kind`, `reason_first`, and
  `reason_second`, covering every refusal path in `storage_valid`,
  `component_storage_valid`, and `initialize`, including capacity
  relations, owned storage aliasing, secret plaintext aliasing, borrowed
  configuration aliasing, component set aliasing, malformed provider
  records, provider secrets aliasing plaintext buffers, state
  preconditions, connection ID and path identity, local transport
  parameters, recovery and acknowledgement state, refused manager leases,
  Initial key derivation, path configuration, and a provider refusing to
  start.
- `ownership.disjoint_from` checks one range against a window of a list.

### Changed

- `ownership.disjointness` reports the failure kind and the two colliding
  range indices, with `all_disjoint` now a thin predicate over it. The
  first writer wins, so a coarse refusal never overwrites a precise one
  beneath it.
- `error` remains the wire-facing transport code, so a caller that only
  forwards a CONNECTION_CLOSE is unaffected.

## [0.2.1] - 2026-08-28

### Changed

- Pinned `mach-tls` to its `v0.1.0` tag instead of the commit its
  peer-parameters delivery fix landed on, since Mach resolves transitive
  dependencies into a flat tree and rejects a tag ref and a commit ref for
  the same dependency. No functional change.

## [0.2.0] - 2026-08-28

### Added

- Client and server QUIC connection state across the handshake, retry,
  version negotiation, connection IDs, tokens, close, and draining, with
  address validation and amplification limits enforced before
  authentication, and connection and peer limits charged before expensive
  allocation.
- A typed provider adapter binding the real `mach-tls` TLS 1.3
  implementation for both client and server roles. A real client and
  server complete a QUIC handshake through the adapter pair in process,
  with CRYPTO crossing at Initial and Handshake, both directional
  application traffic secrets deriving, transport parameters carried in
  both directions through the `quic_transport_parameters` extension, and
  ALPN and SNI selection.

### Changed

- Terminal alerts keep their identity onto CONNECTION_CLOSE, so the low
  byte is the TLS alert rather than a collapsed generic code.
- `restart` is refused on a server binding at both the public and dispatch
  layers.
- Receive delivery and flow-control credit are now separate operations.
  `read` moves bytes into caller storage and adds them to a per-stream
  outstanding total without returning any window. `credit` releases
  exactly the bytes whose caller ownership has ended and rejects any
  amount above that total.
- Cancellation, reset acknowledgement, and release each reconcile the
  outstanding total exactly once, so abandoning a stream returns its
  window instead of leaking it.
- Pinned `mach-std` to `v0.33.0`, `mach-crypto` to `v0.6.0`, and `mach-tls`
  to its peer-parameters delivery fix.

### Fixed

- Granting flow-control credit on delivery sized the receive window
  against the driver's ring instead of against what the application
  holds, which prevented HTTP/3 from binding to this driver at all.

## [0.1.0] - 2026-08-27

### Added

- Initial release.
