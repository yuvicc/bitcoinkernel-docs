---
title: Types
---


# C API — Types

---

## Opaque Handle Types

All kernel objects are exposed as opaque `typedef struct` handles. The internal layout is hidden; use the provided API functions to interact with them.

### btck_Transaction

```c
typedef struct btck_Transaction btck_Transaction;
```

Holds a deserialized Bitcoin transaction. Reference-counted; use `btck_transaction_copy()` to share ownership and `btck_transaction_destroy()` to release.

---

### btck_ScriptPubkey

```c
typedef struct btck_ScriptPubkey btck_ScriptPubkey;
```

Holds a serialized output script (locking script). Used as the target for `btck_script_pubkey_verify()`.

---

### btck_TransactionOutput

```c
typedef struct btck_TransactionOutput btck_TransactionOutput;
```

Holds a transaction output: an amount (satoshis) and a `btck_ScriptPubkey`.

---

### btck_TransactionInput

```c
typedef struct btck_TransactionInput btck_TransactionInput;
```

Holds a transaction input. Provides access to the `btck_TransactionOutPoint` it spends.

---

### btck_TransactionOutPoint

```c
typedef struct btck_TransactionOutPoint btck_TransactionOutPoint;
```

Identifies a specific output: a `btck_Txid` and a 32-bit output index.

---

### btck_Txid

```c
typedef struct btck_Txid btck_Txid;
```

A type-safe 32-byte transaction identifier.

---

### btck_Block

```c
typedef struct btck_Block btck_Block;
```

Holds a complete deserialized block including all transactions. Reference-counted.

---

### btck_BlockHeader

```c
typedef struct btck_BlockHeader btck_BlockHeader;
```

Holds an 80-byte block header (version, prev hash, merkle root, time, bits, nonce).

---

### btck_BlockHash

```c
typedef struct btck_BlockHash btck_BlockHash;
```

A type-safe 32-byte block hash.

---

### btck_BlockValidationState

```c
typedef struct btck_BlockValidationState btck_BlockValidationState;
```

Holds the result of block validation: a `btck_ValidationMode` and a `btck_BlockValidationResult`.

---

### btck_BlockTreeEntry

```c
typedef struct btck_BlockTreeEntry btck_BlockTreeEntry;
```

A pointer into the in-memory block index. Valid for the lifetime of the `btck_ChainstateManager` it was retrieved from. Every entry (except genesis) has a single parent, forming a tree. Multiple entries may share a parent.

---

### btck_Chain

```c
typedef struct btck_Chain btck_Chain;
```

A view of the currently active best chain — conceptually a vector of `btck_BlockTreeEntry` from genesis to tip. The contents update as new blocks are processed.

---

### btck_ChainstateManager

```c
typedef struct btck_ChainstateManager btck_ChainstateManager;
```

The central validation object. Manages the UTXO set, block index, and block storage. Process blocks, import files, read chain data, and look up block tree entries through this object.

---

### btck_ChainstateManagerOptions

```c
typedef struct btck_ChainstateManagerOptions btck_ChainstateManagerOptions;
```

Configuration for creating a `btck_ChainstateManager`: data directory, blocks directory, worker thread count, wipe flags, and in-memory DB flags.

---

### btck_ChainParameters

```c
typedef struct btck_ChainParameters btck_ChainParameters;
```

Holds chain-specific consensus parameters (mainnet, testnet, signet, regtest). Passed to `btck_ContextOptions` before context creation.

---

### btck_ConsensusParams

```c
typedef struct btck_ConsensusParams btck_ConsensusParams;
```

Opaque consensus parameters retrieved from `btck_ChainParameters`. Used for context-free block validation via `btck_block_check()`.

---

### btck_ContextOptions

```c
typedef struct btck_ContextOptions btck_ContextOptions;
```

Builder object for a `btck_Context`. Configure chain parameters, notification callbacks, and validation interface before calling `btck_context_create()`.

---

### btck_Context

```c
typedef struct btck_Context btck_Context;
```

The kernel context. Holds chain parameters, callback registrations, and an internal task runner for delivering validation events. Thread-safe for concurrent use. Required for chainstate manager creation.

---

### btck_LoggingConnection

