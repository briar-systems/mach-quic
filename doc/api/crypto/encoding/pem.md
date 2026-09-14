# crypto.encoding.pem

## val MAX_LABEL_SIZE

```mach
pub val MAX_LABEL_SIZE: usize = 64
```

## val LINE_SIZE

```mach
pub val LINE_SIZE: usize = 64
```

## rec Block

```mach
pub rec Block;
```

## rec SecretBlock

```mach
pub rec SecretBlock;
```

## fun valid_label

```mach
pub fun valid_label(label: contracts.Bytes) bool;
```

## fun decoded_len

```mach
pub fun decoded_len(input: contracts.Bytes) contracts.Operation;
```

## fun decoded_secret_len

```mach
pub fun decoded_secret_len(input: contracts.SecretBytes) contracts.Operation;
```

## fun decode

```mach
pub fun decode(input: contracts.Bytes, output: contracts.Buffer,
block: *Block) contracts.Error;
```

## fun decode_secret

```mach
pub fun decode_secret(input: contracts.SecretBytes, output: contracts.SecretBuffer,
block: *SecretBlock) contracts.Error;
```

## fun encoded_len

```mach
pub fun encoded_len(label_len: usize, der_len: usize) usize;
```

## fun encode

```mach
pub fun encode(block: *Block, output: contracts.Buffer) contracts.Operation;
```

## fun encode_secret

```mach
pub fun encode_secret(label: contracts.Bytes, der: contracts.SecretBytes,
output: contracts.SecretBuffer) contracts.Operation;
```

