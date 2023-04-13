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

Non-exhaustive list of plugins.

This config uses `;` as leader key.

- `lazy.nvim` - `:Lazy` - plugin manager
- `mason.nvim` - `:Mason` - lsp (& related) manager
    - `mason-lspconfig.nvim` - lsp
    - `null-ls.nvim` - formatter
- `one_monokai.nvim` - colorscheme of choice
- `vim-fugitive` - awesome Git client
- `gitsigns.nvim` - more neat Git stuff (incl. in-line blame)
- `toggleterm.nvim` - much better terminal
- `neo-tree.nvim` - file tree
- `nvim-autopairs` - autocomplete pairs (quotes, brackets)
- `Comment.nvim` - toggle commenting of a line / selection
- `lualine.nvim` - status line
- `indent-blankline.nvim` - indentation guide
- `nvim-surround` - I'll eventually learn this

Forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
