# tls.cert.load

## fun certificate_der

```mach
pub fun certificate_der(input: contracts.Bytes,
output: *cert.Certificate) contracts.Error;
```

## fun certificate_pem

```mach
pub fun certificate_pem(input: contracts.Bytes, der_output: contracts.Buffer,
output: *cert.Certificate) contracts.Operation;
```

## fun chain_pem

```mach
pub fun chain_pem(input: contracts.Bytes, der_output: contracts.Buffer,
certificates: *cert.Certificate, certificate_capacity: usize,
output: *cert.Chain) contracts.Operation;
```

## fun private_der

```mach
pub fun private_der(input: contracts.SecretBytes, format: cert.KeyFormat,
owner: *secret.Allocator, output: *keys.PrivateKey) contracts.Error;
```

## fun private_pem

```mach
pub fun private_pem(input: contracts.SecretBytes, owner: *secret.Allocator,
output: *keys.PrivateKey) contracts.Error;
```

