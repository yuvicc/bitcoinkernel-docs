---
title: Functions
---


# C API — Functions

---

## Logging

### btck_logging_disable

```c
void btck_logging_disable(void);
```

Permanently disables the global internal logger and clears the buffer. Call at most once, before any logging connection is created. Not thread-safe.

---

### btck_logging_set_options

```c
void btck_logging_set_options(btck_LoggingOptions options);
```

Sets global log-message format options. Applies to all existing and future `btck_LoggingConnection` instances.

---

### btck_logging_set_level_category

```c
void btck_logging_set_level_category(btck_LogCategory category, btck_LogLevel level);
```

Sets the minimum log level for a specific category. If `category` is `btck_LogCategory_ALL`, sets the global fallback level used by all categories that don't have a specific level.

---

### btck_logging_enable_category

```c
void btck_logging_enable_category(btck_LogCategory category);
```

Enables a log category. Pass `btck_LogCategory_ALL` to enable all categories.

---

### btck_logging_disable_category

```c
void btck_logging_disable_category(btck_LogCategory category);
```

Disables a log category. Pass `btck_LogCategory_ALL` to disable all categories.

---

### btck_logging_connection_create

```c
btck_LoggingConnection* btck_logging_connection_create(
    btck_LogCallback log_callback,
    void* user_data,
    btck_DestroyCallback user_data_destroy_callback);
```

Starts delivering log messages through `log_callback`. Messages buffered before this call are flushed immediately. Returns `NULL` on error.

| Parameter | Description |
|:----------|:------------|
| `log_callback` | Non-null. Called for every log message. |
| `user_data` | Nullable opaque pointer passed back to the callback. |
| `user_data_destroy_callback` | Nullable. If provided, called to free `user_data` when the connection is destroyed. |

---

### btck_logging_connection_destroy

```c
void btck_logging_connection_destroy(btck_LoggingConnection* logging_connection);
```

Stops log delivery and destroys the connection.

---

## ChainParameters

### btck_chain_parameters_create

```c
btck_ChainParameters* btck_chain_parameters_create(btck_ChainType chain_type);
```

Allocates chain parameters for the given network. Returns `NULL` on error.

---

### btck_chain_parameters_copy

```c
btck_ChainParameters* btck_chain_parameters_copy(const btck_ChainParameters* chain_parameters);
```

Copies chain parameters.

---

### btck_chain_parameters_get_consensus_params

```c
const btck_ConsensusParams* btck_chain_parameters_get_consensus_params(
    const btck_ChainParameters* chain_parameters);
```

Returns a non-owned pointer to the consensus parameters. Valid for the lifetime of `chain_parameters`.

---

### btck_chain_parameters_destroy

```c
void btck_chain_parameters_destroy(btck_ChainParameters* chain_parameters);
```

---

## ContextOptions

### btck_context_options_create

```c
btck_ContextOptions* btck_context_options_create(void);
```

Creates an empty options object. Default: mainnet, no callbacks.

---

### btck_context_options_set_chainparams

```c
void btck_context_options_set_chainparams(
    btck_ContextOptions* context_options,
    const btck_ChainParameters* chain_parameters);
```

Attaches chain parameters to the options.

---

### btck_context_options_set_notifications

```c
void btck_context_options_set_notifications(
    btck_ContextOptions* context_options,
    btck_NotificationInterfaceCallbacks notifications);
```

Registers kernel notification callbacks. The `user_data` lifetime is managed by the context if `user_data_destroy` is set.

---

### btck_context_options_set_validation_interface

```c
void btck_context_options_set_validation_interface(
    btck_ContextOptions* context_options,
    btck_ValidationInterfaceCallbacks validation_interface_callbacks);
```

Registers validation event callbacks.

---

### btck_context_options_destroy

```c
void btck_context_options_destroy(btck_ContextOptions* context_options);
```

---

## Context

### btck_context_create

```c
btck_Context* btck_context_create(const btck_ContextOptions* context_options);
```

Creates a new kernel context. `context_options` may be `NULL` for defaults (mainnet, no callbacks). Returns `NULL` on error. Thread-safe once created.

---

### btck_context_copy

```c
btck_Context* btck_context_copy(const btck_Context* context);
```

Copies the context (increments reference count).

---

### btck_context_interrupt

```c
int btck_context_interrupt(btck_Context* context);
```

Signals long-running operations (reindex, import, block processing) to halt. Returns `0` on success.

