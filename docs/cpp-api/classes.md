---
title: Classes
---


# C++ Wrapper — Classes

---

## Script & Transaction Types

### ScriptPubkey / ScriptPubkeyView

```cpp
class ScriptPubkey : public Handle<btck_ScriptPubkey,
                                   btck_script_pubkey_copy,
                                   btck_script_pubkey_destroy>,
                     public ScriptPubkeyApi<ScriptPubkey>;

class ScriptPubkeyView : public View<btck_ScriptPubkey>,
                         public ScriptPubkeyApi<ScriptPubkeyView>;
```

**Construction:**

```cpp
// Owned — from raw bytes
btck::ScriptPubkey spk{std::span<const std::byte>{script_bytes}};

// View — from btck_TransactionOutput (non-owning)
btck::ScriptPubkeyView spk_view = output.GetScriptPubkey();
```

**Methods (via `ScriptPubkeyApi`):**

| Method | Signature | Description |
|:-------|:----------|:------------|
| `Verify` | `bool Verify(int64_t amount, const Transaction& tx_to, std::span<const TransactionOutput> spent_outputs, unsigned int input_index, ScriptVerificationFlags flags, ScriptVerifyStatus& status) const` | Verify a spending transaction input. |
| `ToBytes` | `std::vector<std::byte> ToBytes() const` | Serialize the script. |

---

### TransactionOutput / TransactionOutputView

```cpp
class TransactionOutput : public Handle<btck_TransactionOutput,
                                        btck_transaction_output_copy,
                                        btck_transaction_output_destroy>,
                          public TransactionOutputApi<TransactionOutput>;
```

**Construction:**

```cpp
btck::TransactionOutput out{script_pubkey, amount_satoshis};
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `Amount()` | `int64_t` | Amount in satoshis. |
| `GetScriptPubkey()` | `ScriptPubkeyView` | Non-owning view of the script. |

---

### TransactionInput / TransactionInputView

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `OutPoint()` | `OutPointView` | The outpoint this input spends. |

---

### OutPoint / OutPointView

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `index()` | `uint32_t` | Output index (vout). |
| `Txid()` | `TxidView` | The transaction ID. |

---

### Transaction / TransactionView

```cpp
class Transaction : public Handle<btck_Transaction,
                                   btck_transaction_copy,
                                   btck_transaction_destroy>,
                    public TransactionApi<Transaction>;
```

**Construction:**

```cpp
btck::Transaction tx{std::span<const std::byte>{raw_tx}};
```

**Methods (via `TransactionApi`):**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `CountOutputs()` | `size_t` | Number of outputs. |
| `CountInputs()` | `size_t` | Number of inputs. |
| `GetOutput(i)` | `TransactionOutputView` | Output at index `i` (non-owning). |
| `GetInput(i)` | `TransactionInputView` | Input at index `i` (non-owning). |
| `Txid()` | `TxidView` | Transaction ID (non-owning). |
| `Outputs()` | range | Range over all outputs. |
| `Inputs()` | range | Range over all inputs. |
| `ToBytes()` | `std::vector<std::byte>` | Consensus serialization. |

**Range example:**

```cpp
btck::Transaction tx{raw_tx_span};
for (auto output : tx.Outputs()) {
    std::cout << output.Amount() << " sat\n";
}
```

---

### Txid / TxidView

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `ToBytes()` | `std::array<std::byte, 32>` | Raw 32-byte txid. |
| `operator==` / `operator!=` | `bool` | Equality comparison. |

---

## Block Types

### Block

```cpp
class Block : public Handle<btck_Block, btck_block_copy, btck_block_destroy>;
```

**Construction:**

```cpp
// From raw bytes
btck::Block blk{std::span<const std::byte>{raw_block}};

// From disk (via ChainMan)
auto blk = chain_man.ReadBlock(entry);  // returns std::optional<Block>
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `CountTransactions()` | `size_t` | Number of transactions. |
| `GetTransaction(i)` | `TransactionView` | Transaction at index (non-owning). |
| `GetHash()` | `BlockHash` | Owned block hash. |
| `GetHeader()` (via `GetHeader()` from tree entry) | `BlockHeader` | Owned block header. |
| `Transactions()` | range | Iterate all transactions. |
| `ToBytes()` | `std::vector<std::byte>` | Consensus serialization. |
| `Check(params, flags, state)` | `bool` | Context-free validation. |

---

### BlockHeader

```cpp
class BlockHeader : public Handle<btck_BlockHeader,
                                   btck_block_header_copy,
                                   btck_block_header_destroy>;
```

**Construction:**

```cpp
btck::BlockHeader hdr{std::span<const std::byte>{raw_header_80_bytes}};
// or from block tree entry:
btck::BlockHeader hdr = entry.GetHeader();
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetHash()` | `BlockHash` | Owned hash of this header. |
| `GetPrevHash()` | `BlockHashView` | Non-owned previous block hash. |
| `GetTimestamp()` | `uint32_t` | Unix timestamp. |
| `GetBits()` | `uint32_t` | Compact difficulty target. |
| `GetVersion()` | `int32_t` | Block version. |
| `GetNonce()` | `uint32_t` | Proof-of-work nonce. |

