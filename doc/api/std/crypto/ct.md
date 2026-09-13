# std.crypto.ct

## fun mask_u8

```mach
pub fun mask_u8(c: ^u8) ^u8;
```

lift a secret 0/1 flag to an all-ones 8-bit mask

`0` maps to `0x00` and `1` to `0xFF`. the low bit is taken first, so a flag
outside {0, 1} selects on its low bit rather than blending the two operands'
bits together.

c: secret flag, 0 or 1
ret: 0x00 or 0xFF

## fun mask_u16

```mach
pub fun mask_u16(c: ^u8) ^u16;
```

lift a secret 0/1 flag to an all-ones 16-bit mask

THE WIDENING CAST AND THE `& 1` DO DIFFERENT JOBS, stated once for the four
`mask_*` that widen (u16/u32/u64/usize).

`::^uN` zero-extends: it takes the low 8 bits of the flag and nothing else, so a
caller's stray high bits cannot reach the subtraction. that is worth naming
because it was NOT true until briar-systems/mach#2373 — a secret-to-secret `::`
used to lower to a width-changing `bitcast`, a reinterpret that cleaned nothing,
and these four were correct only because the `& 1` happened to be emitted at
machine-register width. they are now correct because the cast converts.

the `& 1` is the flag's normalization, not the cleanup: it reduces a flag outside
{0, 1} to its low bit, which is what lets `0 - one` be all-ones or all-zeros
rather than a partial blend. it is load-bearing for that reason alone, and
dropping it is caught by `ct: mask reads only the flag's low bit`.

`ct: mask_* answer for the value under a dirty flag` pins the pair: the masks must
answer for the 8-bit VALUE of the flag whatever the register around it holds. a
caller can still hand over stray high bits — a narrow `0 - x` is not truncated,
#2357 canonicalized the shift consumers rather than the producers — so this stays
a live property to guard, not a historical one.

c: secret flag, 0 or 1
ret: 0x0000 or 0xFFFF

## fun mask_u32

```mach
pub fun mask_u32(c: ^u8) ^u32;
```

lift a secret 0/1 flag to an all-ones 32-bit mask

the cast zero-extends; the `& 1` normalizes the flag — see `mask_u16`.

c: secret flag, 0 or 1
ret: 0x00000000 or 0xFFFFFFFF

## fun mask_u64

```mach
pub fun mask_u64(c: ^u8) ^u64;
```

lift a secret 0/1 flag to an all-ones 64-bit mask

the cast zero-extends; the `& 1` normalizes the flag — see `mask_u16`.

c: secret flag, 0 or 1
ret: 0 or 0xFFFFFFFFFFFFFFFF

## fun mask_usize

```mach
pub fun mask_usize(c: ^u8) ^usize;
```

lift a secret 0/1 flag to an all-ones usize mask

the cast zero-extends; the `& 1` normalizes the flag — see `mask_u16`.

c: secret flag, 0 or 1
ret: 0 or the all-ones usize

## fun select_u8

```mach
pub fun select_u8(cond: ^u8, a: ^u8, b: ^u8) ^u8;
```

branchless select between two secret bytes

yields `a` when the flag is 1 and `b` when it is 0, as a bitwise blend under
the widened mask. both operands are always read, so the choice leaves no trace
in the control-flow or memory-address stream.

cond: secret flag, 0 or 1
a: value chosen when the flag is 1
b: value chosen when the flag is 0
ret: the chosen value

## fun select_u16

```mach
pub fun select_u16(cond: ^u8, a: ^u16, b: ^u16) ^u16;
```

branchless select between two secret 16-bit words

cond: secret flag, 0 or 1
a: value chosen when the flag is 1
b: value chosen when the flag is 0
ret: the chosen value

## fun select_u32

```mach
pub fun select_u32(cond: ^u8, a: ^u32, b: ^u32) ^u32;
```

branchless select between two secret 32-bit words

cond: secret flag, 0 or 1
a: value chosen when the flag is 1
b: value chosen when the flag is 0
ret: the chosen value

## fun select_u64

```mach
pub fun select_u64(cond: ^u8, a: ^u64, b: ^u64) ^u64;
```

branchless select between two secret 64-bit words

cond: secret flag, 0 or 1
a: value chosen when the flag is 1
b: value chosen when the flag is 0
ret: the chosen value

## fun select_usize

```mach
pub fun select_usize(cond: ^u8, a: ^usize, b: ^usize) ^usize;
```

