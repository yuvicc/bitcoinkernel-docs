---
title: Blocks
---

# `Blocks`

`BitcoinKernel.Primatives` and `BitcoinKernel.BlockProcessing`

Block primitives, block-tree access, validation state, and block processing helpers.

---

## Block

```csharp
public sealed class Block : IDisposable
{
    public static Block FromBytes(byte[] rawBlockData);

    public int TransactionCount { get; }
    public byte[] GetHash();
    public BlockHeader GetHeader();
    public byte[] ToBytes();
    public Transaction? GetTransaction(int index);
    public IEnumerable<Transaction> GetTransactions();

    public void Dispose();
}
```

Represents a full block.

| Method | Description |
|:-------|:------------|
| `FromBytes(...)` | Parses a serialized block. |
| `GetTransaction(int)` | Returns `null` when index is out of range or unavailable. |
| `GetTransactions()` | Enumerates all available transactions in order. |

---

## BlockHeader

```csharp
public sealed class BlockHeader : IDisposable
{
    public static BlockHeader FromBytes(byte[] rawHeaderData);

    public byte[] GetHash();
    public byte[] GetPrevHash();

    public uint Timestamp { get; }
    public uint Bits { get; }
    public int Version { get; }
    public uint Nonce { get; }

    public void Dispose();
}
```

`FromBytes` requires exactly 80 bytes.

---

## BlockHash

```csharp
public sealed class BlockHash : IDisposable
{
    public static BlockHash FromBytes(byte[] hash);
    public byte[] ToBytes();
    public void Dispose();
}
```

32-byte hash wrapper.

---

## BlockIndex

```csharp
public sealed class BlockIndex
{
    public int Height { get; }
    public byte[] GetBlockHash();
    public BlockIndex? GetPrevious();
    public BlockHeader GetBlockHeader();
}
```

Chain index entry, typically obtained from `Chain` or `ChainstateManager`.

---

## BlockValidationState

```csharp
public sealed class BlockValidationState : IDisposable
{
    public BlockValidationState();

    public ValidationMode ValidationMode { get; }
    public BitcoinKernel.Interop.Enums.BlockValidationResult ValidationResult { get; }

    public BlockValidationState Copy();
    public void Dispose();
}
```

Validation state object used with `ProcessBlockHeader`.

---

## BlockSpentOutputs

```csharp
public class BlockSpentOutputs : IDisposable
{
    public int Count { get; }
    public TransactionSpentOutputs GetTransactionSpentOutputs(int transactionIndex);
    public IEnumerable<TransactionSpentOutputs> EnumerateTransactionSpentOutputs();
    public void Dispose();
}
```

Undo data for a block. Each entry corresponds to a non-coinbase transaction.

---

## BlockProcessor

```csharp
public sealed class BlockProcessor
{
    public BlockProcessor(ChainstateManager chainstateManager);

    public BlockProcessingResult ProcessBlock(Block block);
    public BlockProcessingResult ProcessBlock(byte[] rawBlockData);
    public BlockValidationResult ValidateBlock(Block block);

    public Block ReadBlock(BlockTreeEntry blockTreeEntry);
    public BlockTreeEntry? GetBlockTreeEntry(byte[] blockHash);
}
```

High-level helper over `ChainstateManager` for process/read workflows.

---

## BlockProcessingResult

```csharp
public sealed class BlockProcessingResult
{
    public bool Success { get; }
    public bool IsNewBlock { get; }
}
```

Returned by `BlockProcessor.ProcessBlock(...)`.

---

## BlockTreeEntry

```csharp
public sealed class BlockTreeEntry : IEquatable<BlockTreeEntry>
{
    public byte[] GetBlockHash();
    public BlockTreeEntry? GetPrevious();
    public int GetHeight();
}
```

Block-tree lookup type used by `BlockProcessor`.

---

## BlockValidationResult (wrapper)

```csharp
public sealed class BlockValidationResult
{
    public bool IsValid { get; }
    public ValidationMode Mode { get; }
    public int? ErrorCode { get; }
    public string? ErrorMessage { get; }
}
```

Structured validation outcome for `BlockProcessor.ValidateBlock(...)`.

This wrapper type is `BitcoinKernel.BlockProcessing.BlockValidationResult`, and is distinct from enum `BitcoinKernel.Interop.Enums.BlockValidationResult`.
