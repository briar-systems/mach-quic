# std.chrono.date

## rec Date

```mach
pub rec Date;
```

a calendar date without time-of-day or timezone

year: year (e.g. 2025)
month: month [1, 12]
day: day of month [1, 31]

## rec Datetime

```mach
pub rec Datetime;
```

a calendar date with time-of-day and UTC offset

year: year (e.g. 2025)
month: month [1, 12]
day: day of month [1, 31]
hour: hour [0, 23]
minute: minute [0, 59]
second: second [0, 59]
nsec: nanoseconds within second [0, 999999999]
offset: UTC offset in seconds (0 = UTC, 3600 = +01:00, -18000 = -05:00)

## fun is_leap_year

```mach
pub fun is_leap_year(year: i64) bool;
```

report whether year is a leap year

year: year to test
ret: true if year is a leap year

## fun days_in_month

```mach
pub fun days_in_month(year: i64, month: i64) i64;
```

return the number of days in a given month

year: year (needed for February)
month: month [1, 12]
ret: number of days in the month

## fun date_from_time

```mach
pub fun date_from_time(t: Time) Date;
```

extract the UTC date from a Time

t: time instant
ret: UTC calendar date

## fun datetime_from_time

```mach
pub fun datetime_from_time(t: Time) Datetime;
```

extract a UTC Datetime from a Time

t: time instant
ret: UTC datetime

## fun datetime_with_offset

```mach
pub fun datetime_with_offset(t: Time, offset: i64) Datetime;
```

extract a Datetime from a Time with a UTC offset

t: time instant
offset: UTC offset in seconds
ret: datetime adjusted to the given offset

## fun datetime_to_time

```mach
pub fun datetime_to_time(dt: Datetime) Time;
```

convert a Datetime back to a Time instant

dt: datetime to convert
ret: time instant (UTC)

## fun date_to_time

```mach
pub fun date_to_time(d: Date) Time;
```

convert a Date to a Time at midnight UTC

d: date to convert
ret: time instant at 00:00:00 UTC on the given date

## fun floor_div

```mach
pub fun floor_div(a: i64, b: i64) i64;
```

## fun civil_to_days

```mach
pub fun civil_to_days(y: i64, m: i64, d: i64) i64;
```

