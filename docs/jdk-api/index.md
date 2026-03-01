---
title: Java Bindings
---


# Java Bindings — `bitcoinkernel-jdk`

`bitcoinkernel-jdk` provides idiomatic Java bindings for libbitcoinkernel using the Foreign Function & Memory (FFM) API introduced in JDK 21 and finalized in JDK 22.

---

## Requirements

| Requirement | Value |
|:------------|:------|
| JDK | 25+ (FFM API, stable) |
| Library | `libbitcoinkernel.so` on `java.library.path` |
| Package | `org.bitcoinkernel` |

---

## Package Structure

| Class/File | Description |
|:-----------|:------------|
| `BitcoinKernel` | Main entry point. High-level facade over the kernel. |
| `KernelTypes` | Enums, flags, and `KernelException`. |
| `Chainstate` | `ChainType`, `ChainstateManager`, `Chain`, `ChainParameters`, etc. |
| `Blocks` | `Block`, `BlockHash`, `BlockTreeEntry`, `BlockValidationState`, etc. |
| `Transactions` | `Transaction`, `TransactionInput`, `TransactionOutput`, `Coin`, `Txid`, etc. |
| `KernelData` | `ScriptPubkey` with verification. |
| `NotificationsManager` | Notification and validation interface callbacks. |
| `ContextManager` | `Context`, `ContextOptions`. |
| `Logger` | `LoggingManager`, `LogCallbackHandler`, `LoggingOptions`. |

---

## Memory Management

All kernel objects that own native resources implement `AutoCloseable`. Always use **try-with-resources**:

```java
try (var spk = new ScriptPubkey(scriptBytes);
     var tx  = new Transaction(rawTx)) {
    spk.verify(amount, tx, null, inputIndex, BitcoinKernel.VERIFY_ALL);
}
```

Objects obtained as **views** (non-owned references returned from other objects) must **not** be closed. Their lifetime is tied to the parent object.

---

## Quick Start

```java
import org.bitcoinkernel.*;
import static org.bitcoinkernel.Chainstate.*;

// 1. Create kernel instance
try (BitcoinKernel kernel = new BitcoinKernel(
        ChainType.MAINNET,
        Path.of(System.getProperty("user.home"), ".bitcoin"),
        Path.of(System.getProperty("user.home"), ".bitcoin", "blocks"),
        System.out::println)) {

    // 2. Get chainstate manager
    ChainstateManager csm = kernel.getChainstateManager();

    // 3. Import blocks (triggers initial sync)
    csm.ImportBlocks(new String[]{});

    // 4. Iterate the chain
    Chain chain = csm.getChain();
    for (BlockTreeEntry entry : chain) {
        System.out.println("Height: " + entry.getHeight());
    }
}
```
