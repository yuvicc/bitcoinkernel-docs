---
title: C++ Wrapper
---


# C++ Wrapper — `bitcoinkernel_wrapper.h`

The C++ wrapper provides an ergonomic, modern C++20 layer over the C API. All types live in the `btck` namespace.

---

## Design Principles

| Feature | Description |
|:--------|:------------|
| **RAII** | All owned resources use `Handle<>` or `UniqueHandle<>` — automatically destroyed. |
| **Views** | Non-owning references use `View<>` — zero-cost, no allocation. |
| **Copy/move** | `Handle<>` is copyable (calls the C `*_copy()`) and moveable. `UniqueHandle<>` is move-only. |
| **Range iteration** | Collections expose `Inputs()`, `Outputs()`, `Transactions()`, `Entries()`, `Coins()` — all `std::ranges::random_access_range`. |
| **Bitmasks** | `ScriptVerificationFlags` and `BlockCheckFlags` support `|`, `&`, `^`, `~` operators. |
| **Callbacks** | `KernelNotifications` and `ValidationInterface` are virtual base classes — subclass and override. |

---

## Requirements

- C++20 or later
- `#include <kernel/bitcoinkernel_wrapper.h>`

---

## Memory Model

```
View<CType>          — non-owning const pointer, no lifetime management
Handle<CType, ...>   — owning, copyable, moveable; destructor calls DestroyFunc
UniqueHandle<CType>  — owning, move-only (like unique_ptr)
```

Typical class hierarchy example:

```cpp
// ScriptPubkeyView — non-owning (from btck_transaction_output_get_script_pubkey)
class ScriptPubkeyView : public View<btck_ScriptPubkey>, public ScriptPubkeyApi<ScriptPubkeyView> {};

// ScriptPubkey — owned handle (from btck_script_pubkey_create)
class ScriptPubkey : public Handle<btck_ScriptPubkey,
                                   btck_script_pubkey_copy,
                                   btck_script_pubkey_destroy>,
                     public ScriptPubkeyApi<ScriptPubkey> {};
```

---

## Namespace

All types are in `namespace btck`. Either use fully qualified names or `using namespace btck;`.