```c
typedef struct btck_LoggingConnection btck_LoggingConnection;
```

An active connection to the global internal logger. Messages logged before the first connection is created are buffered (up to 1 MB). Destroying the connection stops log delivery.

---

### btck_BlockSpentOutputs

```c
typedef struct btck_BlockSpentOutputs btck_BlockSpentOutputs;
```

The undo data for a block: all previous outputs consumed by every non-coinbase transaction. Organised as a nested structure: one `btck_TransactionSpentOutputs` per transaction, each containing the coins spent by that transaction's inputs.

---

### btck_TransactionSpentOutputs

```c
typedef struct btck_TransactionSpentOutputs btck_TransactionSpentOutputs;
```

The previous outputs consumed by a single transaction. Retrieved from `btck_BlockSpentOutputs`. Contains one `btck_Coin` per input.

---

### btck_Coin

```c
typedef struct btck_Coin btck_Coin;
```

A UTXO entry: the `btck_TransactionOutput` it holds, the confirmation height, and a coinbase flag.

---

### btck_PrecomputedTransactionData

```c
typedef struct btck_PrecomputedTransactionData btck_PrecomputedTransactionData;
```

Cached transaction hashes for script verification. Must be created (with spent outputs) when verifying Taproot inputs. Reusable across multiple inputs of the same transaction.

---

## Enum Types

### btck_ChainType

```c
typedef uint8_t btck_ChainType;
#define btck_ChainType_MAINNET  ((btck_ChainType)(0))
#define btck_ChainType_TESTNET  ((btck_ChainType)(1))
#define btck_ChainType_TESTNET_4 ((btck_ChainType)(2))
#define btck_ChainType_SIGNET   ((btck_ChainType)(3))
#define btck_ChainType_REGTEST  ((btck_ChainType)(4))
```

Selects the Bitcoin network for `btck_chain_parameters_create()`.

---

### btck_SynchronizationState

```c
typedef uint8_t btck_SynchronizationState;
#define btck_SynchronizationState_INIT_REINDEX  ((btck_SynchronizationState)(0))
#define btck_SynchronizationState_INIT_DOWNLOAD ((btck_SynchronizationState)(1))
#define btck_SynchronizationState_POST_INIT     ((btck_SynchronizationState)(2))
```

Current sync state delivered to `btck_NotifyBlockTip` and `btck_NotifyHeaderTip` callbacks.

---

### btck_Warning

```c
typedef uint8_t btck_Warning;
#define btck_Warning_UNKNOWN_NEW_RULES_ACTIVATED ((btck_Warning)(0))
#define btck_Warning_LARGE_WORK_INVALID_CHAIN    ((btck_Warning)(1))
```

Warning type delivered to `btck_NotifyWarningSet` / `btck_NotifyWarningUnset` callbacks.

---

### btck_ValidationMode

```c
typedef uint8_t btck_ValidationMode;
#define btck_ValidationMode_VALID          ((btck_ValidationMode)(0))
#define btck_ValidationMode_INVALID        ((btck_ValidationMode)(1))
#define btck_ValidationMode_INTERNAL_ERROR ((btck_ValidationMode)(2))
```

Top-level result of block validation stored in `btck_BlockValidationState`.

---

### btck_BlockValidationResult

```c
typedef uint32_t btck_BlockValidationResult;
#define btck_BlockValidationResult_UNSET         (0)  // Not yet rejected
#define btck_BlockValidationResult_CONSENSUS     (1)  // Invalid by consensus rules
#define btck_BlockValidationResult_CACHED_INVALID (2) // Cached invalid (reason lost)
#define btck_BlockValidationResult_INVALID_HEADER (3) // Bad PoW or timestamp too old
#define btck_BlockValidationResult_MUTATED       (4)  // Data doesn't match PoW commitment
#define btck_BlockValidationResult_MISSING_PREV  (5)  // Previous block unknown
#define btck_BlockValidationResult_INVALID_PREV  (6)  // Previous block invalid
#define btck_BlockValidationResult_TIME_FUTURE   (7)  // Timestamp > 2 hours in the future
#define btck_BlockValidationResult_HEADER_LOW_WORK (8) // Header chain has too little work
```

Granular rejection reason stored in `btck_BlockValidationState`.

---

