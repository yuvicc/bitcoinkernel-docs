---
title: Context
---

# `Context`

`BitcoinKernel.KernelContext` and `BitcoinKernel.KernelContextOptions`

Root context objects used to configure and run kernel operations.

---

## KernelContextOptions

```csharp
public sealed class KernelContextOptions : IDisposable
{
    public KernelContextOptions();
    public KernelContextOptions SetChainParams(ChainParameters chainParams);
    public void Dispose();
}
```

Builder for context configuration.

| Method | Description |
|:-------|:------------|
| `SetChainParams(ChainParameters)` | Sets network/chain parameters for context creation. |

`SetChainParams` returns the same options instance for fluent chaining.

---

## KernelContext

```csharp
public sealed class KernelContext : IDisposable
{
    public KernelContext(KernelContextOptions? options = null);
    public void Interrupt();
    public void Dispose();
}
```

Main kernel entry-point object.

| Member | Description |
|:-------|:------------|
| `KernelContext(...)` | Creates a context using optional options. If omitted, native defaults are used. |
| `Interrupt()` | Signals long-running operations associated with this context to stop. |
| `Dispose()` | Releases native context resources. |

---

## Lifecycle Notes

- Keep `KernelContext` alive for the full lifetime of dependent objects (`ChainstateManagerOptions`, `ChainstateManager`).
- Dispose in reverse construction order.

```csharp
using BitcoinKernel;
using BitcoinKernel.Chain;
using BitcoinKernel.Interop.Enums;

using var chainParams = new ChainParameters(ChainType.SIGNET);
using var contextOptions = new KernelContextOptions().SetChainParams(chainParams);
using var context = new KernelContext(contextOptions);
using var options = new ChainstateManagerOptions(context, "/tmp/bitcoin", "/tmp/bitcoin/blocks");
using var chainstate = new ChainstateManager(context, chainParams, options);

// ... use chainstate
```