---

### BlockHash / BlockHashView

**Construction:**

```cpp
std::array<std::byte, 32> hash_bytes = /* ... */;
btck::BlockHash bh{hash_bytes};
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `ToBytes()` | `std::array<std::byte, 32>` | Raw hash. |
| `operator==` / `operator!=` | `bool` | Equality. |

---

### BlockValidationState / BlockValidationStateView

```cpp
class BlockValidationState : public Handle<btck_BlockValidationState,
                                            btck_block_validation_state_copy,
                                            btck_block_validation_state_destroy>,
                             public BlockValidationStateApi<BlockValidationState>;
```

**Construction:**

```cpp
btck::BlockValidationState state{};  // default constructor
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetValidationMode()` | `ValidationMode` | `VALID`, `INVALID`, or `INTERNAL_ERROR`. |
| `GetBlockValidationResult()` | `BlockValidationResult` | Granular rejection reason. |

---

### BlockTreeEntry

```cpp
class BlockTreeEntry : public View<btck_BlockTreeEntry>;
```

Non-owning view into the block index. Valid for the lifetime of the `ChainMan`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetPrevious()` | `std::optional<BlockTreeEntry>` | Parent entry, or `nullopt` for genesis. |
| `GetHeight()` | `int32_t` | Block height. |
| `GetHash()` | `BlockHashView` | Non-owned block hash. |
| `GetHeader()` | `BlockHeader` | Owned block header. |

---

## Chain Types

### ChainView

```cpp
class ChainView : public View<btck_Chain>;
```

Non-owning view of the active best chain. Retrieved from `ChainMan::GetChain()`.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `Height()` | `int32_t` | Tip height. |
| `CountEntries()` | `int` | `Height() + 1`. |
| `GetByHeight(h)` | `BlockTreeEntry` | Entry at height `h`. Throws if out of range. |
| `Contains(entry)` | `bool` | Check if entry is in this chain. |
| `Entries()` | range | Iterate from genesis to tip. |

```cpp
for (auto entry : chain.Entries()) {
    std::cout << entry.GetHeight() << " : "
              << hex(entry.GetHash().ToBytes()) << "\n";
}
```

---

### ChainMan

```cpp
class ChainMan : UniqueHandle<btck_ChainstateManager, btck_chainstate_manager_destroy>;
```

The central chainstate management object. Move-only.

**Construction:**

```cpp
btck::ChainParams params{btck::ChainType::MAINNET};
btck::ContextOptions opts{};
opts.SetChainParams(params);
opts.SetNotifications(std::make_shared<MyNotifications>());

btck::Context ctx{opts};
btck::ChainstateManagerOptions chainman_opts{ctx, data_dir, blocks_dir};
btck::ChainMan chain_man{ctx, chainman_opts};
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `ImportBlocks(paths)` | `bool` | Import block files from disk paths. |
| `ProcessBlock(block, new_block)` | `bool` | Validate and process a block. |
| `ProcessBlockHeader(header, state)` | `bool` | Validate a block header. |
| `GetChain()` | `ChainView` | Active best chain (non-owning). |
| `GetBlockTreeEntry(hash)` | `std::optional<BlockTreeEntry>` | Look up entry by block hash. |
| `GetBestEntry()` | `BlockTreeEntry` | Entry with most cumulative work. |
| `ReadBlock(entry)` | `std::optional<Block>` | Read block from disk. |
| `ReadBlockSpentOutputs(entry)` | `BlockSpentOutputs` | Read undo data from disk. |

---

### ChainParams

```cpp
class ChainParams : public Handle<btck_ChainParameters,
                                   btck_chain_parameters_copy,
                                   btck_chain_parameters_destroy>;
```

**Construction:**

```cpp
btck::ChainParams params{btck::ChainType::MAINNET};
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetConsensusParams()` | `ConsensusParamsView` | Non-owned consensus parameters. |

---

## Context Types

### ContextOptions

```cpp
class ContextOptions : public UniqueHandle<btck_ContextOptions, btck_context_options_destroy>;
```

**Construction:**

```cpp
btck::ContextOptions opts{};
```

**Methods:**

| Method | Description |
|:-------|:------------|
| `SetChainParams(ChainParams&)` | Choose network. Default: mainnet. |
| `SetNotifications(shared_ptr<T>)` | Register `KernelNotifications` subclass. |
| `SetValidationInterface(shared_ptr<T>)` | Register `ValidationInterface` subclass. |

---

### Context

```cpp
class Context : public Handle<btck_Context, btck_context_copy, btck_context_destroy>;
```

**Construction:**

```cpp
btck::Context ctx{opts};       // with options
btck::Context ctx{};           // default (mainnet, no callbacks)
```

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `interrupt()` | `bool` | Signal long-running operations to halt. |

---

### ChainstateManagerOptions

```cpp
class ChainstateManagerOptions : public UniqueHandle<btck_ChainstateManagerOptions,
                                                      btck_chainstate_manager_options_destroy>;
