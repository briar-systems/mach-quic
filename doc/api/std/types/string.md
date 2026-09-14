# std.types.string

## def str

```mach
pub def str: *char
```

a pointer to a null-terminated sequence of char

## fun str_len

```mach
pub fun str_len(s: str) usize;
```

calculate the length of a null-terminated string

ret: length of the string (not including null terminator)

## fun str_empty

```mach
pub fun str_empty(s: str) bool;
```

check if the string is empty or nil

ret: true if the string has zero length or is nil

## fun str_equals

```mach
pub fun str_equals(s: str, other: str) bool;
```

compare two null-terminated strings for equality

other: the other string to compare against
ret: true if the strings are equal

## fun str_region_equals

```mach
pub fun str_region_equals(s: str, start: usize, len: usize, other: str) bool;
```

compare a region of a string against a pattern

start: byte offset into s
len: number of bytes to compare
other: null-terminated string to compare against
ret: true if s[start..start+len] equals other exactly

## fun str_compare

```mach
pub fun str_compare(s: str, other: str) i64;
```

compare two null-terminated strings lexically

other: the other string to compare against
ret: <0 if s < other, 0 if equal, >0 if s > other

## fun str_starts_with

```mach
pub fun str_starts_with(s: str, prefix: str) bool;
```

check if the string starts with the given prefix

prefix: the prefix to check
ret: true if the string starts with prefix

## fun str_ends_with

```mach
pub fun str_ends_with(s: str, suffix: str) bool;
```

check if the string ends with the given suffix

suffix: the suffix to check
ret: true if the string ends with suffix

## fun str_index_of

```mach
pub fun str_index_of(s: str, sub: str) O.Option[usize];
```

find the first index of a substring

sub: the substring to find
ret: the index of the first occurrence, or none

## fun str_index_of_from

```mach
pub fun str_index_of_from(s: str, sub: str, from: usize) O.Option[usize];
```

find the first index of a substring at or after a starting offset

sub: the substring to find
from: byte offset to begin scanning at
ret: the index of the first occurrence at or after from, or none

## fun str_last_index_of

```mach
pub fun str_last_index_of(s: str, sub: str) O.Option[usize];
```

find the last index of a substring

sub: the substring to find
ret: the index of the last occurrence, or none

## fun str_contains

```mach
pub fun str_contains(s: str, sub: str) bool;
```

check if the string contains the given substring

sub: the substring to check
ret: true if the string contains sub

## fun str_find

```mach
pub fun str_find(s: str, sub: str) O.Option[str];
```

find the first occurrence of a substring and return a pointer to it

sub: the substring to find
ret: pointer into s at the first occurrence, or none

## fun str_find_last

```mach
pub fun str_find_last(s: str, sub: str) O.Option[str];
```

find the last occurrence of a substring and return a pointer to it

sub: the substring to find
ret: pointer into s at the last occurrence, or none

## fun str_index_char

```mach
pub fun str_index_char(s: str, c: char) O.Option[usize];
```

find the first occurrence of a character in a string

c: character to find
ret: the index of the first occurrence, or none

## fun str_last_index_char

```mach
pub fun str_last_index_char(s: str, c: char) O.Option[usize];
```

find the last occurrence of a character in a string

c: character to find
ret: the index of the last occurrence, or none

## fun str_contains_char

```mach
pub fun str_contains_char(s: str, c: char) bool;
```

check if a string contains a character

c: character to find
ret: true if c appears in s

## fun str_find_char

```mach
pub fun str_find_char(s: str, c: char) O.Option[str];
```

find the first occurrence of a character and return a pointer to it

c: character to find
ret: pointer into s at the first occurrence, or none

## fun str_find_last_char

```mach
pub fun str_find_last_char(s: str, c: char) O.Option[str];
```

find the last occurrence of a character and return a pointer to it

c: character to find
ret: pointer into s at the last occurrence, or none

## fun str_copy

```mach
pub fun str_copy(a: *A.Allocator, s: str) R.Result[str, str];
```

create a copy of a string using the given allocator

a: allocator to use for the copy
s: string to copy
ret: the copied string, or an error on allocation failure

## fun str_copy_slice

```mach
pub fun str_copy_slice(a: *A.Allocator, s: str, start: usize, len: usize) R.Result[str, str];
```

create a copy of a slice of a string using the given allocator

a: allocator to use for the copy
s: string to copy from
start: starting index of the slice
len: length of the slice
ret: the copied slice, or an error on allocation failure or invalid indices

## fun str_join

```mach
pub fun str_join(a: *A.Allocator, va: ...) R.Result[str, str];
```

join any number of strings into one newly allocated string

nil arguments contribute nothing, matching str_len/str_empty. a
zero-argument call returns an allocated empty string. every argument
must be a str, enforced at compile time.

a: allocator for the result
va: strings to concatenate, in order
ret: the joined string, or an error on allocation failure

## fun str_trim

```mach
pub fun str_trim(a: *A.Allocator, s: str) R.Result[str, str];
```

trim leading and trailing whitespace from a string, returning a new allocated string

a: allocator to use for the new string
s: string to trim
ret: the trimmed string, or an error on allocation failure

## fun str_trim_right

```mach
pub fun str_trim_right(a: *A.Allocator, s: str) R.Result[str, str];
```

trim trailing whitespace from a string, returning a new allocated string

a: allocator to use for the new string
s: string to trim
ret: the trimmed string, or an error on allocation failure

## fun str_trim_left

```mach
pub fun str_trim_left(a: *A.Allocator, s: str) R.Result[str, str];
```

trim leading whitespace from a string, returning a new allocated string

a: allocator to use for the new string
s: string to trim
ret: the trimmed string, or an error on allocation failure

## fun str_to_lower

```mach
pub fun str_to_lower(a: *A.Allocator, s: str) R.Result[str, str];
```

lowercase a string (ASCII), returning a new allocated string

a: allocator for the result
s: string to lowercase
ret: the lowercased string, or an error on allocation failure

## fun str_to_upper

```mach
pub fun str_to_upper(a: *A.Allocator, s: str) R.Result[str, str];
```

uppercase a string (ASCII), returning a new allocated string

a: allocator for the result
s: string to uppercase
ret: the uppercased string, or an error on allocation failure

## fun str_repeat

```mach
pub fun str_repeat(a: *A.Allocator, s: str, n: usize) R.Result[str, str];
```

repeat a string n times, returning a new allocated string

a: allocator for the result
s: string to repeat
n: number of repetitions (0 yields an empty string)
ret: the repeated string, or an error on allocation failure or size overflow

## fun str_replace

```mach
pub fun str_replace(a: *A.Allocator, s: str, old: str, new: str) R.Result[str, str];
```

replace every occurrence of a substring, returning a new allocated string

occurrences are found left to right and do not overlap. a nil or empty
`old` yields a plain copy of `s`.

a: allocator for the result
s: string to replace within
old: substring to replace
new: replacement substring
ret: the replaced string, or an error on allocation failure