branchless select between two secret usize words

cond: secret flag, 0 or 1
a: value chosen when the flag is 1
b: value chosen when the flag is 0
ret: the chosen value

## fun is_zero_u8

```mach
pub fun is_zero_u8(a: ^u8) ^u8;
```

branchless test of a secret byte against zero

a: value to test
ret: secret flag, 1 when `a` is zero

## fun is_zero_u16

```mach
pub fun is_zero_u16(a: ^u16) ^u8;
```

branchless test of a secret 16-bit word against zero

a: value to test
ret: secret flag, 1 when `a` is zero

## fun is_zero_u32

```mach
pub fun is_zero_u32(a: ^u32) ^u8;
```

branchless test of a secret 32-bit word against zero

a: value to test
ret: secret flag, 1 when `a` is zero

## fun is_zero_u64

```mach
pub fun is_zero_u64(a: ^u64) ^u8;
```

branchless test of a secret 64-bit word against zero

a: value to test
ret: secret flag, 1 when `a` is zero

## fun is_zero_usize

```mach
pub fun is_zero_usize(a: ^usize) ^u8;
```

branchless test of a secret usize word against zero

a: value to test
ret: secret flag, 1 when `a` is zero

## fun eq_u8

```mach
pub fun eq_u8(a: ^u8, b: ^u8) ^u8;
```

branchless equality of two secret bytes

a: left operand
b: right operand
ret: secret flag, 1 when equal

## fun eq_u16

```mach
pub fun eq_u16(a: ^u16, b: ^u16) ^u8;
```

branchless equality of two secret 16-bit words

a: left operand
b: right operand
ret: secret flag, 1 when equal

## fun eq_u32

```mach
pub fun eq_u32(a: ^u32, b: ^u32) ^u8;
```

branchless equality of two secret 32-bit words

a: left operand
b: right operand
ret: secret flag, 1 when equal

## fun eq_u64

```mach
pub fun eq_u64(a: ^u64, b: ^u64) ^u8;
```

branchless equality of two secret 64-bit words

a: left operand
b: right operand
ret: secret flag, 1 when equal

## fun eq_usize

```mach
pub fun eq_usize(a: ^usize, b: ^usize) ^u8;
```

branchless equality of two secret usize words

a: left operand
b: right operand
ret: secret flag, 1 when equal

## fun lt_u8

```mach
pub fun lt_u8(a: ^u8, b: ^u8) ^u8;
```

branchless unsigned less-than of two secret bytes

a: left operand
b: right operand
ret: secret flag, 1 when `a < b`

## fun lt_u16

```mach
pub fun lt_u16(a: ^u16, b: ^u16) ^u8;
```

branchless unsigned less-than of two secret 16-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a < b`

## fun lt_u32

```mach
pub fun lt_u32(a: ^u32, b: ^u32) ^u8;
```

branchless unsigned less-than of two secret 32-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a < b`

## fun lt_u64

```mach
pub fun lt_u64(a: ^u64, b: ^u64) ^u8;
```

branchless unsigned less-than of two secret 64-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a < b`

## fun lt_usize

```mach
pub fun lt_usize(a: ^usize, b: ^usize) ^u8;
```

branchless unsigned less-than of two secret usize words

a: left operand
b: right operand
ret: secret flag, 1 when `a < b`

## fun gt_u8

```mach
pub fun gt_u8(a: ^u8, b: ^u8) ^u8;
```

branchless unsigned greater-than of two secret bytes

a: left operand
b: right operand
ret: secret flag, 1 when `a > b`

## fun gt_u16

```mach
pub fun gt_u16(a: ^u16, b: ^u16) ^u8;
```

branchless unsigned greater-than of two secret 16-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a > b`

## fun gt_u32

```mach
pub fun gt_u32(a: ^u32, b: ^u32) ^u8;
```

