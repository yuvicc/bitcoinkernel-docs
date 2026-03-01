---
title: C API
---


# C API — `bitcoinkernel.h`

The C API provides a stable "C" interface to Bitcoin Core's consensus engine.

## C Header API Source

[`bitcoin/src/kernel/bitcoinkernel.h`](github.com/bitcoin/bitcoin/src/kernel/bitcoinkernel.h)

License: MIT

---

## Memory & Ownership Rules

- Pointers returned by `*_create()` functions are **owned** by the caller and must be freed with the corresponding `*_destroy()` function.
- `const` pointer return values are **views** — they are unowned and valid only for the lifetime of the parent object.
- A function that accepts pointer arguments makes **no assumptions about argument lifetimes**. Arguments may be freed immediately after the function returns.
- Reference-counted types (`btck_Transaction`, `btck_Block`) use `*_copy()` to increment the reference count rather than performing a deep copy.

---

## Error Handling

- Functions return `NULL` on allocation failure or invalid input.
- Script verification returns `1` on success, `0` on failure, and writes a `btck_ScriptVerifyStatus` error code to an optional out-parameter.
- Fatal and flush errors are delivered asynchronously through kernel notification callbacks.

Always check return values. Passing `NULL` where a non-null pointer is required is undefined behaviour.

### The currently ongoing changes to the C header API can be seen [here](https://github.com/bitcoin/bitcoin/projects/3)