---

### btck_context_destroy

```c
void btck_context_destroy(btck_Context* context);
```

---

## ChainstateManagerOptions

### btck_chainstate_manager_options_create

```c
btck_ChainstateManagerOptions* btck_chainstate_manager_options_create(
    const btck_Context* context,
    const char* data_directory, size_t data_directory_len,
    const char* blocks_directory, size_t blocks_directory_len);
```

Creates chainstate manager options. Directories are created if they don't exist. Returns `NULL` on error.

| Parameter | Description |
|:----------|:------------|
| `context` | Non-null. The context this manager will be associated with. |
| `data_directory` | Path for chainstate data (e.g. `~/.bitcoin/`). |
| `blocks_directory` | Path for block files (e.g. `~/.bitcoin/blocks/`). |

---

### btck_chainstate_manager_options_set_worker_threads_num

```c
void btck_chainstate_manager_options_set_worker_threads_num(
    btck_ChainstateManagerOptions* opts, int worker_threads);
```

Sets the number of parallel script-verification threads. Range is clamped to `[0, 15]`. `0` disables parallel verification.

---

### btck_chainstate_manager_options_set_wipe_dbs

```c
int btck_chainstate_manager_options_set_wipe_dbs(
    btck_ChainstateManagerOptions* opts,
    int wipe_block_tree_db,
    int wipe_chainstate_db);
```

Enables database wipe on next `btck_chainstate_manager_import_blocks()` call. Combined with import, this triggers a reindex. Returns `0` on success.

`wipe_block_tree_db` should only be `1` if `wipe_chainstate_db` is also `1`.

---

### btck_chainstate_manager_options_update_block_tree_db_in_memory

```c
void btck_chainstate_manager_options_update_block_tree_db_in_memory(
    btck_ChainstateManagerOptions* opts, int block_tree_db_in_memory);
```

Run block tree database in-memory (non-persistent). Useful for testing.

---

### btck_chainstate_manager_options_update_chainstate_db_in_memory

```c
void btck_chainstate_manager_options_update_chainstate_db_in_memory(
    btck_ChainstateManagerOptions* opts, int chainstate_db_in_memory);
```

Run chainstate (UTXO) database in-memory.

---

### btck_chainstate_manager_options_destroy

```c
void btck_chainstate_manager_options_destroy(btck_ChainstateManagerOptions* opts);
```

---

## ChainstateManager

### btck_chainstate_manager_create

```c
btck_ChainstateManager* btck_chainstate_manager_create(
    const btck_ChainstateManagerOptions* opts);
```

Creates the chainstate manager. Returns `NULL` on error.

---

### btck_chainstate_manager_get_best_entry

```c
const btck_BlockTreeEntry* btck_chainstate_manager_get_best_entry(
    const btck_ChainstateManager* chainstate_manager);
```

Returns the block tree entry with the most cumulative proof-of-work. Non-owned.

---

### btck_chainstate_manager_process_block_header

```c
int btck_chainstate_manager_process_block_header(
    btck_ChainstateManager* chainstate_manager,
    const btck_BlockHeader* header,
    btck_BlockValidationState* block_validation_state);
```

Validates and processes a block header. Returns `0` on success.

---

### btck_chainstate_manager_import_blocks

```c
int btck_chainstate_manager_import_blocks(
    btck_ChainstateManager* chainstate_manager,
    const char** block_file_paths_data,
    size_t* block_file_paths_lens,
    size_t block_file_paths_data_len);
```

Imports blocks from external `.dat` files and/or triggers a reindex (if wipe flags were set). Pass `NULL` arrays for a pure reindex. Returns `0` on success.

---

### btck_chainstate_manager_process_block

```c
int btck_chainstate_manager_process_block(
    btck_ChainstateManager* chainstate_manager,
    const btck_Block* block,
    int* new_block);
```

Validates and processes a block. Saves it to disk if checks pass; extends the chain if valid. Returns `0` on success (including duplicate blocks). `new_block` is set to `1` if the block was not previously processed.

The return value does **not** indicate block validity. Register a `block_checked` validation callback for detailed validity information.

---

### btck_chainstate_manager_get_active_chain

```c
const btck_Chain* btck_chainstate_manager_get_active_chain(
    const btck_ChainstateManager* chainstate_manager);
```

Returns a non-owned pointer to the currently active best chain. Contents update as blocks are processed. The caller must guard against race conditions with block processing.

