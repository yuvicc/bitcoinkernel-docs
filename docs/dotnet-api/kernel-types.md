---
title: KernelTypes
---

# `KernelTypes`

`BitcoinKernel.Interop.Enums` and `BitcoinKernel.Exceptions`

Core enums and exception types used across the .NET bindings.

---

## ChainType

```csharp
public enum ChainType : uint
{
    MAINNET = 0,
    TESTNET = 1,
    TESTNET_4 = 2,
    SIGNET = 3,
    REGTEST = 4
}
```

Selects the Bitcoin network for `ChainParameters`.

---

## ScriptVerificationFlags

```csharp
[Flags]
public enum ScriptVerificationFlags : uint
{
    None,
    P2SH,
    DerSig,
    NullDummy,
    CheckLockTimeVerify,
    CheckSequenceVerify,
    Witness,
    Taproot,
    All,
    AllPreTaproot
}
```

Use these flags with `ScriptVerifier.VerifyScript(...)`.

| Flag | Description |
|:-----|:------------|
| `None` | No script checks. |
| `P2SH` | BIP16 evaluation. |
| `DerSig` | Strict DER signatures (BIP66). |
| `NullDummy` | NULLDUMMY checks (BIP147). |
| `CheckLockTimeVerify` | Enable CLTV (BIP65). |
| `CheckSequenceVerify` | Enable CSV (BIP112). |
| `Witness` | SegWit rules (BIP141). |
| `Taproot` | Taproot/Tapscript rules (BIP341/342). |
| `All` | Full standard verification set. |
| `AllPreTaproot` | Full verification without Taproot. |

---

## ScriptVerifyStatus

```csharp
public enum ScriptVerifyStatus : byte
{
    OK,
    ERROR_INVALID_FLAGS_COMBINATION,
    ERROR_SPENT_OUTPUTS_REQUIRED,
    ERROR_TX_INPUT_INDEX,
    ERROR_SPENT_OUTPUTS_MISMATCH,
    ERROR_INVALID_FLAGS
}
```

Detailed status returned by native script verification.

---

## ValidationMode

```csharp
public enum ValidationMode : byte
{
    VALID = 0,
    INVALID = 1,
    INTERNAL_ERROR = 2
}
```

Shared status model for block validation outcomes.

---

## BlockValidationResult

```csharp
public enum BlockValidationResult : uint
{
    UNSET,
    CONSENSUS,
    CACHED_INVALID,
    INVALID_HEADER,
    MUTATED,
    MISSING_PREV,
    INVALID_PREV,
    TIME_FUTURE,
    HEADER_LOW_WORK
}
```

Granular reason for block invalidity.

This enum is `BitcoinKernel.Interop.Enums.BlockValidationResult`, and is distinct from the wrapper class `BitcoinKernel.BlockProcessing.BlockValidationResult` used by `BlockProcessor.ValidateBlock(...)`.

---

## LogLevel

```csharp
public enum LogLevel : uint
{
    TRACE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
    FATAL,
    NONE
}
```

---

## LogCategory

```csharp
public enum LogCategory : byte
{
    All,
    Bench,
    BlockStorage,
    CoinDb,
    LevelDb,
    Mempool,
    Prune,
    Rand,
    Reindex,
    Validation,
    Kernel
}
```

---

## Warning

```csharp
public enum Warning
{
    UnknownNewRulesActivated,
    LargeWorkInvalidChain
}
```

---

## Exception Hierarchy

```text
KernelException
|- KernelContextException
|- ScriptVerificationException
|- BlockValidationException
|- ChainstateManagerException
|- LoggingException
|- ChainParametersException
|- KernelFatalException
|- KernelFlushException
|- TransactionException
`- BlockException
```

### ScriptVerificationException

`ScriptVerificationException` exposes a `Status` property of type `ScriptVerifyStatus`.

### BlockValidationException

`BlockValidationException` exposes:

| Property | Type |
|:---------|:-----|
| `Result` | `BlockValidationResult` |
| `Mode` | `ValidationMode` |
