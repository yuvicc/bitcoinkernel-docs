---
title: Logger
---

# `Logger`

`BitcoinKernel.LoggingConnection`

Registers a managed callback for native kernel log output.

---

## LoggingConnection

```csharp
public sealed class LoggingConnection : IDisposable
{
    public LoggingConnection(Action<string, string, int> callback);
    public void Dispose();
}
```

`LoggingConnection` keeps a native logging callback active for its lifetime.

| Callback arg | Meaning |
|:-------------|:--------|
| `string category` | Log category name. Current wrapper currently reports default `"kernel"`. |
| `string message` | Log message text from native code. |
| `int level` | Log level value. Current wrapper currently reports default `2` (info). |

---

## Usage

```csharp
using BitcoinKernel;

using var logging = new LoggingConnection((category, message, level) =>
{
    Console.WriteLine($"[{level}] {category}: {message}");
});

// Keep the object alive while kernel operations run.
```

---

## Notes

- Dispose `LoggingConnection` when logging is no longer needed.
- Callback lifetime is pinned internally so it remains valid for native calls.
- Current implementation includes TODO behavior for parsing exact native category/level from raw message text.
