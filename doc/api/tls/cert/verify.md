# tls.cert.verify

## val MAX_CHAIN_DEPTH

```mach
pub val MAX_CHAIN_DEPTH: usize = 16
```

## val MAX_SIGNATURE_CHECKS

```mach
pub val MAX_SIGNATURE_CHECKS: usize = 256
```

## def Purpose

```mach
pub def Purpose: u8
```

## val SERVER_AUTH

```mach
pub val SERVER_AUTH: Purpose = 1
```

## val CLIENT_AUTH

```mach
pub val CLIENT_AUTH: Purpose = 2
```

## rec Options

```mach
pub rec Options;
```

## fun server_identity

```mach
pub fun server_identity(value: *x509.Certificate,
identity: contracts.Bytes) bool;
```

## fun chain

```mach
pub fun chain(trust: *cert.TrustStore, presented: *cert.Chain,
options: *Options) error.Error;
```