### btck_ScriptVerifyStatus

```c
typedef uint8_t btck_ScriptVerifyStatus;
#define btck_ScriptVerifyStatus_OK                          ((btck_ScriptVerifyStatus)(0))
#define btck_ScriptVerifyStatus_ERROR_INVALID_FLAGS_COMBINATION ((btck_ScriptVerifyStatus)(1))
#define btck_ScriptVerifyStatus_ERROR_SPENT_OUTPUTS_REQUIRED    ((btck_ScriptVerifyStatus)(2))
```

Written to the optional `status` out-parameter of `btck_script_pubkey_verify()`.

| Value | Meaning |
|:------|:--------|
| `OK` | Verification ran without errors (script may still be invalid). |
| `ERROR_INVALID_FLAGS_COMBINATION` | The flags bitfield contains an invalid combination. |
| `ERROR_SPENT_OUTPUTS_REQUIRED` | `TAPROOT` flag set but `precomputed_txdata` is null. |

---

### btck_ScriptVerificationFlags

```c
typedef uint32_t btck_ScriptVerificationFlags;
#define btck_ScriptVerificationFlags_NONE              (0)
#define btck_ScriptVerificationFlags_P2SH              (1U << 0)   // BIP16
#define btck_ScriptVerificationFlags_DERSIG            (1U << 2)   // BIP66
#define btck_ScriptVerificationFlags_NULLDUMMY         (1U << 4)   // BIP147
#define btck_ScriptVerificationFlags_CHECKLOCKTIMEVERIFY (1U << 9) // BIP65
#define btck_ScriptVerificationFlags_CHECKSEQUENCEVERIFY (1U << 10)// BIP112
#define btck_ScriptVerificationFlags_WITNESS           (1U << 11)  // BIP141
#define btck_ScriptVerificationFlags_TAPROOT           (1U << 17)  // BIPs 341 & 342
#define btck_ScriptVerificationFlags_ALL               (/* all above combined */)
```

Bitmask controlling which consensus rules are enforced during script verification. Combine with `|`. Use `ALL` for standard mainnet rules.

When `TAPROOT` is set, `precomputed_txdata` **must** be provided to `btck_script_pubkey_verify()` with all spent outputs pre-loaded.

---

### btck_BlockCheckFlags

```c
typedef uint32_t btck_BlockCheckFlags;
#define btck_BlockCheckFlags_BASE   (0)
#define btck_BlockCheckFlags_POW    (1U << 0)  // Check proof-of-work
#define btck_BlockCheckFlags_MERKLE (1U << 1)  // Verify merkle root
#define btck_BlockCheckFlags_ALL    (POW | MERKLE)
```

Controls which context-free checks run in `btck_block_check()`.

---

### btck_LogCategory

```c
typedef uint8_t btck_LogCategory;
#define btck_LogCategory_ALL         (0)
#define btck_LogCategory_BENCH       (1)
#define btck_LogCategory_BLOCKSTORAGE (2)
#define btck_LogCategory_COINDB      (3)
#define btck_LogCategory_LEVELDB     (4)
#define btck_LogCategory_MEMPOOL     (5)
#define btck_LogCategory_PRUNE       (6)
#define btck_LogCategory_RAND        (7)
#define btck_LogCategory_REINDEX     (8)
#define btck_LogCategory_VALIDATION  (9)
#define btck_LogCategory_KERNEL      (10)
```

Log categories for enabling/disabling specific subsystem output.

---

### btck_LogLevel

```c
typedef uint8_t btck_LogLevel;
#define btck_LogLevel_TRACE (0)
#define btck_LogLevel_DEBUG (1)
#define btck_LogLevel_INFO  (2)
```

Minimum severity for log output. Default is `INFO`.

---

## Non-Opaque Structs

### btck_LoggingOptions

```c
typedef struct {
    int log_timestamps;               // Prepend timestamp to messages
    int log_time_micros;              // Microsecond timestamp precision
    int log_threadnames;              // Prepend thread name
    int log_sourcelocations;          // Prepend source file:line
    int always_print_category_levels; // Prepend category and level
} btck_LoggingOptions;
```

Passed to `btck_logging_set_options()` to configure log message formatting. Set fields to non-zero for true.

---

