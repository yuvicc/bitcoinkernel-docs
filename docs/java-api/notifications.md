---
title: NotificationsManager
---


# `NotificationsManager`

`org.bitcoinkernel.NotificationsManager`

Callback interfaces and manager classes for kernel event notifications and block validation events.

---

## KernelNotificationInterfaceCallbacks

```java
public interface KernelNotificationInterfaceCallbacks {
    void blockTip(SynchronizationState state, BlockTreeEntry blockIndex,
                  double verificationProgress);
    void headerTip(SynchronizationState state, long height,
                   long timestamp, boolean presync);
    void progress(String title, int progressPercent, boolean resumePossible);
    void warningSet(Warning warning, String message);
    void warningUnset(Warning warning);
    void flushError(String message);
    void fatalError(String message);
}
```

Implement this interface to receive kernel lifecycle notifications. Pass an implementation to `KernelNotificationManager`.

| Method | When called |
|:-------|:------------|
| `blockTip` | The active chain tip changed. `verificationProgress` is 0.0–1.0. |
| `headerTip` | A new best header was received. `presync` is `true` during header presync. |
| `progress` | Long-running operation progress update. |
| `warningSet` | A kernel warning was raised. |
| `warningUnset` | A previously raised warning was cleared. |
| `flushError` | A non-fatal flush/write error occurred. |
| `fatalError` | A fatal error occurred. The process should terminate. |

!!! danger "`fatalError` is critical"
    If called, the kernel is in an unrecoverable state. Your implementation must log the message and terminate the process.

**Example:**

```java
var notifications = new KernelNotificationManager(
    new KernelNotificationInterfaceCallbacks() {
        @Override
        public void blockTip(SynchronizationState state,
                             BlockTreeEntry entry,
                             double progress) {
            System.out.printf("Tip: height=%d  progress=%.1f%%%n",
                entry.getHeight(), progress * 100);
        }
        @Override
        public void fatalError(String message) {
            System.err.println("FATAL: " + message);
            System.exit(1);
        }
        // ... other methods
    });
```

---

## ValidationInterfaceCallbacks

```java
public interface ValidationInterfaceCallbacks {
    void blockChecked(Block block, BlockValidationState state);
    void powValidBlock(Block block, BlockTreeEntry blockIndex);
    void blockConnected(Block block, BlockTreeEntry blockIndex);
    void blockDisconnected(Block block, BlockTreeEntry blockIndex);
}
```

Implement this interface to receive block validation lifecycle events. Pass an implementation to `ValidationInterfaceManager`.

| Method | When called |
|:-------|:------------|
| `blockChecked` | After a block has been checked (may be valid or invalid). |
| `powValidBlock` | After a block passed proof-of-work validation. |
| `blockConnected` | After a block was connected to the chain. |
| `blockDisconnected` | After a block was disconnected from the chain (reorg). |

!!! warning
    These callbacks **block** further validation execution while running. Keep implementations fast — no I/O or locks that could cause contention.

---

## KernelNotificationManager

```java
public static class KernelNotificationManager implements AutoCloseable {
    public KernelNotificationManager(KernelNotificationInterfaceCallbacks callbacks)
    public void close()
}
```

Wraps a `KernelNotificationInterfaceCallbacks` implementation and registers native upcall stubs. Pass `getCallbackStruct()` (internal) to `ContextOptions.setNotifications()`.

Must be kept alive for the lifetime of the `Context` that uses it.

```java
try (var notifMgr = new KernelNotificationManager(myCallbacks);
     var opts     = new ContextOptions()) {
    opts.setNotifications(notifMgr);
    try (var ctx = new Context(opts)) {
        // ctx uses notifMgr
    }
}
```

---

## ValidationInterfaceManager

```java
public static class ValidationInterfaceManager implements AutoCloseable {
    public ValidationInterfaceManager(ValidationInterfaceCallbacks callbacks)
    public void close()
}
```

Wraps a `ValidationInterfaceCallbacks` implementation and registers native upcall stubs. Pass to `ContextOptions.setValidationInterface()`.

Must be kept alive for the lifetime of the `Context` that uses it.

```java
try (var valMgr = new ValidationInterfaceManager(myValidationCallbacks);
     var opts   = new ContextOptions()) {
    opts.setValidationInterface(valMgr);
    try (var ctx = new Context(opts)) {
        // ctx uses valMgr
    }
}
```
