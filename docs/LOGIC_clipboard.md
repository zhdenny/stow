# LOGIC_clipboard — Platform-specific clipboard/OSC 52 synchronization

> **Compact, not incomplete.** Remove sections with no content. Never remove rules, edge cases, or reference rows to save space.

---

## Rules
> Hard constraints. AI must follow these unconditionally.

| Rule | Detail |
|------|--------|
| Unraid Clipboard configuration | Must not use `unnamedplus`. Clipboard option must be empty (`vim.opt.clipboard = ""`). Custom TextYankPost autocommand encodes yanked text to Base64 and writes OSC 52 sequence directly to stdout. |
| Mac/Qsbox Clipboard configuration | Uses standard `require("vim.ui.clipboard.osc52")` mapping for clipboard provider and appends `"unnamed"` and `"unnamedplus"` to `vim.opt.clipboard`. |
| Unraid Paste keymaps | Map `p` and `P` in normal/visual mode to `"+p` and `"+P` respectively to paste from the registered register. |

---

## Reference
> Lookup tables. No prose.

### Platform Clipboard Implementations

| Platform | Clipboard setting | OSC 52 Method | Autocommand Hook | Paste Mapping |
|----------|-------------------|---------------|------------------|---------------|
| Mac | `{"unnamed", "unnamedplus"}` | `vim.ui.clipboard.osc52` copy/paste functions | None (native clipboard provider) | Default (`p` / `P`) |
| Qsbox | `{"unnamed", "unnamedplus"}` | `vim.ui.clipboard.osc52` copy/paste functions | None (native clipboard provider) | Default (`p` / `P`) |
| Unraid | `""` (empty) | Custom base64 encode + TMUX OSC 52 pass-through sequence | `TextYankPost` calling `osc52_tmux_copy` | `p` -> `"+p`, `P` -> `"+P` |

---

## Edge Cases
> Only document cases that are non-obvious or have caused bugs.

- **OSC 52 TMUX wrapper**: Unraid uses `\x1bPtmux;\x1b\x1b]52;c;%s\x07\x1b\\` because Neovim runs within Tmux inside a Docker container.
- **Base64 encoder implementation**: Since Neovim uses Lua 5.1/LuaJIT, base64 encoding is implemented using custom bitwise/math operations in global function `_G.base64_encode`.

---

*v0.1.0 — 2026-06-09*
