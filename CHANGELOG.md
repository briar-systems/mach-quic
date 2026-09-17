# Changelog

## [Unreleased]

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
