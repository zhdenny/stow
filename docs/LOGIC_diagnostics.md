# LOGIC_diagnostics — Diagnostic toggles and filetype-specific diagnostic filters

> **Compact, not incomplete.** Remove sections with no content. Never remove rules, edge cases, or reference rows to save space.

---

## Rules
> Hard constraints. AI must follow these unconditionally.

| Rule | Detail |
|------|--------|
| Global Diagnostic Toggle | Diagnostic toggle hotkey `<leader>Ld` must be registered globally at startup in `vim-options.lua` instead of buffer-locally inside LSP attachments. |
| Markdown Diagnostics | Diagnostics must not be generated or shown for Markdown files. |

---

## Reference
> Lookup tables. No prose.

| Item | Value | Notes |
|------|-------|-------|
| Diagnostic Toggle Keymap | `<leader>Ld` | Toggles buffer-specific diagnostics globally |
| Markdown Linter Status | Disabled (`markdownlint` excluded from `linters_by_ft`) | Prevents linter diagnostics in Markdown buffers |

---

## Edge Cases
> Only document cases that are non-obvious or have caused bugs.

- **Non-LSP buffers**: Toggling diagnostics via `<leader>Ld` works for diagnostics from any source (including `nvim-lint` warnings), even if no LSP server is attached to the buffer.

---

*v0.1.0 — 2026-06-09*
