# Refactor TODO — stow-dotfiles

> Working note for current refactoring tasks. Canonical rules: `GUIDE_developer.md`.

---

## ✅ Phase 1: Living Docs System Bootstrapping (Done)
- [x] Create core templates, register files, and set project metadata. (Done)

---

## 🚀 Phase 2: Unify Options (Backlog)

Objective: Align shared options and investigate duplicate mappings across mac, qsbox, and unraid configurations.

- [ ] **1. Align duplicate keymaps**
  - [ ] Consolidate identical diagnostic and info mappings to `nvim_shared/lua/vim-options.lua`.

---

## 🧊 On Hold / Backlog
- [ ] None.

---

## Safety & Verification
1. Zero-Loss Refactor Protocol: No behavioral changes allowed.
2. Test before and after every major edit.
3. Build must pass before commit.
