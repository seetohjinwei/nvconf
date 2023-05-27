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
- `mason-null-ls` - formatter manager
    - `null-ls.nvim` - formatter
- colorschemes (use `<leader>00` to toggle)
    - `kanagawa` - dark colorscheme
    - `github_nvim_theme` - light colorscheme
- `vim-fugitive` - awesome Git client
- `gitsigns.nvim` - more neat Git stuff (incl. in-line blame)
- `neo-tree.nvim` - file tree
- `nvim-autopairs` - autocomplete pairs (quotes, brackets)
- `Comment.nvim` - toggle commenting of a line / selection
- `lualine.nvim` - status line
    - `nvim-navic.nvim` - current code context, i.e. `getServerSideProps > data.forEach callback`
- `symbols-outline.nvim` - symbol tree
- `trouble.nvim` - symbol tree
- markdown plugins
    - `vim-markdown`
    - `vim-pandoc-syntax`
    - `vim-json`
    - `noted.nvim` - my own "plugin" for quick notes / todos
- `tmux.nvim` - for integration with tmux
- `indent-blankline.nvim` - indentation guide
- `nvim-surround` - I'll eventually learn this
- `toggleterm.nvim` - much better terminal
    - installed, but using tmux to spawn terminal externally instead

Forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