### btck_NotificationInterfaceCallbacks

```c
typedef struct {
    void*                  user_data;
    btck_DestroyCallback   user_data_destroy;
    btck_NotifyBlockTip    block_tip;
    btck_NotifyHeaderTip   header_tip;
    btck_NotifyProgress    progress;
    btck_NotifyWarningSet  warning_set;
    btck_NotifyWarningUnset warning_unset;
    btck_NotifyFlushError  flush_error;
    btck_NotifyFatalError  fatal_error;
} btck_NotificationInterfaceCallbacks;
```

Callbacks for kernel lifecycle events. Set on `btck_ContextOptions` before context creation.

| Field | Description |
|:------|:------------|
| `user_data` | Opaque pointer passed to every callback. |
| `user_data_destroy` | Called to free `user_data` when the context is destroyed (optional). |
| `block_tip` | Chain tip updated to a new block. |
| `header_tip` | New best block header added. |
| `progress` | Block synchronization progress report. |
| `warning_set` | A new warning condition is active. |
| `warning_unset` | A previous warning condition has cleared. |
| `flush_error` | Error writing to disk. Consider halting. |
| `fatal_error` | Unrecoverable error. Tear down all kernel objects. |

`flush_error` and `fatal_error` indicate system-level failures. When received, halt operations and tear down kernel objects. Remediation may require user intervention.

---

### btck_ValidationInterfaceCallbacks

```c
typedef struct {
    void*                                   user_data;
    btck_DestroyCallback                    user_data_destroy;
    btck_ValidationInterfaceBlockChecked    block_checked;
    btck_ValidationInterfacePoWValidBlock   pow_valid_block;
    btck_ValidationInterfaceBlockConnected  block_connected;
    btck_ValidationInterfaceBlockDisconnected block_disconnected;
} btck_ValidationInterfaceCallbacks;
```

Callbacks for block validation events. These block further validation while executing.

| Field | Description |
|:------|:------------|
| `block_checked` | A block has completed validation. Contains the `btck_BlockValidationState` result. |
| `pow_valid_block` | A block extends the header chain and has a valid tx & segwit merkle root. |
| `block_connected` | A valid block has been appended to the best chain. |
| `block_disconnected` | During reorg, a block has been removed from the best chain. |

---

## Callback Typedefs

```c
typedef void (*btck_LogCallback)(void* user_data, const char* message, size_t message_len);
typedef void (*btck_DestroyCallback)(void* user_data);

typedef void (*btck_NotifyBlockTip)(void* user_data, btck_SynchronizationState state,
                                    const btck_BlockTreeEntry* entry,
                                    double verification_progress);
typedef void (*btck_NotifyHeaderTip)(void* user_data, btck_SynchronizationState state,
                                     int64_t height, int64_t timestamp, int presync);
typedef void (*btck_NotifyProgress)(void* user_data, const char* title, size_t title_len,
                                    int progress_percent, int resume_possible);
typedef void (*btck_NotifyWarningSet)(void* user_data, btck_Warning warning,
                                      const char* message, size_t message_len);
typedef void (*btck_NotifyWarningUnset)(void* user_data, btck_Warning warning);
typedef void (*btck_NotifyFlushError)(void* user_data, const char* message, size_t message_len);
typedef void (*btck_NotifyFatalError)(void* user_data, const char* message, size_t message_len);

typedef void (*btck_ValidationInterfaceBlockChecked)(void* user_data, btck_Block* block,
                                                     const btck_BlockValidationState* state);
typedef void (*btck_ValidationInterfacePoWValidBlock)(void* user_data, btck_Block* block,
                                                      const btck_BlockTreeEntry* entry);
typedef void (*btck_ValidationInterfaceBlockConnected)(void* user_data, btck_Block* block,
                                                       const btck_BlockTreeEntry* entry);
typedef void (*btck_ValidationInterfaceBlockDisconnected)(void* user_data, btck_Block* block,
                                                          const btck_BlockTreeEntry* entry);

typedef int (*btck_WriteBytes)(const void* bytes, size_t size, void* userdata);
```

The `btck_WriteBytes` callback is used with serialization functions (`btck_block_to_bytes`, `btck_transaction_to_bytes`, etc.). Return `0` on success, non-zero on error.
