---
title: ScriptVerification
---

# `ScriptVerification`

`BitcoinKernel.ScriptVerification`

Script verification helpers and precomputed transaction data.

---

## PrecomputedTransactionData

```csharp
public sealed class PrecomputedTransactionData : IDisposable
{
    public PrecomputedTransactionData(
        Transaction transaction,
        IReadOnlyList<TxOut>? spentOutputs = null);

    public void Dispose();
}
```

Precomputes script data for repeated verification on the same transaction.

Use `spentOutputs` when Taproot verification is required.

---

## ScriptVerifier

```csharp
public static class ScriptVerifier
{
    public static bool VerifyScript(
        ScriptPubKey scriptPubkey,
        long amount,
        Transaction transaction,
        PrecomputedTransactionData? precomputedTxData,
        uint inputIndex,
        ScriptVerificationFlags flags = ScriptVerificationFlags.All);

    public static bool VerifyScript(
        ScriptPubKey scriptPubkey,
        long amount,
        Transaction transaction,
        uint inputIndex,
        List<TxOut> spentOutputs,
        ScriptVerificationFlags flags = ScriptVerificationFlags.All);
}
```

Both overloads throw `ScriptVerificationException` if verification status is not `OK`.

| Parameter | Description |
|:----------|:------------|
| `scriptPubkey` | Locking script being evaluated. |
| `amount` | Amount in satoshis for spent output. |
| `transaction` | Spending transaction containing the input. |
| `inputIndex` | Input index inside `transaction`. |
| `flags` | Bitmask of `ScriptVerificationFlags`. |

Overload-specific behavior:

- `precomputedTxData` overload: best when precomputed data is reused across input checks.
- `List<TxOut>` overload: creates/destroys precomputed data internally.

---

## Example

```csharp
using BitcoinKernel.Primatives;
using BitcoinKernel.ScriptVerification;
using BitcoinKernel.Interop.Enums;

using var script = ScriptPubKey.FromHex("0014...");
using var tx = Transaction.FromHex("0200...");

var ok = ScriptVerifier.VerifyScript(
    scriptPubkey: script,
    amount: 1000,
    transaction: tx,
    precomputedTxData: null,
    inputIndex: 0,
    flags: ScriptVerificationFlags.AllPreTaproot);

Console.WriteLine($"Verified: {ok}");
```
