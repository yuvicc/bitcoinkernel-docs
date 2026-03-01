# Bitcoinkernel API Docs

Reference documentation for [Bitcoinkernel](https://github.com/bitcoin/bitcoin) — Bitcoin Core's consensus and validation engine — and its language bindings.

Live site: **https://yuvicc.dev/bitcoinkernel-docs/**

---

## Adding docs for a new language binding

This site is designed so that developers of any language binding can add more docs for other language bindings.

### 1. Prerequisites

Install [uv](https://docs.astral.sh/uv/) and clone the repo:

```bash
git clone https://github.com/yuvicc/bitcoinkernel-docs.git
cd bitcoinkernel-docs
uv add --dev zensical
source .venv/bin/activate
```

Preview the site locally:

```bash
zensical serve
```

### 2. Create your docs directory

Pick a short, lowercase slug for your language (e.g. `go`, `rust`, `python`, `dotnet`):

```
docs/
└── <lang>-api/
    ├── index.md        # overview, requirements, quick-start
    └── ...             # as many pages as you need
```

Every page needs a front-matter title:

```markdown
---
title: My Page Title
---

# My Page Title
...
```

### 3. Add your section to the nav

Open `zensical.toml` and add an entry to the `nav` array:

```toml
nav = [
  ...
  { "My Language Bindings" = [
    { "Overview"  = "<lang>-api/index.md" },
    { "Types"     = "<lang>-api/types.md" },
    { "Functions" = "<lang>-api/functions.md" },
  ]},
]
```

### 4. Useful Markdown features

**Admonitions** (callout boxes):

```markdown
!!! note "Title"
    Body text.

!!! warning
    Watch out.

!!! danger
    Destructive operation.
```

**Code blocks with copy button** (enabled by default):

````markdown
```rust
let ctx = Context::new()?;
```
````

**Tabbed examples:**

````markdown
=== "Mainnet"
    ```rust
    Context::new_mainnet()?;
    ```

=== "Testnet"
    ```rust
    Context::new_testnet()?;
    ```
````

### 5. Build and check

```bash
zensical build
zensical serve
```

### 6. Open a pull request

Push your branch to a fork and open a PR against `master`. The GitHub Actions workflow will build a preview and deploy to GitHub Pages automatically on merge.

---

## Project structure

```
.
├── zensical.toml           # site config and nav
├── docs/
│   ├── index.html          # custom homepage (standalone HTML)
│   ├── assets/
│   │   └── bitcoin-logo.svg
│   ├── c-api/              # C API reference
│   │   ├── index.md
│   │   ├── types.md
│   │   └── functions.md
│   ├── cpp-api/            # C++ wrapper reference
│   │   ├── index.md
│   │   ├── enums.md
│   │   └── classes.md
│   ├── java-api/           # Java bindings reference
│   │   ├── index.md
│   │   └── ...
│   ├── go-api/   
│   ├── rust-api/
│   ├── python-api/ 
│   └── dotnet-api/
├── .github/
│   └── workflows/
│       └── deploy.yml      # builds and deploys to GitHub Pages on push to master
└── .gitignore
```

---

## Deployment

Every push to `master` triggers the GitHub Actions workflow in `.github/workflows/deploy.yml`, which:

1. Installs Zensical
2. Runs `zensical build`
3. Deploys the `site/` output to GitHub Pages
