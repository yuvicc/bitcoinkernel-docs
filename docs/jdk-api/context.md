---
title: ContextManager
---


# `ContextManager`

`org.bitcoinkernel.ContextManager`

`ContextOptions` for configuration and `Context` as the kernel's root object.

---

## ContextOptions

```java
public static class ContextOptions implements AutoCloseable {
    public ContextOptions() throws KernelTypes.KernelException
    public void setChainParams(ChainParameters chainParams)
    public void setNotifications(KernelNotificationManager notificationManager)
    public void setValidationInterface(ValidationInterfaceManager validationManager)
    public void close() throws Exception
}
```

Configuration builder for a `Context`. All setters are optional — unset options use their defaults (mainnet, no callbacks).

Throws `KernelException` on construction failure.

**Methods:**

| Method | Description |
|:-------|:------------|
| `setChainParams(ChainParameters)` | Select the Bitcoin network. Default: mainnet. |
| `setNotifications(KernelNotificationManager)` | Register kernel lifecycle notification callbacks. |
| `setValidationInterface(ValidationInterfaceManager)` | Register block validation event callbacks. |

**Example:**

```java
try (var params  = new ChainParameters(ChainType.MAINNET);
     var notifs  = new KernelNotificationManager(myNotifCallbacks);
     var valIface = new ValidationInterfaceManager(myValCallbacks);
     var opts    = new ContextOptions()) {

    opts.setChainParams(params);
    opts.setNotifications(notifs);
    opts.setValidationInterface(valIface);

    try (var ctx = new Context(opts)) {
        // use ctx ...
    }
}
```

---

## Context

```java
public static class Context implements AutoCloseable {
    public Context() throws KernelTypes.KernelException
    public Context(ContextOptions options) throws KernelTypes.KernelException
    public boolean interrupt()
    public void close() throws Exception
}
```

The root kernel object. Every `ChainstateManager` requires a live `Context`. `AutoCloseable`.

**Constructors:**

| Constructor | Description |
|:------------|:------------|
| `Context()` | Default context — mainnet, no callbacks. |
| `Context(ContextOptions)` | Configured context. |

Both throw `KernelException` if the native context cannot be created.

**Methods:**

| Method | Returns | Description |
|:-------|:--------|:------------|
| `interrupt()` | `boolean` | Signal any long-running kernel operation (e.g. `ImportBlocks`) to stop. Returns `true` if the signal was sent successfully. |

**Lifecycle note:** A `Context` must outlive all objects that depend on it (e.g. `ChainstateManager`). Close in reverse order of construction.

```java
try (Context ctx = new Context()) {
    try (var csmOpts = new ChainstateManagerOptions(ctx, dataDir, blocksDir);
         var csm    = new ChainstateManager(ctx, csmOpts)) {
        csm.ImportBlocks(new String[]{});
    }
} // ctx closed last
```
