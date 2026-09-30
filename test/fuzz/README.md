# the fuzz lane

`corpus/<boundary>/` holds the retained inputs for every untrusted-input entry
point of the library. Each directory pairs with a row of the registry in
`src/boundaries.mach`, which names the harness that answers it:

| boundary | entry point |
|---|---|
| `varint` | `wire.varint.read`, relaxed and canonical |
| `packet` | `packet.decode` over a coalesced datagram, final and incremental, in three decode contexts |
| `frame` | `frame.decode` over a packet payload, final and incremental |
| `transport-parameters` | `transport_parameters.decode` for a client and for a server |
| `datagram` | `connection.listener.classify_datagram` with 8 and 20 byte short destinations |
| `preflight` | `connection.listener.preflight` on a listener that admits tokenless clients and on one that requires a retry |
| `token` | `connection.token.open` |
| `version-negotiation` | `connection.negotiation.version_negotiation` from a v1 and from a v2 client |
| `retry` | `connection.negotiation.retry` from a v1 and from a v2 client |
| `packet-protection` | `crypto.protection.open_packet`: a long header with the initial keys of its own destination, both sides, and a short header with the RFC 9001 appendix A.5 keys |
| `receive` | `connection.core.receive` on an established server connection, fed a script of frame sequences and datagrams from its client |

A `packet` input is a datagram as it reads once header protection is removed.
A `packet-protection` input is a datagram as it arrives. A `preflight`,
`version-negotiation` or `retry` input is a datagram a server or client
receives, answered by a fixed server or client: the server's token key and
clock are in `src/server.mach`, and the client is the RFC 9001 appendix A one.

A `receive` input is a script. Each operation is an op byte and, for frames
and datagrams, a two byte length and that many bytes: frames the client seals
as its next 1-RTT packet, a datagram delivered as it is, the server's output
sent, a client key update, or the server's timer fired. Each input gets a
fresh client and server driven through a real TLS 1.3 handshake from the test
chain, with fixed entropy, clock and connection ids, so every script starts
from the same connection. Every datagram enters through the driver, which is
the only caller of `connection.core.receive` and lends it the scratch it
opens packets into.

## Answers

An input is answered when its entry point parses it or refuses it with a typed
error, and every view the parse publishes lies inside the input. A harness
also checks what its entry point promises: a decoder that refuses moves no
cursor, a decode told more may follow agrees with the final decode wherever it
answers, and an accepted varint, packet, frame or parameter block writes back
and decodes to what writes back to the same bytes. ACK ranges describe packets
that exist, and unknown transport parameters are copied rather than borrowed.
A classification names the destination the header carries and agrees with the
packet decoder, a preflight admits only a full-size initial it classifies as
one and answers the rest with a version negotiation or retry that decodes, echoes
the client and carries a valid integrity tag, a client restarts only to a
version it supports and the server listed or for a retry whose tag verifies,
an opened token claims what it carries, and an opened packet seals back to the
bytes it came from. Breaking any of these is a finding. So is a preflight that
keeps state it cannot release.

A `receive` script holds the server to the limits it advertised, as the
client received them: it never opens more streams, takes more bytes on a
stream or on the connection, or moves a final size, and each stream's bytes
lie inside its window. A failed receive either closes the connection with the
code it reports or refuses as a typed driver error. A close the server chooses
carries a code a peer's input can call for, never an internal error, and where
the frames decide it, the code RFC 9000 requires: a frame that does not
decode, a packet with no frames, a frame only a server sends, a stream the
server would have opened, and a stream past its count, its window, the
connection's window or its final size. A payload that breaks none of these
leaves the connection open. The connection releases everything it took once
the script ends.

Each input is copied so that it ends on the last byte before an unreadable page
(`std.allocator.testing`), so a parser that reads one byte past its input
faults on the spot. A crash is a finding. So is a hang: every walk a harness
drives is bounded by its input's length, and the replay runs under a timeout.

## Running it

From the repository root:

```sh
mach dep pull test/fuzz
mach build test/fuzz
test/fuzz/out/linux-x86_64/debug/bin/fuzz replay
test/fuzz/out/linux-x86_64/debug/bin/fuzz one <boundary> <file>
test/fuzz/out/linux-x86_64/debug/bin/fuzz mutate <boundary|all> <runs> <seed> [--retain]
```

`replay` answers every retained input and fails on a finding, on an empty
boundary directory, or on a directory no boundary answers. Run it in both
profiles before a change to a parser lands.

`mutate` is the on-demand search. It draws from a boundary's corpus, applies one
to three structural mutations (flip a bit, set a byte, truncate, extend, swap,
zero a run) from one seeded generator, and answers the result, so a seed and a
run count replay exactly. A finding is written to
`test/fuzz/out/findings/<boundary>/`. With `--retain`, an input whose outcome
the corpus does not hold yet is minimized, by cutting ever smaller chunks while
the outcome holds, and written to its boundary's directory as `m-<outcome>.bin`.

An outcome is what the parse answered: its status or error, and for an
accepted input the shape it took (the first packet's kind or frame's type and
how the walk ended, how many parameters a block named, bucketed, what a
listener or client did). This is not code coverage. There is no coverage
instrumentation for Mach, so two inputs that reach different code with the same
answer count as one.

## The corpus

The named files are valid seeds, each accepted by at least one of its entry
point's parses: the RFC 9000 varint encodings, a packet of every kind and a
coalesced datagram, a payload of every frame family, client and server
parameter blocks, the RFC 9001 and RFC 9369 retry packets, the RFC 9001 appendix
A.5 short header packet, and initials sealed with the keys their destinations
derive and carrying tokens sealed with the fixed server's key. Beside them sit a
few refusals named for what they refuse: `preflight/undersized.bin`,
`version-negotiation/only-unknown.bin`, and the `receive` scripts that break
one limit each, such as `receive/flow-control.bin`. The `m-*` files were retained by
`fuzz mutate all 20000 1 --retain`.

To retain a new input by hand, put the file in its boundary's directory. When a
finding is fixed, retain the input that found it, so the replay keeps it fixed.
