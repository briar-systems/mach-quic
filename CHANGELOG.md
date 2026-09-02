# Changelog

## [Unreleased]

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