---

### btck_chainstate_manager_get_block_tree_entry_by_hash

```c
const btck_BlockTreeEntry* btck_chainstate_manager_get_block_tree_entry_by_hash(
    const btck_ChainstateManager* chainstate_manager,
    const btck_BlockHash* block_hash);
```

Looks up a block tree entry by hash. Returns `NULL` if not found.

---

### btck_chainstate_manager_destroy

```c
void btck_chainstate_manager_destroy(btck_ChainstateManager* chainstate_manager);
```

---

## Chain

### btck_chain_get_height

```c
int32_t btck_chain_get_height(const btck_Chain* chain);
```

Returns the height of the chain tip.

---

### btck_chain_get_by_height

```c
const btck_BlockTreeEntry* btck_chain_get_by_height(const btck_Chain* chain, int block_height);
```

Returns the block tree entry at the given height. Returns `NULL` if out of bounds.

---

### btck_chain_contains

```c
int btck_chain_contains(const btck_Chain* chain, const btck_BlockTreeEntry* block_tree_entry);
```

Returns `1` if the entry is part of this chain, `0` otherwise.

---

## BlockTreeEntry

### btck_block_tree_entry_get_previous

```c
const btck_BlockTreeEntry* btck_block_tree_entry_get_previous(
    const btck_BlockTreeEntry* block_tree_entry);
```

Returns the parent entry, or `NULL` for genesis.

---

### btck_block_tree_entry_get_block_header

```c
btck_BlockHeader* btck_block_tree_entry_get_block_header(
    const btck_BlockTreeEntry* block_tree_entry);
```

Returns a new owned `btck_BlockHeader` for this entry. Caller must destroy it.

---

### btck_block_tree_entry_get_height

```c
int32_t btck_block_tree_entry_get_height(const btck_BlockTreeEntry* block_tree_entry);
```

---

### btck_block_tree_entry_get_block_hash

```c
const btck_BlockHash* btck_block_tree_entry_get_block_hash(
    const btck_BlockTreeEntry* block_tree_entry);
```

Returns a non-owned block hash valid for the lifetime of the entry.

---

### btck_block_tree_entry_equals

```c
int btck_block_tree_entry_equals(
    const btck_BlockTreeEntry* entry1,
    const btck_BlockTreeEntry* entry2);
```

Returns `1` if both entries refer to the same block.

---

## Block

### btck_block_create

```c
btck_Block* btck_block_create(const void* raw_block, size_t raw_block_len);
```

Parses a serialized block. Returns `NULL` on parse error.

---

### btck_block_read

```c
btck_Block* btck_block_read(
    const btck_ChainstateManager* chainstate_manager,
    const btck_BlockTreeEntry* block_tree_entry);
```

Reads and deserializes the block pointed to by `block_tree_entry` from disk. Returns `NULL` on error.

---

### btck_block_copy

```c
btck_Block* btck_block_copy(const btck_Block* block);
```

Increments the reference count. Returns the same pointer (or a new handle to the same block).

---

### btck_block_check

```c
int btck_block_check(
    const btck_Block* block,
    const btck_ConsensusParams* consensus_params,
    btck_BlockCheckFlags flags,
    btck_BlockValidationState* validation_state);
```

Performs context-free block validation (header + body). Does **not** check scripts, timestamps, ordering, or UTXO state. Returns `1` if accepted.

---

### btck_block_count_transactions

```c
size_t btck_block_count_transactions(const btck_Block* block);
```

---

### btck_block_get_transaction_at

```c
const btck_Transaction* btck_block_get_transaction_at(const btck_Block* block, size_t index);
```

Returns a non-owned transaction valid for the lifetime of `block`.

---

### btck_block_get_header

```c
btck_BlockHeader* btck_block_get_header(const btck_Block* block);
```

Returns a new owned `btck_BlockHeader`. Caller must destroy it.

---

### btck_block_get_hash

```c
btck_BlockHash* btck_block_get_hash(const btck_Block* block);
```

Computes and returns the block hash. Caller owns the result.

---

### btck_block_to_bytes

```c
int btck_block_to_bytes(const btck_Block* block, btck_WriteBytes writer, void* user_data);
```

Serializes the block using consensus encoding (same as P2P network). Returns `0` on success.

---

### btck_block_destroy

```c
void btck_block_destroy(btck_Block* block);
```

Decrements the reference count. Frees if count reaches zero.

---

## BlockValidationState

