---
title: .NET Bindings
---

# .NET Bindings - [`BitcoinKernel.NET`](https://github.com/janb84/BitcoinKernel.NET)

`BitcoinKernel.NET` provides C# bindings for `libbitcoinkernel` with managed wrappers over native handles.

---

## Requirements

| Requirement | Value |
|:------------|:------|
| .NET SDK | 9.0+ |
| Native library | `libbitcoinkernel` (bundled for macOS x64/arm64 in current project state) |
| Main package | `BitcoinKernel` |
| Enums package | `BitcoinKernel.Interop.Enums` |

---

## Namespace Structure

| Namespace | Description |
|:----------|:------------|
| `BitcoinKernel` | Root objects like `KernelContext`, `KernelContextOptions`, `LoggingConnection`. |
| `BitcoinKernel.Chain` | `Chain`, `ChainParameters`, `ChainstateManager`, `ChainstateManagerOptions`. |
| `BitcoinKernel.Primatives` | Block/transaction primitives (`Block`, `Transaction`, `TxOut`, `Coin`, etc.). |
| `BitcoinKernel.ScriptVerification` | `ScriptVerifier` and `PrecomputedTransactionData`. |
| `BitcoinKernel.BlockProcessing` | `BlockProcessor`, `BlockTreeEntry`, validation result wrappers. |
| `BitcoinKernel.Exceptions` | Domain-specific exception hierarchy. |
| `BitcoinKernel.Interop.Enums` | Network, logging, script, and validation enums. |

---

## Memory Management

Most wrapper types own native resources and implement `IDisposable`. Use `using` / `using var` consistently.

```csharp
using BitcoinKernel;
using BitcoinKernel.Chain;
using BitcoinKernel.Interop.Enums;

using var chainParams = new ChainParameters(ChainType.MAINNET);
using var contextOptions = new KernelContextOptions().SetChainParams(chainParams);
using var context = new KernelContext(contextOptions);
using var managerOptions = new ChainstateManagerOptions(
    context,
    dataDirectory: "/path/to/datadir",
    blocksDirectory: "/path/to/blocks");
using var chainstate = new ChainstateManager(context, chainParams, managerOptions);
```

Objects returned as non-owning views (for example from `GetOutputAt()` and several chain/block accessors) must not outlive their parent objects.

---

## Quick Start

```csharp
using BitcoinKernel;
using BitcoinKernel.Chain;
using BitcoinKernel.Interop.Enums;

using var logging = new LoggingConnection((category, message, level) =>
    Console.WriteLine($"[{category}] {message}"));

using var chainParams = new ChainParameters(ChainType.MAINNET);
using var contextOptions = new KernelContextOptions().SetChainParams(chainParams);
using var context = new KernelContext(contextOptions);
using var options = new ChainstateManagerOptions(context, "/tmp/bitcoin", "/tmp/bitcoin/blocks");
using var chainstate = new ChainstateManager(context, chainParams, options);

chainstate.ImportBlocks();

var chain = chainstate.GetActiveChain();
Console.WriteLine($"Height: {chain.Height}");
Console.WriteLine($"Genesis: {Convert.ToHexString(chain.GetGenesis().GetBlockHash())}");
```
