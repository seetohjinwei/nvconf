-- reference: https://jdhao.github.io/2019/01/15/markdown_edit_preview_nvim/

-- disable header folding
vim.cmd([[ let g:vim_markdown_folding_disabled = 1 ]])

-- do not use conceal feature, the implementation is not so good
vim.cmd([[ let g:vim_markdown_conceal = 0 ]])

-- disable math tex conceal feature
vim.cmd([[ let g:tex_conceal = "" ]])
vim.cmd([[ let g:vim_markdown_math = 1 ]])

-- support front matter of various format
vim.cmd([[ let g:vim_markdown_frontmatter = 1 ]])
vim.cmd([[ let g:vim_markdown_toml_frontmatter = 1 ]])
vim.cmd([[ let g:vim_markdown_json_frontmatter = 1 ]])

return {
  "preservim/vim-markdown",
  dependencies = {
    "godlygeek/tabular",
  },
}
