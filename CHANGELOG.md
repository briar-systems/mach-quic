# Changelog

## [Unreleased]

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
- **Breaking.** mach-quic requires mach-std 5.0.0 and mach 5.2.0 or later (#137). Connection storage comes from any `std.memory.buffers.Source`, and `quic.storage.source` is the only module that calls it. `quic.storage.pool` is removed. Account budgets are counted in bytes on two lanes, send and receive, in chunks of `supply.BYTES`.
- **Breaking.** Public time is `std.chrono.time.Instant` and configured spans are `std.chrono.duration.Duration` (#137). `transport.Datagram.received_at`, every `now` taken by `receive_native`, `generate`, `complete_send`, `cancel_send`, `complete_native`, `on_timeout` and `begin_close`, `transport.Timer.deadline`, `assembly.init_client`, `init_server` and `finish`, `listener.Request.now`, `listener.issue_address_token`, and `token.seal` and `open` take or report instants. `assembly.Config.max_idle_timeout` and `drain_timeout` and `token.Config.retry_max_age` and `address_max_age` are durations, and `assembly.Config.tls_deadline` is an `opt[time.Instant]`. The core keeps u64 nanoseconds, and `quic.clock` converts at the boundary. Protocol cores receive `transport.CoreInput`, which carries `received_at_ns`.
- Per-byte send and receive state is replaced by bounded interval sets. A peer that fragments a stream or CRYPTO level past its interval cap, or whose data finds no storage, has its packet refused before it is acknowledged, so the data is sent again rather than lost (#137). `stream.Manager.receive_storage_refusals`, `handshake.Adapter.receive_storage_refusals` and `core.refused_packets` count these refusals.
- CRYPTO output that finds no storage waits: `handshake.complete_event` returns `STATUS_BLOCKED` with `ERROR_STORAGE`, and `next_event` offers the same event again (#137).

### Added

- A size guard pins what an idle connection costs (#137): `assembly.Storage` at 4,464 bytes and `Connection` at 9,168, no chunks held by an established idle connection, and one record chunk once the six H3 control streams are open and drained.
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
