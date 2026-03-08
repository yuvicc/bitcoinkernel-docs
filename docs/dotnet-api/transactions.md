---
title: Transactions
---

# `Transactions`

`BitcoinKernel.Primatives`

Transaction-level primitives: transactions, outputs, scripts, coins, and spent-output collections.

---

## Transaction

```csharp
public sealed class Transaction : IDisposable
{
    public Transaction(byte[] rawTransaction);
    public Transaction(string hexString);

    public static Transaction FromBytes(byte[] rawTransaction);
    public static Transaction FromHex(string hexString);

    public int InputCount { get; }
    public int OutputCount { get; }

    public byte[] GetTxid();
    public string GetTxidHex();

    public IntPtr GetInputAt(int index);
    public TxOut GetOutputAt(int index);

    public Transaction Copy();
    public void Dispose();
}
```

| Method | Description |
|:-------|:------------|
| `GetInputAt(int)` | Returns a non-owning native input pointer for low-level interop use. Pointer lifetime is tied to the parent `Transaction`. |
| `GetOutputAt(int)` | Returns output wrapper at index. |
| `Copy()` | Duplicates the transaction. |

---

## ScriptPubKey

```csharp
public sealed class ScriptPubKey : IDisposable
{
    public static ScriptPubKey FromBytes(byte[] scriptBytes);
    public static ScriptPubKey FromHex(string hexString);
    public void Dispose();
}
```

Locking-script wrapper used by `TxOut` and script verification APIs.

---

## TxOut

```csharp
public class TxOut : IDisposable
{
    public TxOut(ScriptPubKey scriptPubKey, long amount);

    public static TxOut Create(IntPtr scriptPubkeyPtr, long amount);
    public static TxOut Create(ScriptPubKey scriptPubKey, long amount);

    public long Amount { get; }
    public IntPtr GetScriptPubkeyPtr();
    public byte[] GetScriptPubkey();

    public TxOut Copy();
    public void Dispose();
}
```

Represents a single transaction output (amount + script).

---

## Coin

```csharp
public class Coin : IDisposable
{
    public uint ConfirmationHeight { get; }
    public bool IsCoinbase { get; }

    public TxOut GetOutput();
    public Coin Copy();

    public void Dispose();
}
```

Represents a spendable output and metadata.

`GetOutput()` returns a non-owning view tied to the `Coin` lifetime.

---

## TransactionSpentOutputs

```csharp
public class TransactionSpentOutputs : IDisposable
{
    public int Count { get; }
    public Coin GetCoin(int index);
    public IEnumerable<Coin> EnumerateCoins();
    public void Dispose();
}
```

Collection of spent coins for one non-coinbase transaction.

---

## Ownership Notes

- Several accessors return non-owning views/pointers (`GetInputAt`, `GetOutputAt`, `GetOutput`, spent-output traversal objects).
- Keep parent objects alive while using child views.
- Prefer `Copy()` when you need an independent owned object.