```

**Construction:**

```cpp
btck::ChainstateManagerOptions opts{ctx, "/path/to/data", "/path/to/blocks"};
```

**Methods:**

| Method | Description |
|:-------|:------------|
| `SetWorkerThreads(int)` | Parallel script-verification threads (0–15). |
| `SetWipeDbs(bool, bool)` | Enable block tree / chainstate db wipe on next import. |
| `UpdateBlockTreeDbInMemory(bool)` | Use in-memory block tree DB. |
| `UpdateChainstateDbInMemory(bool)` | Use in-memory chainstate (UTXO) DB. |

---

## Notifications & Events

### KernelNotifications

```cpp
class KernelNotifications {
public:
    virtual ~KernelNotifications() = default;
    virtual void BlockTipHandler(SynchronizationState, BlockTreeEntry, double progress) {}
    virtual void HeaderTipHandler(SynchronizationState, int64_t height,
                                   int64_t timestamp, bool presync) {}
    virtual void ProgressHandler(std::string_view title, int percent, bool resumable) {}
    virtual void WarningSetHandler(Warning, std::string_view message) {}
    virtual void WarningUnsetHandler(Warning) {}
    virtual void FlushErrorHandler(std::string_view error) {}
    virtual void FatalErrorHandler(std::string_view error) {}
};
```

Subclass and override the methods you need. Pass a `shared_ptr` to `ContextOptions::SetNotifications()`.

```cpp
class MyNotifications : public btck::KernelNotifications {
public:
    void BlockTipHandler(btck::SynchronizationState state,
                         btck::BlockTreeEntry entry,
                         double progress) override {
        std::cout << "New tip height: " << entry.GetHeight()
                  << " (" << (progress * 100) << "%)\n";
    }
    void FatalErrorHandler(std::string_view error) override {
        std::cerr << "FATAL: " << error << "\n";
        std::exit(1);
    }
};

opts.SetNotifications(std::make_shared<MyNotifications>());
```

---

### ValidationInterface

```cpp
class ValidationInterface {
public:
    virtual ~ValidationInterface() = default;
    virtual void BlockChecked(Block block, BlockValidationStateView state) {}
    virtual void PowValidBlock(BlockTreeEntry entry, Block block) {}
    virtual void BlockConnected(Block block, BlockTreeEntry entry) {}
    virtual void BlockDisconnected(Block block, BlockTreeEntry entry) {}
};
```

Subclass and pass to `ContextOptions::SetValidationInterface()`.

!!! warning
    These callbacks **block** further validation execution while running. Keep them short.

---

### Logger

```cpp
template <Log T>
class Logger : UniqueHandle<btck_LoggingConnection, btck_logging_connection_destroy>;
```

`T` must satisfy the `Log` concept: `void T::LogMessage(std::string_view)`.

```cpp
struct StdoutLog {
    void LogMessage(std::string_view msg) {
        std::cout << msg;
    }
};

btck::Logger<StdoutLog> logger{std::make_unique<StdoutLog>()};
```

**Free logging functions:**

```cpp
btck::logging_disable();
btck::logging_set_options(options);
btck::logging_set_level_category(LogCategory::VALIDATION, LogLevel::DEBUG_LEVEL);
btck::logging_enable_category(LogCategory::ALL);
btck::logging_disable_category(LogCategory::LEVELDB);
```

---

## Spent Outputs

### BlockSpentOutputs

```cpp
class BlockSpentOutputs : public Handle<btck_BlockSpentOutputs,
                                         btck_block_spent_outputs_copy,
                                         btck_block_spent_outputs_destroy>;
```

| Method | Returns | Description |
|:-------|:--------|:------------|
| `Count()` | `size_t` | Number of non-coinbase transactions. |
| `GetTxSpentOutputs(i)` | `TransactionSpentOutputsView` | Spent outputs for tx at index `i`. |
| `TxsSpentOutputs()` | range | Iterate all transaction spent outputs. |

---

### TransactionSpentOutputs / TransactionSpentOutputsView

| Method | Returns | Description |
|:-------|:--------|:------------|
| `Count()` | `size_t` | Number of spent coins (= number of inputs). |
| `GetCoin(i)` | `CoinView` | Coin at index `i`. |
| `Coins()` | range | Iterate all coins. |

---

### Coin / CoinView

| Method | Returns | Description |
|:-------|:--------|:------------|
| `GetConfirmationHeight()` | `uint32_t` | Block height the coin was created in. |
| `IsCoinbase()` | `bool` | Whether from a coinbase transaction. |
| `GetOutput()` | `TransactionOutputView` | The unspent output. |