branchless unsigned greater-than of two secret 32-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a > b`

## fun gt_u64

```mach
pub fun gt_u64(a: ^u64, b: ^u64) ^u8;
```

branchless unsigned greater-than of two secret 64-bit words

a: left operand
b: right operand
ret: secret flag, 1 when `a > b`

## fun gt_usize

```mach
pub fun gt_usize(a: ^usize, b: ^usize) ^u8;
```

branchless unsigned greater-than of two secret usize words

a: left operand
b: right operand
ret: secret flag, 1 when `a > b`

## fun eq_bytes

```mach
pub fun eq_bytes(a: *^u8, b: *^u8, len: usize) ^u8;
```

branchless equality of two secret byte buffers

folds every byte of both buffers whatever they hold, so the running time
depends only on `len`, which is public. the accumulator is the running
difference: zero exactly when every byte agreed.

a: left buffer
b: right buffer
len: length of both buffers in bytes
ret: secret flag, 1 when the buffers are equal

## fun lookup_u8

```mach
pub fun lookup_u8(table: *^u8, len: usize, idx: ^usize) ^u8;
```

read a secret-indexed byte without a secret memory address

scans the whole table and merges the element whose public position matches the
secret index, so the address trace is the same for every index — that is what
replaces `table[idx]`, which sema rejects. cost is linear in `len`.

an index at or beyond `len` matches nothing and yields 0. that is the defined
result of the scan, not a bounds check: no comparison against `len` reaches
the control flow, so an out-of-range index costs exactly what an in-range one
does.

table: base of the table
len: number of elements, public
idx: secret element index
ret: the selected element, or 0 if the index is out of range

## fun lookup_u32

```mach
pub fun lookup_u32(table: *^u32, len: usize, idx: ^usize) ^u32;
```

read a secret-indexed 32-bit word without a secret memory address

table: base of the table
len: number of elements, public
idx: secret element index
ret: the selected element, or 0 if the index is out of range

## fun lookup_u64

```mach
pub fun lookup_u64(table: *^u64, len: usize, idx: ^usize) ^u64;
```

read a secret-indexed 64-bit word without a secret memory address

table: base of the table
len: number of elements, public
idx: secret element index
ret: the selected element, or 0 if the index is out of range

## fun zeroize

```mach
pub fun zeroize(p: *^u8, n: usize);
```

wipe secret memory

a zeroing loop over storage that is never read again is dead by every ordinary
rule, and an optimizer may delete it — leaving key material in memory behind
code that reads as if it had been erased.

WHAT ACTUALLY HOLDS THIS UP TODAY, stated honestly because the difference
matters if it ever changes. two things, and the decorator is not yet one of
them:

  * `p` is the caller's pointer, so these stores escape this function. no
    dead-store analysis can call them dead, under any pipeline.
  * mach has no store-eliminating pass at all right now — its DCE removes only
    pure unused value ops, never a store, memzero, or call. verified at
    `--profile release`: an entirely dead 32-byte fill of a PUBLIC local
    survives untouched.

so `#[oblivious]`'s "no dead-store elimination of a zeroizing write" clause is
real but currently vacuous — there is no elimination for it to subtract. the
decorator is on this function so the obligation binds the day that changes;
the lowered MIR already carries the `writes_secret` seed a future pass must
consult. do not read the clause as covering a secret in a REGISTER: a
register-promoted `var x: ^u8 = k; x = 0;` is removed by ordinary DCE with or
without the decorator, which is outside the epic's memory-address leakage
model. this wipes memory.

p: base of the region to wipe
n: number of bytes

## fun begin

```mach
pub fun begin() bool;
```

engage the hardware data-independent-timing mode, if the target has one

the timing guarantee the type system enforces is about the instructions
emitted; whether a given instruction's latency is data-independent is the
silicon's business. some architectures expose a mode that promises it, and
this is where a caller asks for it around secret work.

NO TARGET CAN ENGAGE IT TODAY, and the return value says so rather than a
comment claiming otherwise:

  * aarch64 — `PSTATE.DIT` is settable from user code by `msr DIT, #1`, but
    `msr` is not in mach's aarch64 inline-asm instruction set, so the
    instruction cannot be reached from mach source (briar-systems/mach#2352).
    this is the one arch where the mode is real and merely unreachable.
  * x86_64 — DOITM lives in the `IA32_UARCH_MISC_CTL` MSR, writable only at
    ring 0. no user-mode program sets it on any OS; it is the kernel's to
    configure.
  * riscv64 — the Zkt extension states data-independent latency for its
    instruction list as an architectural property. there is no mode bit,
    so there is nothing to engage.

callers should bracket secret work with `begin`/`end` regardless: the call
sites are what make the aarch64 path a one-function change later.

ret: whether a hardware data-independent-timing mode was engaged

## fun end

```mach
pub fun end();
```

release the hardware data-independent-timing mode engaged by `begin`

a no-op wherever `begin` engaged nothing, which is every target today. see
`begin` for the per-architecture reasons.

