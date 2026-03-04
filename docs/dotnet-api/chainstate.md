---
title: Chainstate
---

# `Chainstate`

`BitcoinKernel.Chain`

Chain selection, chainstate setup, block import, and spent-output reads.

---

## ChainParameters

```csharp
public sealed class ChainParameters : IDisposable
{
    public ChainParameters(ChainType chainType);
    public void Dispose();
}
```

Owns network-specific chain parameters used by `KernelContextOptions`.

---

## ChainstateManagerOptions

```csharp
public sealed class ChainstateManagerOptions : IDisposable
{
    public ChainstateManagerOptions(KernelContext context, string dataDirectory, string blocksDirectory);

    public string DataDirectory { get; }
    public string BlocksDirectory { get; }

    public ChainstateManagerOptions SetWorkerThreads(int workerThreads);
    public ChainstateManagerOptions SetWipeDbs(bool wipeBlockTreeDb, bool wipeChainstate);
    public ChainstateManagerOptions SetBlockTreeDbInMemory(bool inMemory);
    public ChainstateManagerOptions SetChainstateDbInMemory(bool inMemory);
    public void Dispose();
}
```

Configuration for constructing `ChainstateManager`.

| Method | Description |
|:-------|:------------|
| `SetWorkerThreads(int)` | Configure script-check worker threads (0-15). |
| `SetWipeDbs(bool, bool)` | Wipe block-tree and/or chainstate DB on startup. |
| `SetBlockTreeDbInMemory(bool)` | Use in-memory block-tree DB. |
| `SetChainstateDbInMemory(bool)` | Use in-memory chainstate DB. |

---

## ChainstateManager

```csharp
public sealed class ChainstateManager : IDisposable
{
    public ChainstateManager(KernelContext context, ChainParameters chainParams, ChainstateManagerOptions options);

    public Chain GetActiveChain();
    public BlockIndex GetBestBlockIndex();
    public bool ProcessBlockHeader(BlockHeader header, out BlockValidationState validationState);
    public bool ProcessBlock(Block block);

    public bool ImportBlocks(string[] blockFilePaths);
    public bool ImportBlocks();

    public BlockSpentOutputs ReadSpentOutputs(BlockIndex blockIndex);
    public void Dispose();
}
```

Primary object for chainstate operations.

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetActiveChain()` | `Chain` | Active best chain view. |
| `GetBestBlockIndex()` | `BlockIndex` | Best entry by cumulative work. |
| `ProcessBlockHeader(...)` | `bool` | Validates a header and returns copied `BlockValidationState`. |
| `ProcessBlock(Block)` | `bool` | Validates/connects block, returns whether block was new; throws `ChainstateManagerException` on processing failure. |
| `ImportBlocks(string[])` | `bool` | Imports block files from explicit paths. |
| `ImportBlocks()` | `bool` | Imports from configured blocks directory. |
| `ReadSpentOutputs(BlockIndex)` | `BlockSpentOutputs` | Reads undo/spent outputs for a block. |

---

## Chain

```csharp
public sealed class Chain
{
    public int Height { get; }
    public BlockIndex GetTip();
    public BlockIndex? GetBlockByHeight(int height);
    public BlockIndex GetGenesis();
    public bool Contains(BlockIndex blockIndex);
    public IEnumerable<BlockIndex> EnumerateBlocks();
}
```

Non-owning view over active chain entries.

| Member | Description |
|:-------|:------------|
| `Height` | Current chain tip height. |
| `GetTip()` | Returns block index at tip height. |
| `GetBlockByHeight(int)` | Returns entry or `null` if unavailable. |
| `GetGenesis()` | Returns genesis block index. |
| `Contains(BlockIndex)` | Membership test for an index in this chain. |
| `EnumerateBlocks()` | Iterates from height 0 to tip. |

---

## Example

```csharp
using BitcoinKernel;
using BitcoinKernel.Chain;
using BitcoinKernel.Interop.Enums;

using var chainParams = new ChainParameters(ChainType.MAINNET);
using var contextOptions = new KernelContextOptions().SetChainParams(chainParams);
using var context = new KernelContext(contextOptions);
using var options = new ChainstateManagerOptions(context, "/tmp/bitcoin", "/tmp/bitcoin/blocks")
    .SetWorkerThreads(4);
using var chainstate = new ChainstateManager(context, chainParams, options);

chainstate.ImportBlocks();
var chain = chainstate.GetActiveChain();
Console.WriteLine($"Height: {chain.Height}");
```
