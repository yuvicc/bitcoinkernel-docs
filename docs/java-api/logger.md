---
title: Logger
---


# `Logger`

`org.bitcoinkernel.Logger`

Logging configuration, category/level management, and the log-callback registration helper.

---

## LoggingOptions

```java
public static class LoggingOptions implements AutoCloseable {
    public LoggingOptions()
    public void setLogTimestamps(boolean enabled)
    public void setLogTimeMicros(boolean enabled)
    public void setLogThreadNames(boolean enabled)
    public void setLogSourceLocations(boolean enabled)
    public void setAlwaysPrintCategoryLevels(boolean enabled)
    public boolean getLogTimestamps()
    public boolean getLogTimeMicros()
    public boolean getLogThreadNames()
    public boolean getLogSourceLocations()
    public boolean getAlwaysPrintCategoryLevels()
    public void close()
}
```

Controls the format of log output. Pass to `LoggingManager.setOptions()`. `AutoCloseable`.

**Default values:**

| Option | Default |
|:-------|:--------|
| `logTimestamps` | `true` |
| `logTimeMicros` | `false` |
| `logThreadNames` | `false` |
| `logSourceLocations` | `false` |
| `alwaysPrintCategoryLevels` | `false` |

**Option descriptions:**

| Setter | Description |
|:-------|:------------|
| `setLogTimestamps(boolean)` | Prefix each log line with a timestamp. |
| `setLogTimeMicros(boolean)` | Use microsecond precision in timestamps. |
| `setLogThreadNames(boolean)` | Include the originating thread name. |
| `setLogSourceLocations(boolean)` | Include source file and line number. |
| `setAlwaysPrintCategoryLevels(boolean)` | Always print category/level prefix even when category is not filtered. |

---

## LoggingManager

```java
public static class LoggingManager {
    public static void disable()
    public static void setOptions(LoggingOptions options)
    public static void setLevelCategory(LogCategory category, LogLevel level)
    public static void enableCategory(LogCategory category)
    public static void disableCategory(LogCategory category)
}
```

Static utility class — cannot be instantiated. Controls global kernel logging behavior.

**Methods:**

| Method | Description |
|:-------|:------------|
| `disable()` | Disable all kernel logging output. |
| `setOptions(LoggingOptions)` | Apply a `LoggingOptions` configuration. |
| `setLevelCategory(LogCategory, LogLevel)` | Set the minimum log level for a specific category. |
| `enableCategory(LogCategory)` | Enable output for a log category. |
| `disableCategory(LogCategory)` | Suppress output for a log category. |

**Example:**

```java
try (LoggingOptions opts = new LoggingOptions()) {
    opts.setLogTimestamps(true);
    opts.setLogTimeMicros(true);
    LoggingManager.setOptions(opts);
}

LoggingManager.enableCategory(LogCategory.VALIDATION);
LoggingManager.setLevelCategory(LogCategory.VALIDATION, LogLevel.DEBUG);
LoggingManager.disableCategory(LogCategory.LEVELDB);
```

---

## LogCallbackHandler

```java
public static class LogCallbackHandler implements AutoCloseable {
    public LogCallbackHandler(Consumer<String> logConsumer)
    public void close()
}
```

Registers a Java `Consumer<String>` to receive all kernel log messages. The consumer is called once per log line from native code via a shared-arena upcall stub.

Must be kept alive for as long as you want to receive log messages.

**Constructor parameter:**

| Parameter | Description |
|:----------|:------------|
| `logConsumer` | Called with each raw log message string. |

**Example:**

```java
try (var logHandler = new LogCallbackHandler(System.out::println)) {
    // kernel log output now goes to System.out
    // ... run kernel operations ...
}
```

!!! note
    `LogCallbackHandler` registers at the global logging level — there is no binding to a specific `Context`. Create it before constructing a `Context` so that initialization log messages are captured.
