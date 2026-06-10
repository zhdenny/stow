# STANDARDS_interface — Interface specifications for stow-dotfiles

---

## Rules

> Hard constraints for this domain. AI must follow unconditionally.

| Rule | Detail |
|------|--------|
| No magic numbers | All values must come from tokens or shared constants |
| Colorscheme | Always use Catppuccin color theme across all setups |
| Nerd Fonts | Enable `vim.g.have_nerd_font = true` on terminal configurations supporting Nerd Fonts |

---

## Interface Reference

### Color System / Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| `colorscheme` | `catppuccin` | Base styling color palette |
| `termguicolors` | `true` | Enable 24-bit RGB colors |

### Component Standards

| Component | Class / Pattern | Purpose |
|-----------|----------------|---------|
| statusline | `lualine.nvim` | Bottom status indicator |
| file tree | `neo-tree.nvim` | Sidebar folder navigation |
| message ui | `noice.nvim` | Enhanced hover, cmdline, and popupmenu |
| winsep | `colorful-winsep.nvim` | Active window border highlighting |

### Layout

| Item | Value |
|------|-------|
| `splitright` | `true` | Open vertical splits to the right |
| `splitbelow` | `true` | Open horizontal splits below |
| `cursorline` | `true` | Highlight the screen line of the cursor |
| `scrolloff` | `10` | Screen lines to keep above and below cursor |

---

## Edge Cases

> Only document cases that are non-obvious or have caused regressions.

- **Terminal transparency**: If terminal background colors look incorrect, verify `termguicolors` is enabled and terminal emulator supports 24-bit color.

---

*v0.1.0 — 2026-06-09*
