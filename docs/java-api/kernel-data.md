---
title: KernelData
---


# `KernelData`

`org.bitcoinkernel.KernelData`

Script-related data types, primarily `ScriptPubkey` with built-in script verification.

---

## ScriptPubkey

```java
public static class ScriptPubkey implements AutoCloseable {
    public ScriptPubkey(byte[] scriptPubkey) throws KernelTypes.KernelException
    public int verify(long amount, Transaction txTo,
                      TransactionOutput[] spentOutputs,
                      int inputIndex, int flags) throws KernelTypes.KernelException
    public byte[] toBytes()
    public ScriptPubkey copy()
    public void close()
}
```

Owns a locking script and provides the primary script-verification entry point. `AutoCloseable`.

---

### Constructor

```java
public ScriptPubkey(byte[] scriptPubkey) throws KernelTypes.KernelException
```

Creates a `ScriptPubkey` from raw script bytes.

Throws `KernelException` if the native object cannot be created.

---

### verify

```java
public int verify(
    long amount,
    Transaction txTo,
    TransactionOutput[] spentOutputs,
    int inputIndex,
    int flags) throws KernelTypes.KernelException
```

Verifies that input `inputIndex` of `txTo` correctly spends this script.

| Parameter | Description |
|:----------|:------------|
| `amount` | Value of the output being spent, in satoshis. Required when `VERIFY_WITNESS` is set. |
| `txTo` | The spending transaction. |
| `spentOutputs` | All outputs spent by `txTo`. Required when `VERIFY_TAPROOT` is set; may be `null` otherwise. |
| `inputIndex` | Zero-based index of the input to verify. Must be within bounds. |
| `flags` | Bitmask of `BitcoinKernel.VERIFY_*` constants. |

Returns `1` on success.

Throws `KernelTypes.KernelException` on failure. The exception's `getScriptVerifyError()` returns the specific `ScriptVerifyError` value.

**P2PKH example (no witness):**

```java
try (ScriptPubkey spk = new ScriptPubkey(p2pkhScriptBytes);
     Transaction tx  = new Transaction(rawSpendingTx)) {
    spk.verify(0, tx, null, 0, BitcoinKernel.VERIFY_P2SH);
    System.out.println("Script verified OK");
} catch (KernelTypes.KernelException e) {
    System.err.println("Verification failed: " + e.getMessage());
}
```

**Taproot example (witness + spent outputs):**

```java
TransactionOutput[] prevOuts = { /* all outputs spent by tx */ };
try (ScriptPubkey spk = new ScriptPubkey(taprootScriptBytes);
     Transaction tx  = new Transaction(rawTx)) {
    spk.verify(amountSats, tx, prevOuts, inputIndex, BitcoinKernel.VERIFY_ALL);
}
```

---

### toBytes

```java
public byte[] toBytes()
```

Returns the raw script bytes.

---

### copy

```java
public ScriptPubkey copy()
```

Returns a deep copy. The caller owns the result and must close it.
