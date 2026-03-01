---
title: Transactions
---


# `Transactions`

`org.bitcoinkernel.Transactions`

Transaction, input, output, outpoint, coin, txid, and spent-output types.

---

## Transaction

```java
public static class Transaction implements AutoCloseable {
    public Transaction(byte[] rawTransaction)
    public Transaction copy()
    public long countInputs()
    public long countOutputs()
    public TransactionInput getInput(long index)
    public TransactionOutput getOutput(long index)
    public Txid getTxid()
    public void close()
}
```

A deserialized Bitcoin transaction. `AutoCloseable`.

**Constructor:**

| Parameter | Description |
|:----------|:------------|
| `rawTransaction` | Raw consensus-serialized transaction bytes. Must be non-null and non-empty. |

Throws `IllegalArgumentException` if the bytes are null, empty, or cannot be deserialized.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `copy()` | `Transaction` (owned) | Deep copy. Caller must close. |
| `countInputs()` | `long` | Number of inputs. |
| `countOutputs()` | `long` | Number of outputs. |
| `getInput(long)` | `TransactionInput` (view) | Input at index (non-owned, do not close). |
| `getOutput(long)` | `TransactionOutput` (view) | Output at index (non-owned, do not close). |
| `getTxid()` | `Txid` (view) | Transaction ID (non-owned, do not close). |

**Example:**

```java
try (Transaction tx = new Transaction(rawTxBytes)) {
    System.out.println("Inputs:  " + tx.countInputs());
    System.out.println("Outputs: " + tx.countOutputs());
    System.out.println("Txid:    " + bytesToHex(tx.getTxid().toBytes()));
}
```

---

## TransactionInput

```java
public static class TransactionInput implements AutoCloseable {
    public TransactionInput copy()
    public TransactionOutPoint getOutPoint()
    public void close() throws Exception
}
```

A single transaction input. Obtained as a non-owned view from `Transaction.getInput()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `copy()` | `TransactionInput` (owned) | Deep copy. Caller must close. |
| `getOutPoint()` | `TransactionOutPoint` | The outpoint being spent (non-owned view). |

!!! note
    Inputs returned from `Transaction.getInput()` are non-owned views. Only close inputs obtained via `copy()`.

---

## TransactionOutPoint

```java
public static class TransactionOutPoint implements AutoCloseable {
    public TransactionOutPoint copy()
    public long getIndex()
    public Txid getTxid()
    public void close() throws Exception
}
```

Identifies a specific output of a previous transaction (txid + vout index).

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `copy()` | `TransactionOutPoint` (owned) | Deep copy. Caller must close. |
| `getIndex()` | `long` | Output index (vout), as unsigned 32-bit value. |
| `getTxid()` | `Txid` | The referenced transaction ID (non-owned view). |

---

## TransactionOutput

```java
public static class TransactionOutput implements AutoCloseable {
    public TransactionOutput(ScriptPubkey scriptPubkey, long amount)
    public TransactionOutput copy()
    public long getAmount()
    public ScriptPubkey getScriptPubKey()
    public void close()
}
```

A transaction output — an amount and a locking script. Can be constructed directly or obtained as a view.

**Constructor:**

| Parameter | Description |
|:----------|:------------|
| `scriptPubkey` | The locking script. |
| `amount` | Value in satoshis. |

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `copy()` | `TransactionOutput` (owned) | Deep copy. Caller must close. |
| `getAmount()` | `long` | Amount in satoshis. |
| `getScriptPubKey()` | `ScriptPubkey` (view) | Non-owned view of the locking script. Do not close. |

---

## Coin

```java
public static class Coin implements AutoCloseable {
    public long getConfirmationHeight()
    public boolean isCoinbase()
    public TransactionOutput getOutput()
    public Coin copy()
    public void close() throws Exception
}
```

A UTXO (unspent transaction output) with metadata. Obtained from `TransactionSpentOutputs.getCoin()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `getConfirmationHeight()` | `long` | Block height at which this coin was created (unsigned 32-bit). |
| `isCoinbase()` | `boolean` | Whether this output comes from a coinbase transaction. |
| `getOutput()` | `TransactionOutput` (view) | The underlying output. Non-owned; do not close. |
| `copy()` | `Coin` (owned) | Deep copy. Caller must close. |

---

## Txid

```java
public static class Txid implements AutoCloseable {
    public Txid copy()
    public byte[] toBytes()
    public boolean equals(Txid other)
    public void close() throws Exception
}
```

A 32-byte transaction identifier. Usually obtained as a non-owned view from `Transaction.getTxid()` or `TransactionOutPoint.getTxid()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `copy()` | `Txid` (owned) | Deep copy. Caller must close. |
| `toBytes()` | `byte[32]` | Raw txid bytes. |
| `equals(Txid)` | `boolean` | Byte-level equality. |

!!! note
    `Txid` objects returned as views (from `getTxid()`) must **not** be closed. Only close instances obtained via `copy()`.

---

## TransactionSpentOutputs

```java
public static class TransactionSpentOutputs implements Iterable<Coin> {
    public long count()
    public Coin getCoin(long index)
    public TransactionSpentOutputs copy()
    public Iterator<Coin> iterator()
    public void close()
}
```

The set of coins spent by a single non-coinbase transaction. Obtained from `BlockSpentOutputs.getTransactionSpentOutputs()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `count()` | `long` | Number of spent coins (equals the number of inputs). |
| `getCoin(long)` | `Coin` (view) | Coin at index `i`. Non-owned; do not close. |
| `copy()` | `TransactionSpentOutputs` (owned) | Deep copy. Caller must close. |
| `iterator()` | `Iterator<Coin>` | Iterate all spent coins. |

**Example — iterate undo data:**

```java
try (BlockSpentOutputs undoData = csm.readBlockSpentOutputs(entry)) {
    if (undoData == null) return;
    for (TransactionSpentOutputs txSpent : undoData) {
        for (Coin coin : txSpent) {
            System.out.println("  amount: " + coin.getOutput().getAmount());
        }
    }
}
```
