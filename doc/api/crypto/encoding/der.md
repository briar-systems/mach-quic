# crypto.encoding.der

## def Tag

```mach
pub def Tag: u8
```

## val BOOLEAN

```mach
pub val BOOLEAN:      Tag = 0x01
```

## val INTEGER

```mach
pub val INTEGER:      Tag = 0x02
```

## val BIT_STRING

```mach
pub val BIT_STRING:   Tag = 0x03
```

## val OCTET_STRING

```mach
pub val OCTET_STRING: Tag = 0x04
```

## val NULL

```mach
pub val NULL:         Tag = 0x05
```

## val OBJECT_ID

```mach
pub val OBJECT_ID:    Tag = 0x06
```

## val SEQUENCE

```mach
pub val SEQUENCE:     Tag = 0x30
```

## val MAX_DEPTH

```mach
pub val MAX_DEPTH: usize = 16
```

## rec Element

```mach
pub rec Element;
```

## rec SecretElement

```mach
pub rec SecretElement;
```

## rec Cursor

```mach
pub rec Cursor;
```

## rec SecretCursor

```mach
pub rec SecretCursor;
```

## fun cursor

```mach
pub fun cursor(input: contracts.Bytes) Cursor;
```

## fun secret_cursor

```mach
pub fun secret_cursor(input: contracts.SecretBytes) SecretCursor;
```

## fun complete

```mach
pub fun complete(value: *Cursor) bool;
```

## fun secret_complete

```mach
pub fun secret_complete(value: *SecretCursor) bool;
```

## fun next

```mach
pub fun next(value: *Cursor, output: *Element) contracts.Error;
```

## fun next_secret

```mach
pub fun next_secret(value: *SecretCursor, output: *SecretElement) contracts.Error;
```

## fun exact

```mach
pub fun exact(input: contracts.Bytes, output: *Element) contracts.Error;
```

## fun exact_secret

```mach
pub fun exact_secret(input: contracts.SecretBytes,
output: *SecretElement) contracts.Error;
```

## fun enter

```mach
pub fun enter(parent: *Cursor, element: *Element,
child: *Cursor) contracts.Error;
```

## fun enter_secret

```mach
pub fun enter_secret(parent: *SecretCursor, element: *SecretElement,
child: *SecretCursor) contracts.Error;
```

## fun positive_integer

```mach
pub fun positive_integer(element: *Element, output: *contracts.Bytes) contracts.Error;
```

## fun positive_secret_integer

```mach
pub fun positive_secret_integer(element: *SecretElement,
output: *contracts.SecretBytes) contracts.Error;
```

## fun encoded_len

```mach
pub fun encoded_len(content_len: usize) usize;
```

## fun write

```mach
pub fun write(tag: Tag, content: contracts.Bytes,
output: contracts.Buffer) contracts.Operation;
```

