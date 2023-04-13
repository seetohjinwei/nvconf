local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

map('n', '<Leader>tt', ':vsplit<CR>', opts)
map('n', '<Leader>ty', ':split<CR>', opts)
map('n', '<Leader>tw', ':close<CR>', opts)
map('n', '<Leader>l', ':noh<CR>', opts)

map('n', '<Leader>;', 'mpA;<Esc>`p:delmarks p<CR>', opts)
map('i', '<Leader>;', '<Esc>mpA;<Esc>`p:delmarks p<CR>a', opts)

vim.cmd [[ highlight ExtraWhitespace ctermbg=darkred guibg=darkred ]]
vim.cmd [[ match ExtraWhitespace /\s\+$/ ]]
vim.cmd [[ autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ ]]

-- plugins
map('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>e', "<Cmd>Neotree toggle<CR>", default_opts)
map('n', '<leader>tm', "<Cmd>ToggleTerm<CR>", default_opts)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>GS", ':Git ') -- without CR