### btck_block_validation_state_create

```c
btck_BlockValidationState* btck_block_validation_state_create(void);
```

---

### btck_block_validation_state_get_validation_mode

```c
btck_ValidationMode btck_block_validation_state_get_validation_mode(
    const btck_BlockValidationState* state);
```

---

### btck_block_validation_state_get_block_validation_result

```c
btck_BlockValidationResult btck_block_validation_state_get_block_validation_result(
    const btck_BlockValidationState* state);
```

---

### btck_block_validation_state_copy

```c
btck_BlockValidationState* btck_block_validation_state_copy(
    const btck_BlockValidationState* state);
```

---

### btck_block_validation_state_destroy

```c
void btck_block_validation_state_destroy(btck_BlockValidationState* state);
```

---

## BlockHeader

### btck_block_header_create

```c
btck_BlockHeader* btck_block_header_create(const void* raw_block_header, size_t len);
```

Parses a serialized 80-byte block header. Returns `NULL` on error.

---

### btck_block_header_copy

```c
btck_BlockHeader* btck_block_header_copy(const btck_BlockHeader* header);
```

---

### btck_block_header_get_hash

```c
btck_BlockHash* btck_block_header_get_hash(const btck_BlockHeader* header);
```

Computes and returns the block hash. Caller owns the result.

---

### btck_block_header_get_prev_hash

```c
const btck_BlockHash* btck_block_header_get_prev_hash(const btck_BlockHeader* header);
```

Returns a non-owned pointer to the previous block hash. Valid for the lifetime of `header`.

---

### btck_block_header_get_timestamp

```c
uint32_t btck_block_header_get_timestamp(const btck_BlockHeader* header);
```

Returns the Unix timestamp (seconds since epoch).

---

### btck_block_header_get_bits

```c
uint32_t btck_block_header_get_bits(const btck_BlockHeader* header);
```

Returns the difficulty target in compact (nBits) format.

---

### btck_block_header_get_version

```c
int32_t btck_block_header_get_version(const btck_BlockHeader* header);
```

---

### btck_block_header_get_nonce

```c
uint32_t btck_block_header_get_nonce(const btck_BlockHeader* header);
```

---

### btck_block_header_destroy

```c
void btck_block_header_destroy(btck_BlockHeader* header);
```

---

## BlockHash

### btck_block_hash_create

```c
btck_BlockHash* btck_block_hash_create(const unsigned char block_hash[32]);
```

---

### btck_block_hash_equals

```c
int btck_block_hash_equals(const btck_BlockHash* hash1, const btck_BlockHash* hash2);
```

Returns `1` if equal.

---

### btck_block_hash_copy

```c
btck_BlockHash* btck_block_hash_copy(const btck_BlockHash* block_hash);
```

---

### btck_block_hash_to_bytes

```c
void btck_block_hash_to_bytes(const btck_BlockHash* block_hash, unsigned char output[32]);
```

Writes the 32-byte hash into `output`.

---

### btck_block_hash_destroy

```c
void btck_block_hash_destroy(btck_BlockHash* block_hash);
```

---

## BlockSpentOutputs

### btck_block_spent_outputs_read

```c
btck_BlockSpentOutputs* btck_block_spent_outputs_read(
    const btck_ChainstateManager* chainstate_manager,
    const btck_BlockTreeEntry* block_tree_entry);
```

Reads undo data (spent outputs) for the given block from disk. Returns `NULL` on error.

---

### btck_block_spent_outputs_copy

```c
btck_BlockSpentOutputs* btck_block_spent_outputs_copy(
    const btck_BlockSpentOutputs* block_spent_outputs);
```

---

### btck_block_spent_outputs_count

```c
size_t btck_block_spent_outputs_count(const btck_BlockSpentOutputs* block_spent_outputs);
```

Returns the number of non-coinbase transactions in the block (equals the number of `btck_TransactionSpentOutputs` entries).

---

### btck_block_spent_outputs_get_transaction_spent_outputs_at

```c
const btck_TransactionSpentOutputs* btck_block_spent_outputs_get_transaction_spent_outputs_at(
    const btck_BlockSpentOutputs* block_spent_outputs, size_t index);
```

Returns a non-owned `btck_TransactionSpentOutputs` valid for the lifetime of `block_spent_outputs`.

---

### btck_block_spent_outputs_destroy

```c
void btck_block_spent_outputs_destroy(btck_BlockSpentOutputs* block_spent_outputs);
```

