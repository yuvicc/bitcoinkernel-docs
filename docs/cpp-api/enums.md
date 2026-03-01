---
title: Enums
---


# C++ Wrapper — Enums

All enums are strongly-typed `enum class` values in `namespace btck`, wrapping their C counterparts.

---

## LogCategory

```cpp
enum class LogCategory : btck_LogCategory {
    ALL, BENCH, BLOCKSTORAGE, COINDB, LEVELDB,
    MEMPOOL, PRUNE, RAND, REINDEX, VALIDATION, KERNEL
};
```

Used with `logging_enable_category()`, `logging_disable_category()`, `logging_set_level_category()`.

---

## LogLevel

```cpp
enum class LogLevel : btck_LogLevel {
    TRACE_LEVEL, DEBUG_LEVEL, INFO_LEVEL
};
```

---

## ChainType

```cpp
enum class ChainType : btck_ChainType {
    MAINNET, TESTNET, TESTNET_4, SIGNET, REGTEST
};
```

Passed to `ChainParams` constructor.

---

## SynchronizationState

```cpp
enum class SynchronizationState : btck_SynchronizationState {
    INIT_REINDEX, INIT_DOWNLOAD, POST_INIT
};
```

Passed to `KernelNotifications::BlockTipHandler()` and `HeaderTipHandler()`.

---

## Warning

```cpp
enum class Warning : btck_Warning {
    UNKNOWN_NEW_RULES_ACTIVATED,
    LARGE_WORK_INVALID_CHAIN
};
```

Passed to `KernelNotifications::WarningSetHandler()` / `WarningUnsetHandler()`.

---

## ValidationMode

```cpp
enum class ValidationMode : btck_ValidationMode {
    VALID, INVALID, INTERNAL_ERROR
};
```

Retrieved via `BlockValidationState::GetValidationMode()` or `BlockValidationStateView::GetValidationMode()`.

---

## BlockValidationResult

```cpp
enum class BlockValidationResult : btck_BlockValidationResult {
    UNSET, CONSENSUS, CACHED_INVALID, INVALID_HEADER,
    MUTATED, MISSING_PREV, INVALID_PREV, TIME_FUTURE, HEADER_LOW_WORK
};
```

Retrieved via `BlockValidationState::GetBlockValidationResult()`.

---

## ScriptVerifyStatus

```cpp
enum class ScriptVerifyStatus : btck_ScriptVerifyStatus {
    OK,
    ERROR_INVALID_FLAGS_COMBINATION,
    ERROR_SPENT_OUTPUTS_REQUIRED
};
```

Written to the `status` out-parameter of `ScriptPubkeyApi::Verify()`.

---

## ScriptVerificationFlags

```cpp
enum class ScriptVerificationFlags : btck_ScriptVerificationFlags {
    NONE, P2SH, DERSIG, NULLDUMMY,
    CHECKLOCKTIMEVERIFY, CHECKSEQUENCEVERIFY,
    WITNESS, TAPROOT, ALL
};
```

Bitmask enum — supports `|`, `&`, `^`, `~`, `|=`, `&=`, `^=`.

```cpp
auto flags = btck::ScriptVerificationFlags::P2SH
           | btck::ScriptVerificationFlags::WITNESS
           | btck::ScriptVerificationFlags::TAPROOT;
```

---

## BlockCheckFlags

```cpp
enum class BlockCheckFlags : btck_BlockCheckFlags {
    BASE, POW, MERKLE, ALL
};
```

Bitmask enum for `Block::Check()`. `POW` enables proof-of-work checking; `MERKLE` enables merkle root verification.
