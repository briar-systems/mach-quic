# tls.cert.name

## val MAX_DNS_NAME

```mach
pub val MAX_DNS_NAME: usize = 253
```

## val MAX_DNS_LABEL

```mach
pub val MAX_DNS_LABEL: usize = 63
```

## fun valid_reference_dns

```mach
pub fun valid_reference_dns(value: contracts.Bytes) bool;
```

## fun valid_presented_dns

```mach
pub fun valid_presented_dns(value: contracts.Bytes) bool;
```

## fun match_dns

```mach
pub fun match_dns(reference: contracts.Bytes, presented: contracts.Bytes) bool;
```

## fun parse_ip

```mach
pub fun parse_ip(input: contracts.Bytes, output: contracts.Buffer) contracts.Operation;
```

## fun match_ip

```mach
pub fun match_ip(reference: contracts.Bytes, presented: contracts.Bytes) bool;
```