---

## TransactionSpentOutputs

### btck_transaction_spent_outputs_copy

```c
btck_TransactionSpentOutputs* btck_transaction_spent_outputs_copy(
    const btck_TransactionSpentOutputs* transaction_spent_outputs);
```

---

### btck_transaction_spent_outputs_count

```c
size_t btck_transaction_spent_outputs_count(
    const btck_TransactionSpentOutputs* transaction_spent_outputs);
```

---

### btck_transaction_spent_outputs_get_coin_at

```c
const btck_Coin* btck_transaction_spent_outputs_get_coin_at(
    const btck_TransactionSpentOutputs* transaction_spent_outputs, size_t index);
```

Returns a non-owned `btck_Coin` valid for the lifetime of `transaction_spent_outputs`.

---

### btck_transaction_spent_outputs_destroy

```c
void btck_transaction_spent_outputs_destroy(
    btck_TransactionSpentOutputs* transaction_spent_outputs);
```

---

## Coin

### btck_coin_copy

```c
btck_Coin* btck_coin_copy(const btck_Coin* coin);
```

---

### btck_coin_confirmation_height

```c
uint32_t btck_coin_confirmation_height(const btck_Coin* coin);
```

Returns the block height at which the transaction creating this coin was confirmed.

---

### btck_coin_is_coinbase

```c
int btck_coin_is_coinbase(const btck_Coin* coin);
```

Returns `1` if the coin was created by a coinbase transaction.

---

### btck_coin_get_output

```c
const btck_TransactionOutput* btck_coin_get_output(const btck_Coin* coin);
```

Returns a non-owned `btck_TransactionOutput` valid for the lifetime of `coin`.

---

### btck_coin_destroy

```c
void btck_coin_destroy(btck_Coin* coin);
```

---

## Transaction

### btck_transaction_create

```c
btck_Transaction* btck_transaction_create(const void* raw_transaction, size_t len);
```

Parses a serialized transaction. Returns `NULL` on parse error.

---

### btck_transaction_copy

```c
btck_Transaction* btck_transaction_copy(const btck_Transaction* transaction);
```

Increments the reference count.

---

### btck_transaction_to_bytes

```c
int btck_transaction_to_bytes(const btck_Transaction* transaction,
                               btck_WriteBytes writer, void* user_data);
```

Serializes using consensus encoding. Returns `0` on success.

---

### btck_transaction_count_outputs

```c
size_t btck_transaction_count_outputs(const btck_Transaction* transaction);
```

---

### btck_transaction_count_inputs

```c
size_t btck_transaction_count_inputs(const btck_Transaction* transaction);
```

---

### btck_transaction_get_output_at

```c
const btck_TransactionOutput* btck_transaction_get_output_at(
    const btck_Transaction* transaction, size_t output_index);
```

Returns a non-owned output valid for the lifetime of `transaction`.

---

### btck_transaction_get_input_at

```c
const btck_TransactionInput* btck_transaction_get_input_at(
    const btck_Transaction* transaction, size_t input_index);
```

Returns a non-owned input valid for the lifetime of `transaction`.

---

### btck_transaction_get_txid

```c
const btck_Txid* btck_transaction_get_txid(const btck_Transaction* transaction);
```

Returns a non-owned txid valid for the lifetime of `transaction`.

---

### btck_transaction_destroy

```c
void btck_transaction_destroy(btck_Transaction* transaction);
```

---

## TransactionOutput

### btck_transaction_output_create

```c
btck_TransactionOutput* btck_transaction_output_create(
    const btck_ScriptPubkey* script_pubkey, int64_t amount);
```

Creates an output from a script and amount (satoshis).

---

### btck_transaction_output_get_script_pubkey

```c
const btck_ScriptPubkey* btck_transaction_output_get_script_pubkey(
    const btck_TransactionOutput* output);
```

Non-owned; valid for the lifetime of `output`.

---

### btck_transaction_output_get_amount

```c
int64_t btck_transaction_output_get_amount(const btck_TransactionOutput* output);
```

---

### btck_transaction_output_copy

```c
btck_TransactionOutput* btck_transaction_output_copy(const btck_TransactionOutput* output);
```

---

### btck_transaction_output_destroy

```c
void btck_transaction_output_destroy(btck_TransactionOutput* output);
```

---

## TransactionInput

### btck_transaction_input_copy

