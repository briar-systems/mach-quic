# std.io.lifecycle

## def State

```mach
pub def State: u8
```

## val OPEN

```mach
pub val OPEN: State = 0
```

## val CLOSING

```mach
pub val CLOSING: State = 1
```

## val CLOSED

```mach
pub val CLOSED: State = 2
```

## def Mode

```mach
pub def Mode: u8
```

## val GRACEFUL

```mach
pub val GRACEFUL: Mode = 0
```

## val ABORTIVE

```mach
pub val ABORTIVE: Mode = 1
```

## def Cause

```mach
pub def Cause: u8
```

## val EXPLICIT

```mach
pub val EXPLICIT: Cause = 0
```

## val PROCESS_TERMINATION

```mach
pub val PROCESS_TERMINATION: Cause = 1
```

## val DEADLINE

```mach
pub val DEADLINE: Cause = 2
```

## val CANCELLATION

```mach
pub val CANCELLATION: Cause = 3
```

## val FAILURE

```mach
pub val FAILURE: Cause = 4
```

## rec Lifecycle

```mach
pub rec Lifecycle;
```

## rec Attachment

```mach
pub rec Attachment;
```

## rec Snapshot

```mach
pub rec Snapshot;
```

## rec CloseResult

```mach
pub rec CloseResult;
```

## fun make

```mach
pub fun make(lifecycle: *Lifecycle) bool;
```

## fun attach

```mach
pub fun attach(lifecycle: *Lifecycle, attachment: *Attachment) bool;
```

## fun settle

```mach
pub fun settle(attachment: *Attachment) bool;
```

## fun begin_close

```mach
pub fun begin_close(lifecycle: *Lifecycle, mode: Mode, cause: Cause) CloseResult;
```

## fun begin_process_drain

```mach
pub fun begin_process_drain(lifecycle: *Lifecycle) CloseResult;
```

## fun fail

```mach
pub fun fail(lifecycle: *Lifecycle) CloseResult;
```

## fun snapshot

```mach
pub fun snapshot(lifecycle: *Lifecycle) Snapshot;
```

## fun settle_closed_child

```mach
pub fun settle_closed_child(attachment: *Attachment, child: *Lifecycle) bool;
```

