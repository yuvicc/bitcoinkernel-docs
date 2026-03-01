---
title: KernelTypes
---


# `KernelTypes`

`org.bitcoinkernel.KernelTypes`

Enumerations, flag constants, and the exception class used throughout the API.

---

## LogCategory

```java
public enum LogCategory {
    ALL, BENCH, BLOCKSTORAGE, COINDB, LEVELDB,
    MEMPOOL, PRUNE, RAND, REINDEX, VALIDATION, KERNEL
}
```

Log subsystem categories. Pass to `Logger.LoggingManager` to enable or disable specific output.

`getValue()` returns the native `byte` value. `fromByte(byte)` converts back.

---

## LogLevel

```java
public enum LogLevel {
    TRACE, DEBUG, INFO
}
```

Minimum log severity. Default is `INFO`.

---

## ScriptVerifyStatus

```java
public enum ScriptVerifyStatus {
    OK,
    ERROR_INVALID_FLAGS_COMBINATION,
    ERROR_SPENT_OUTPUTS_REQUIRED
}
```

| Value | Meaning |
|:------|:--------|
| `OK` | Verification ran successfully (script may still fail). |
| `ERROR_INVALID_FLAGS_COMBINATION` | The flags bitmask is invalid. |
| `ERROR_SPENT_OUTPUTS_REQUIRED` | `TAPROOT` flag set but spent outputs not provided. |

---

## ScriptVerificationFlags

```java
public static class ScriptVerificationFlags {
    public static final int SCRIPT_VERIFY_NONE              = ...;
    public static final int SCRIPT_VERIFY_P2SH              = ...;
    public static final int SCRIPT_VERIFY_DERSIG            = ...;
    public static final int SCRIPT_VERIFY_NULLDUMMY         = ...;
    public static final int SCRIPT_VERIFY_CHECKLOCKTIMEVERIFY = ...;
    public static final int SCRIPT_VERIFY_CHECKSEQUENCEVERIFY = ...;
    public static final int SCRIPT_VERIFY_WITNESS           = ...;
    public static final int SCRIPT_VERIFY_TAPROOT           = ...;
    public static final int SCRIPT_VERIFY_ALL               = ...;
}
```

`int` bitmask constants for script verification. Combine with `|`. Use `BitcoinKernel.VERIFY_*` as convenient aliases.

---

## KernelException

```java
public static class KernelException extends Exception {
    public enum ScriptVerifyError {
        OK, INVALID_FLAGS_COMBINATION, SPENT_OUTPUTS_REQUIRED, INVALID
    }

    public KernelException(String message)
    public KernelException(ScriptVerifyError error)
    public ScriptVerifyError getScriptVerifyError()
}
```

Thrown when a kernel operation fails. If the failure is a script verification error, `getScriptVerifyError()` returns the specific `ScriptVerifyError` value; otherwise it returns `null`.