```c
btck_TransactionInput* btck_transaction_input_copy(const btck_TransactionInput* input);
```

---

### btck_transaction_input_get_out_point

```c
const btck_TransactionOutPoint* btck_transaction_input_get_out_point(
    const btck_TransactionInput* input);
```

Non-owned; valid for the lifetime of `input`'s parent transaction.

---

### btck_transaction_input_destroy

```c
void btck_transaction_input_destroy(btck_TransactionInput* input);
```

---

## TransactionOutPoint

### btck_transaction_out_point_copy

```c
btck_TransactionOutPoint* btck_transaction_out_point_copy(
    const btck_TransactionOutPoint* out_point);
```

---

### btck_transaction_out_point_get_index

```c
uint32_t btck_transaction_out_point_get_index(const btck_TransactionOutPoint* out_point);
```

Returns the output index (vout).

---

### btck_transaction_out_point_get_txid

```c
const btck_Txid* btck_transaction_out_point_get_txid(const btck_TransactionOutPoint* out_point);
```

Non-owned; valid for the lifetime of `out_point`.

---

### btck_transaction_out_point_destroy

```c
void btck_transaction_out_point_destroy(btck_TransactionOutPoint* out_point);
```

---

## Txid

### btck_txid_copy

```c
btck_Txid* btck_txid_copy(const btck_Txid* txid);
```

---

### btck_txid_equals

```c
int btck_txid_equals(const btck_Txid* txid1, const btck_Txid* txid2);
```

Returns `1` if equal.

---

### btck_txid_to_bytes

```c
void btck_txid_to_bytes(const btck_Txid* txid, unsigned char output[32]);
```

---

### btck_txid_destroy

```c
void btck_txid_destroy(btck_Txid* txid);
```

---

## ScriptPubkey

### btck_script_pubkey_create

```c
btck_ScriptPubkey* btck_script_pubkey_create(const void* script_pubkey, size_t len);
```

Creates a script pubkey from raw serialized bytes.

---

### btck_script_pubkey_copy

```c
btck_ScriptPubkey* btck_script_pubkey_copy(const btck_ScriptPubkey* script_pubkey);
```

---

### btck_script_pubkey_verify

```c
int btck_script_pubkey_verify(
    const btck_ScriptPubkey* script_pubkey,
    int64_t amount,
    const btck_Transaction* tx_to,
    const btck_PrecomputedTransactionData* precomputed_txdata,
    unsigned int input_index,
    btck_ScriptVerificationFlags flags,
    btck_ScriptVerifyStatus* status);
```

Verifies that input `input_index` of `tx_to` correctly spends `script_pubkey`.

| Parameter | Description |
|:----------|:------------|
| `script_pubkey` | The output script being spent. |
| `amount` | Output amount in satoshis. Required when `WITNESS` flag is set. |
| `tx_to` | The spending transaction. |
| `precomputed_txdata` | Required when `TAPROOT` flag is set; must include all spent outputs. |
| `input_index` | Which input of `tx_to` is being verified. |
| `flags` | Bitmask of `btck_ScriptVerificationFlags`. |
| `status` | Optional out-parameter for error code. |

**Returns** `1` if the script is valid, `0` otherwise.

---

### btck_script_pubkey_to_bytes

```c
int btck_script_pubkey_to_bytes(const btck_ScriptPubkey* script_pubkey,
                                 btck_WriteBytes writer, void* user_data);
```

Serializes the script. Returns `0` on success.

---

### btck_script_pubkey_destroy

```c
void btck_script_pubkey_destroy(btck_ScriptPubkey* script_pubkey);
```

---

## PrecomputedTransactionData

### btck_precomputed_transaction_data_create

```c
btck_PrecomputedTransactionData* btck_precomputed_transaction_data_create(
    const btck_Transaction* tx_to,
    const btck_TransactionOutput** spent_outputs, size_t spent_outputs_len);
```

Precomputes hashes for script verification. `spent_outputs` may be `NULL` for non-Taproot verification. Required (with all spent outputs) when verifying Taproot inputs.

---

### btck_precomputed_transaction_data_copy

```c
btck_PrecomputedTransactionData* btck_precomputed_transaction_data_copy(
    const btck_PrecomputedTransactionData* precomputed_txdata);
```

---

### btck_precomputed_transaction_data_destroy

```c
void btck_precomputed_transaction_data_destroy(
    btck_PrecomputedTransactionData* precomputed_txdata);
```
