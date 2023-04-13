# neovim config

## Installation

1. Install neovim
2. Run the commands below as needed

```sh
# to backup old neovim config
mv ~/.config/nvim ~/.config/nvim.backup

# clear nvim data
rm -rf ~/.local/share/nvim

mkdir -p ~/.config/nvim

git clone https://github.com/seetohjinwei/nvconf.git ~/.config/nvim

# opening neovim will install everything you need
nvim
```

## Plugins

Uses `;` as leader key.

- `:Lazy` - plugin manager
- `:Mason` - LSP manager

Forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
