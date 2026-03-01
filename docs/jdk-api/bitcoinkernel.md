---
title: BitcoinKernel
---


# `BitcoinKernel`

`org.bitcoinkernel.BitcoinKernel`

The main entry point and high-level facade for interacting with the kernel. Implements `AutoCloseable`.

---

## Script Verification Flag Constants

Convenience re-exports of `KernelTypes.ScriptVerificationFlags`:

| Constant | Value | Description |
|:---------|------:|:------------|
| `VERIFY_NONE` | `0` | No script verification. |
| `VERIFY_P2SH` | `1 << 0` | Enable P2SH (BIP16). |
| `VERIFY_DERSIG` | `1 << 2` | Enforce strict DER signatures (BIP66). |
| `VERIFY_NULLDUMMY` | `1 << 4` | Enforce NULLDUMMY (BIP147). |
| `VERIFY_CHECKLOCKTIMEVERIFY` | `1 << 9` | Enable CHECKLOCKTIMEVERIFY (BIP65). |
| `VERIFY_CHECKSEQUENCEVERIFY` | `1 << 10` | Enable CHECKSEQUENCEVERIFY (BIP112). |
| `VERIFY_WITNESS` | `1 << 11` | Enable Segregated Witness (BIP141). |
| `VERIFY_TAPROOT` | `1 << 17` | Enable Taproot (BIPs 341 & 342). |
| `VERIFY_ALL` | all combined | Full consensus script verification. |

---

## Constructor

```java
public BitcoinKernel(
    ChainType chainType,
    Path dataDir,
    Path blocksDir,
    Consumer<String> logger) throws KernelTypes.KernelException
```

Creates and initializes a fully configured kernel instance.

| Parameter | Description |
|:----------|:------------|
| `chainType` | Network selection: `MAINNET`, `TESTNET`, `SIGNET`, `REGTEST`, `TESTNET_4`. |
| `dataDir` | Path to the chainstate data directory (e.g. `~/.bitcoin/`). |
| `blocksDir` | Path to the blocks directory (e.g. `~/.bitcoin/blocks/`). |
| `logger` | Callback receiving all kernel log/notification messages. |

Internally, the constructor:
1. Creates `ChainParameters` from `chainType`.
2. Creates `ContextOptions` with default kernel notifications and validation interface.
3. Creates the `Context`.
4. Creates `ChainstateManagerOptions` and `ChainstateManager`.

Throws `KernelTypes.KernelException` if any initialization step fails.

---

## Methods

### getChainstateManager

```java
public ChainstateManager getChainstateManager()
```

Returns the underlying `ChainstateManager` for direct chain operations.

---

### getContext

```java
public ContextManager.Context getContext()
```

Returns the kernel `Context`.

---

### verify (static)

```java
public static void verify(
    ScriptPubkey scriptPubkey,
    long amount,
    Transaction txTo,
    TransactionOutput[] spentOutputs,
    int inputIndex,
    int flags) throws KernelTypes.KernelException
```

Convenience static method for script verification. Delegates to `ScriptPubkey.verify()`.

| Parameter | Description |
|:----------|:------------|
| `scriptPubkey` | The locking script to verify against. |
| `amount` | Output amount in satoshis. Required when `VERIFY_WITNESS` is set. |
| `txTo` | The spending transaction. |
| `spentOutputs` | All outputs spent by `txTo`. Required when `VERIFY_TAPROOT` is set. |
| `inputIndex` | Index of the input being verified. |
| `flags` | Bitmask of `VERIFY_*` constants. |

Throws `KernelTypes.KernelException` on verification error.

---

### close

```java
@Override
public void close() throws Exception
```

Destroys the chainstate manager and context, releasing all native resources.
