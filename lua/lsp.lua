-- Make sure to steal the full configs from this repository.
-- We didn't install nvim-lspconfig so we don't have any defaults.
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

vim.lsp.enable({
  "bashls",
  "gopls",
  "lua_ls",
  "rust-analyzer",
})
vim.diagnostic.config({ virtual_text = true })
