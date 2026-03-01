---
title: Blocks
---


# `Blocks`

`org.bitcoinkernel.Blocks`

Block-related types: validation state, hashes, block tree entries, full blocks, and spent-output undo data.

---

## ValidationMode

```java
public enum ValidationMode {
    VALID, INVALID, INTERNAL_ERROR
}
```

High-level validation outcome retrieved from `BlockValidationState`.

`getValue()` returns the native `byte`. `fromByte(byte)` converts back.

---

## BlockValidationState

```java
public static class BlockValidationState {
    public ValidationMode getValidationMode()
    public BlockValidationResult getBlockValidationResult()
    public boolean isValid()
    public boolean isInvalid()
    public boolean hasError()
    public String getDescription()
}
```

Describes the outcome of a block validation operation. Passed to `ValidationInterfaceCallbacks.blockChecked()`.

**Inner enum — `BlockValidationResult`:**

```java
public enum BlockValidationResult {
    UNSET, CONSENSUS, CACHED_INVALID, INVALID_HEADER,
    MUTATED, MISSING_PREV, INVALID_PREV, TIME_FUTURE, HEADER_LOW_WORK
}
```

| Value | Meaning |
|:------|:--------|
| `UNSET` | No result yet. |
| `CONSENSUS` | Failed a consensus rule. |
| `CACHED_INVALID` | Previously found invalid. |
| `INVALID_HEADER` | Block header is invalid. |
| `MUTATED` | Duplicate transaction in the block. |
| `MISSING_PREV` | Previous block not available. |
| `INVALID_PREV` | Previous block is invalid. |
| `TIME_FUTURE` | Block timestamp too far in the future. |
| `HEADER_LOW_WORK` | Insufficient proof-of-work in header. |

**Convenience methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `isValid()` | `boolean` | `true` if `ValidationMode == VALID`. |
| `isInvalid()` | `boolean` | `true` if `ValidationMode == INVALID`. |
| `hasError()` | `boolean` | `true` if `ValidationMode == INTERNAL_ERROR`. |
| `getDescription()` | `String` | Human-readable summary string. |

---

## BlockHash

```java
public static class BlockHash implements AutoCloseable {
    public BlockHash(byte[] hash) throws KernelTypes.KernelException
    public byte[] toBytes()
    public boolean equals(BlockHash other)
    public BlockHash copy()
    public void close() throws Exception
}
```

Wraps a 32-byte block hash. `AutoCloseable` — owned instances must be closed.

| Parameter | Constraint |
|:----------|:-----------|
| `hash` | Must be exactly 32 bytes. |

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `toBytes()` | `byte[32]` | Raw big-endian hash bytes. |
| `equals(BlockHash)` | `boolean` | Byte-level equality comparison. |
| `copy()` | `BlockHash` | Deep copy (caller owns the result). |

!!! note
    `BlockHash` objects returned as non-owned views (e.g. from `BlockTreeEntry.getBlockHash()`) must **not** be closed.

---

## BlockTreeEntry

```java
public static class BlockTreeEntry {
    public BlockTreeEntry getPrevious()
    public int getHeight()
    public BlockHash getBlockHash()
}
```

Non-owning view of a block index entry. Valid for the lifetime of the `ChainstateManager` that created it.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `getPrevious()` | `BlockTreeEntry` or `null` | Parent entry, or `null` for genesis. |
| `getHeight()` | `int` | Block height. |
| `getBlockHash()` | `BlockHash` | Non-owned block hash (do **not** close). |

---

## Block

```java
public static class Block implements AutoCloseable {
    public Block(byte[] rawBlock) throws KernelTypes.KernelException
    public BlockHash getHash()
    public long countTransaction()
    public Transaction getTransaction(long index)
    public byte[] toBytes()
    public void close() throws Exception
}
```

A full deserialized block. `AutoCloseable`.

**Constructor:**

| Parameter | Description |
|:----------|:------------|
| `rawBlock` | Raw consensus-serialized block bytes. |

Throws `KernelException` if the block cannot be deserialized.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `getHash()` | `BlockHash` (owned) | Block hash. Caller must close. |
| `countTransaction()` | `long` | Number of transactions in the block. |
| `getTransaction(long)` | `Transaction` (view) | Transaction at the given index (non-owned). |
| `toBytes()` | `byte[]` | Consensus serialization of the block. |

**Example — iterate block transactions:**

```java
try (Block block = csm.readBlock(entry)) {
    if (block == null) return;
    for (long i = 0; i < block.countTransaction(); i++) {
        Transaction tx = block.getTransaction(i);
        System.out.println("txid: " + bytesToHex(tx.getTxid().toBytes()));
    }
}
```

---

## BlockSpentOutputs

```java
public static class BlockSpentOutputs implements AutoCloseable, Iterable<TransactionSpentOutputs> {
    public long count()
    public TransactionSpentOutputs getTransactionSpentOutputs(long index)
    public BlockSpentOutputs copy()
    public Iterator<TransactionSpentOutputs> iterator()
    public void close()
}
```

Undo data for a block — the outputs spent by each non-coinbase transaction. Obtained from `ChainstateManager.readBlockSpentOutputs()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `count()` | `long` | Number of non-coinbase transactions with spent output records. |
| `getTransactionSpentOutputs(long)` | `TransactionSpentOutputs` | Spent outputs for the transaction at index `i`. |
| `copy()` | `BlockSpentOutputs` (owned) | Deep copy. Caller must close. |
| `iterator()` | `Iterator<TransactionSpentOutputs>` | Iterate all transaction spent output records. |
