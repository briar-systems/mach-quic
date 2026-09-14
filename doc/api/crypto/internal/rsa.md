# crypto.internal.rsa

## val MIN_MODULUS_BYTES

```mach
pub val MIN_MODULUS_BYTES: usize = 256
```

## val MAX_MODULUS_BYTES

```mach
pub val MAX_MODULUS_BYTES: usize = 512
```

## fun valid_modulus

```mach
pub fun valid_modulus(modulus: *u8, len: usize) bool;
```

## fun valid_exponent

```mach
pub fun valid_exponent(exponent: *u8, len: usize, modulus: *u8,
modulus_len: usize) bool;
```

## fun public_less_than

```mach
pub fun public_less_than(left: *u8, right: *u8, len: usize) bool;
```

## fun public_apply

```mach
pub fun public_apply(output: *^u8, input: *u8, modulus_bytes: *u8,
modulus_len: usize, exponent: *u8, exponent_len: usize) ^u8;
```

## fun public_apply_secret

```mach
pub fun public_apply_secret(output: *^u8, input: *^u8, modulus_bytes: *u8,
modulus_len: usize, exponent: *u8, exponent_len: usize) ^u8;
```

## fun private_apply

```mach
pub fun private_apply(output: *^u8, input: *^u8, modulus_bytes: *u8,
modulus_len: usize, exponent: *^u8, exponent_len: usize) ^u8;
```

