---
sidebar_position: 4
---


# CRC

A **Cyclic Redundancy Check** (CRC) is a checksum algorithm used to detect
accidental corruption in binary data. `ribs_binary` provides a pure-Dart
implementation that covers the full range of standard CRC widths, from 3-bit up
to 82-bit, parametrised by the five values that uniquely define a CRC algorithm:
polynomial, initial register value, input reflection, output reflection, and
final XOR mask.

## Standard checksums

The most common widths are available as one-liner getters on `Crc`. Each
accepts a `BitVector` — convert a `ByteVector` with `.bits` — and returns a
`BitVector` containing the checksum:

<<< @/../snippets/lib/src/binary/crc.dart#crc-1

## Named presets and custom parameters

`CrcParams` collects presets for the algorithms most commonly found in
specifications and hardware:

| Factory | Algorithm |
|---|---|
| `CrcParams.crc8()` / `crc8SMBus()` | CRC-8/SMBus |
| `CrcParams.crc8Rohc()` | CRC-8/ROHC |
| `CrcParams.crc16()` / `crc16Arc()` | CRC-16/ARC |
| `CrcParams.crc16Kermit()` | CRC-16/KERMIT |
| `CrcParams.crc24()` / `crc24OpenPgp()` | CRC-24/OpenPGP |
| `CrcParams.crc32()` / `crc32IsoHdlc()` | CRC-32/ISO-HDLC (Ethernet, ZIP) |

Pass a preset to `Crc.from()` to get a reusable function, or supply the five
parameters directly to `Crc.of()` for an algorithm not covered by the presets:

<<< @/../snippets/lib/src/binary/crc.dart#crc-2

## Incremental computation with CrcBuilder

`Crc.builder()` returns a `CrcBuilder<BitVector>` that accumulates state across
multiple `updated()` calls. This is useful when data arrives in chunks — for
example during a streaming file read or network receive — without needing to
buffer the whole message before computing the checksum.

`mapResult()` transforms the final `BitVector` to any other type (such as a
Dart `int`) in a single step:

<<< @/../snippets/lib/src/binary/crc.dart#crc-3

`CrcBuilder` is immutable: each `updated()` call returns a new builder with the
accumulated state, leaving the original unchanged. This means the same base
builder can be reused across multiple independent computations.
