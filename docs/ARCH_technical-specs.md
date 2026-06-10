# ARCH_technical-specs — GNU Stow layout and host specifications

> **Compact, not incomplete.** Remove sections with no content. Never remove rules, edge cases, or reference rows to save space.

---

## Rules
> Hard constraints. AI must follow these unconditionally.

| Rule | Detail |
|------|--------|
| Host-specific files | Never modify files in `nvim_mac/`, `nvim_qsbox/`, or `nvim_unraid/` unless target host requires those specific changes. |
| Shared config primacy | Keep configurations common across all hosts in `nvim_shared/`; avoid code duplication between hosts. |
| Neovim Version Range | All Neovim versions across hosts must remain between 0.12.2 and v0.13.0-dev. |
| Stow Commands | Follow specified stow command for each host exactly as documented. |

---

## Reference
> Lookup tables. No prose.

### Directory Layout

| Folder | Target Host / Platform | Deploy Command / Restart Method |
|--------|------------------------|---------------------------------|
| `nvim_shared/` | Shared across all hosts | Restowed on mac/qsbox, restart docker on unraid |
| `nvim_mac/` | macOS (Zach's Mac) | `stow --dir=/Users/zach/stow --target=/users/zach/.config/nvim --restow nvim_shared nvim_mac` |
| `nvim_qsbox/` | qsbox (Linux host) | `stow --dir=/home/beast/.config/stow --target=/home/beast/.config/nvim --restow nvim_shared nvim_qsbox` (User manual execution only) |
| `nvim_unraid/` | unraid (Linux host / nvim-dev docker container) | Restart `nvim-dev` docker container |

### Host OS Environment

| Host | User | OS Type | Home Directory | Clipboard Mechanism |
|------|------|---------|----------------|---------------------|
| Mac | zach | macOS | `/Users/zach/` | `vim.ui.clipboard.osc52` |
| Qsbox | beast | Linux | `/home/beast/` | `vim.ui.clipboard.osc52` |
| Unraid | root | Linux (Docker) | `/root_unraid/` | Custom Lua Base64 + TMUX OSC 52 sequence |

---

## Edge Cases
> Only document cases that are non-obvious or have caused bugs.

- **Qsbox deployment**: AI must not run the stow command directly; notify user to run it manually from the qsbox system.
- **Unraid deployment**: AI must not edit or restart docker container directly; instruct user to restart the `nvim-dev` container manually.

---

*v0.1.0 — 2026-06-09*
