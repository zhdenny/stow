# REF_developer-reference — Developer reference tables

> Reference only. Rules live in `GUIDE_developer.md`.

---

## Reference

### Naming Conventions

| Type | Rule | Do | Don't |
|------|------|----|-------|
| Functions | `camelCase`, verb + noun | `getItemById`, `fetchSchema` | `doStuff`, `thing` |
| Variables | intent first, avoid generic names | `itemList`, `configData` | `data`, `tmp` |
| Booleans | prefix `is` / `has` / `can` / `should` | `isValid`, `hasItems` | `flag`, `state` |
| Event handlers | prefix `handle` + target + event | `handleSubmitClick`, `handleFilterChange` | `onClick`, `clickHandler` |
| Async functions | action-oriented, name what is fetched or saved | `fetchItemList`, `saveUserSettings` | `getData`, `loadStuff` |
| Data objects | context + subject + type | `UserAuthInfo`, `systemStateMap` | `payload`, `thingObject` |
| Files (logic) | responsibility-first, use role suffix when useful | `storage-manager.ts`, `board-renderer.ts` | `utils.ts`, `misc.ts` |

### Commands

| Command | Purpose |
|---------|---------|
| `stow --restow nvim_shared nvim_mac` | Deploy Mac Neovim configuration |
| `luacheck .` | Run Lua linter |
| `docker restart nvim-dev` | Restart Unraid Neovim container |
| `N/A` | No automatic bump command |

### Version

| Item | Detail |
|------|--------|
| Source of truth | `AGENTS.md` |
| Bump command | `N/A` |
| Files auto-updated | `AGENTS.md, docs/*.md` |

### Host Platforms

| Host | OS | Stow Target |
|------|----|-------------|
| Mac | macOS | `/users/zach/.config/nvim` |
| Qsbox | Linux | `/home/beast/.config/nvim` |
| Unraid | Linux | `/users/zach/.config/nvim` (mapped in Docker) |

---

*v0.1.0 — 2026-06-09*
