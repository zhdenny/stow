This project is a GNU stow directory which contains neovim configurations for three different systems - mac, qsbox, and unraid. There is also shared directory which contains neovim configurations which are common across all systems. All versions of neovim across all systems are between neovim version 0.12.2 and v0.13.0-dev.

1. Edits to files within nvim_mac directory and nvim_shared directory impact the mac system. The appropriate stow command must be issued from the mac system for those edits to take effect on the mac system nvim configuration. This is the stow command:

```
stow --dir=/Users/zach/.config/stow --target=/users/zach/.config/nvim --restow nvim_shared nvim_mac
```

2. Edits to files within nvim_qsbox directory and nvim_shared directory impact the qsbox system. The appropriate stow command must be issued from the qsbox system for those edits to take effect on the qsbox system nvim configuration. This is the stow command but this stow command must ONLY be issued by the user manually from the qsbox system. This is something the user must be notified of when necessary.

```
stow --dir=/home/beast/.config/stow --target=/home/beast/.config/nvim --restow nvim_shared nvim_qsbox
```

3. Edits to files within nvim_unraid directory and nvim_shared directory impact the unraid system. The nvim-dev docker container must be manually restarted by the user in order to edits to take effect. This is something the user must be notified of when necessary.
