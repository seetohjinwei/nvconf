-- pandoc markdown code blocks
vim.cmd([[
  let g:pandoc#syntax#codeblocks#embeds#langs = [ "bash", "c", "cpp", "html", "java", "javascript", "py=python", "python", "rust", "shell=sh", "sh", "typescript" ]
  let g:pandoc#syntax#conceal#conceal_code_blocks=1
]])

return {
  "vim-pandoc/vim-pandoc-syntax",
}
