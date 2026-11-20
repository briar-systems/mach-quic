[quic](../README.md) / [lib](README.md) / **quic**

# quic.lib.quic

Source: [`src/lib/quic.mach`](../../../../src/lib/quic.mach)

| Constants | |
| :--- | :--- |
| [`VERSION`](#constants) | |

| Forwards | |
| :--- | :--- |
| [`packet`](#packet), [`frame`](#frame), [`varint`](#varint), [`transport_parameters`](#transport_parameters), [`protection`](#protection), [`vectors`](#vectors), [`recovery`](#recovery), [`ack`](#ack), [`controller`](#controller), [`pacer`](#pacer), [`stream`](#stream), [`datagram`](#datagram), [`path`](#path), [`admission`](#admission), [`cid`](#cid), [`token`](#token), [`handshake`](#handshake), [`handshake_simulated`](#handshake_simulated), [`tls_client`](#tls_client), [`tls_server`](#tls_server), [`listener`](#listener), [`negotiation`](#negotiation), [`core`](#core), [`core_simulated`](#core_simulated), [`transport`](#transport), [`simulated`](#simulated) | |

---

## Constants

| Name | Type | Value | |
| :--- | :--- | :--- | :--- |
| `VERSION` | `str` | `$mach.project.version` |  |

## Forwards

### packet

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.packet.packet`](../packet/packet.md).

### frame

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.frame.frame`](../frame/frame.md).

### varint

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.wire.varint`](../wire/varint.md).

### transport_parameters

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.transport_parameters`](../transport_parameters.md).

### protection

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.crypto.protection`](../crypto/protection.md).

### vectors

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.crypto.vectors`](../crypto/vectors.md).

### recovery

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.recovery.recovery`](../recovery/recovery.md).

### ack

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.recovery.ack`](../recovery/ack.md).

### controller

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.congestion.controller`](../congestion/controller.md).

### pacer

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.congestion.pacer`](../congestion/pacer.md).

### stream

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.stream.stream`](../stream/stream.md).

### datagram

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.stream.datagram`](../stream/datagram.md).

### path

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.path.path`](../path/path.md).

### admission

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.admission`](../connection/admission.md).

### cid

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.cid`](../connection/cid.md).

### token

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.token`](../connection/token.md).

### handshake

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.handshake`](../connection/handshake.md).

### handshake_simulated

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.handshake_simulated`](../connection/handshake_simulated.md).

### tls_client

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.tls_client`](../connection/tls_client.md).

### tls_server

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.tls_server`](../connection/tls_server.md).

### listener

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.listener`](../connection/listener.md).

### negotiation

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.negotiation`](../connection/negotiation.md).

### core

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.core`](../connection/core.md).

### core_simulated

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.connection.core_simulated`](../connection/core_simulated.md).

### transport

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.transport`](../transport.md).

### simulated

Forwards the first of these whose condition holds, and they differ.

Otherwise: [`quic.transport.simulated`](../transport/simulated.md).

