---
title: Chainstate
---


# `Chainstate`

`org.bitcoinkernel.Chainstate`

Chain selection, synchronization state, warnings, and the chainstate management classes.

---

## ChainType

```java
public enum ChainType {
    MAINNET, TESTNET, TESTNET_4, SIGNET, REGTEST
}
```

Network selection. Pass to `ChainParameters` to configure the kernel for a specific Bitcoin network.

`getValue()` returns the native `byte` value.

---

## SynchronizationState

```java
public enum SynchronizationState {
    INIT_REINDEX, INIT_DOWNLOAD, POST_INIT
}
```

| Value | Meaning |
|:------|:--------|
| `INIT_REINDEX` | Currently reindexing from block files. |
| `INIT_DOWNLOAD` | Initial block download in progress. |
| `POST_INIT` | Fully synced, normal operation. |

`getValue()` returns the native `int` value. `fromByte(byte)` converts a raw byte back to the enum value.

---

## Warning

```java
public enum Warning {
    UNKNOWN_RULES_ACTIVATED,
    LARGE_WORK_INVALID_CHAIN
}
```

Passed to `KernelNotificationInterfaceCallbacks.warningSet()` and `warningUnset()`.

`fromByte(byte)` converts a raw byte back to the enum value.

---

## ChainParameters

```java
public static class ChainParameters implements AutoCloseable {
    public ChainParameters(ChainType chainType) throws KernelTypes.KernelException
    public void close()
}
```

Owns the chain parameters for a given network. Required to create a `ContextOptions`.

```java
try (var params = new ChainParameters(ChainType.MAINNET)) {
    options.setChainParams(params);
}
```

Throws `KernelException` if creation fails.

---

## ChainstateManagerOptions

```java
public static class ChainstateManagerOptions implements AutoCloseable {
    public ChainstateManagerOptions(Context context, String dataDir, String blocksDir)
        throws KernelTypes.KernelException
    public void setWorkerThreads(int workerThreads)
    public boolean setWipeDbs(boolean wipeBlockTree, boolean wipeChainstate)
    public void updateBlockTreeDbInMemory(boolean inMemory)
    public void updateChainstateDbInMemory(boolean inMemory)
    public void close()
}
```

Configuration object for `ChainstateManager`. Must be closed after use.

**Constructor parameters:**

| Parameter | Description |
|:----------|:------------|
| `context` | The active `Context`. |
| `dataDir` | Path to the chainstate data directory (e.g. `~/.bitcoin/`). |
| `blocksDir` | Path to the blocks directory (e.g. `~/.bitcoin/blocks/`). |

**Methods:**

| Method | Description |
|:-------|:------------|
| `setWorkerThreads(int)` | Parallel script-verification threads (0–15). |
| `setWipeDbs(boolean, boolean)` | Wipe block-tree DB and/or chainstate DB on next import. Returns `true` on success. |
| `updateBlockTreeDbInMemory(boolean)` | Use an in-memory block tree database. |
| `updateChainstateDbInMemory(boolean)` | Use an in-memory UTXO (chainstate) database. |

---

## ChainstateManager

```java
public static class ChainstateManager implements AutoCloseable {
    public ChainstateManager(Context context, ChainstateManagerOptions options)
        throws KernelTypes.KernelException
    public boolean ImportBlocks(String[] paths)
    public boolean ProcessBlock(Block block, boolean[] newBlock)
    public Chain getChain()
    public BlockTreeEntry getBlockTreeEntry(BlockHash blockHash)
    public Block readBlock(BlockTreeEntry entry)
    public BlockSpentOutputs readBlockSpentOutputs(BlockTreeEntry entry)
    public void close() throws Exception
}
```

The central object for chainstate management. `AutoCloseable` — always use in try-with-resources.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `ImportBlocks(String[])` | `boolean` | Import block files from the given paths. Pass an empty array to scan the default blocks directory. Returns `true` on success. |
| `ProcessBlock(Block, boolean[])` | `boolean` | Validate and connect a block. If `newBlock[0]` is non-null, it is set to `true` when the block was not previously known. |
| `getChain()` | `Chain` | Non-owning view of the active best chain. |
| `getBlockTreeEntry(BlockHash)` | `BlockTreeEntry` or `null` | Look up a block tree entry by hash. Returns `null` if not found. |
| `readBlock(BlockTreeEntry)` | `Block` or `null` | Read a full block from disk. Returns `null` on failure. |
| `readBlockSpentOutputs(BlockTreeEntry)` | `BlockSpentOutputs` or `null` | Read undo data (spent outputs) for a block. Returns `null` on failure. |

**Example:**

```java
try (var csm = new ChainstateManager(context, opts)) {
    csm.ImportBlocks(new String[]{});   // scan default blocks dir

    Chain chain = csm.getChain();
    for (BlockTreeEntry entry : chain) {
        System.out.println("Height: " + entry.getHeight());
    }
}
```

---

## Chain

```java
public static class Chain implements Iterable<BlockTreeEntry> {
    public int getHeight()
    public BlockTreeEntry getByHeight(int height)
    public boolean contains(BlockTreeEntry entry)
    public Iterator<BlockTreeEntry> iterator()
}
```

Non-owning view of the active best chain. Obtained from `ChainstateManager.getChain()`. Valid for the lifetime of its `ChainstateManager`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `getHeight()` | `int` | Current tip height. |
| `getByHeight(int)` | `BlockTreeEntry` | Entry at the given height. Throws `IllegalArgumentException` if out of range. |
| `contains(BlockTreeEntry)` | `boolean` | Check whether an entry belongs to this chain. |
| `iterator()` | `Iterator<BlockTreeEntry>` | Iterate from genesis (height 0) to tip. |

**Iteration example:**

```java
Chain chain = csm.getChain();
for (BlockTreeEntry entry : chain) {
    System.out.printf("Height %d: %s%n",
        entry.getHeight(),
        bytesToHex(entry.getBlockHash().toBytes()));
}
```
