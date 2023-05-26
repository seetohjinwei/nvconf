local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

map('n', '<Leader>tt', ':vsplit<CR>', opts)
map('n', '<Leader>ty', ':split<CR>', opts)
map('n', '<Leader>tw', ':close<CR>', opts)
map('n', '<Leader>l', ':noh<CR>', opts)
map('i', '<Leader>c', '<Esc>cc', opts)
map('i', '<Leader>d', '<Esc>dd', opts)

map('n', '<Leader>;', 'mpA;<Esc>`p:delmarks p<CR>', opts)
map('i', '<Leader>;', '<Esc>mpA;<Esc>`p:delmarks p<CR>a', opts)

vim.cmd [[ autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred ]]
vim.cmd [[ match ExtraWhitespace /\s\+$/ ]]
vim.cmd [[ autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ ]]

vim.cmd [[ colorscheme one_monokai ]]

-- toggle colorscheme
function _toggleColorscheme()
  if vim.g.colors_name == 'one_monokai' then
    print("Switching to light theme...")
    vim.cmd [[ colorscheme github_light_colorblind ]]
  else
    print("Switching to dark theme...")
    vim.cmd [[ colorscheme one_monokai ]]
  end
end
vim.api.nvim_create_user_command("ToggleColorscheme", _toggleColorscheme, {})
map('n', '<Leader>00', '<Cmd>ToggleColorscheme<CR>', opts)

require("symbols-outline").setup()

-- plugins
map('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
map('n', '<leader>e', "<Cmd>Neotree toggle<CR>", default_opts)
map('n', '<leader>w', "<Cmd>SymbolsOutline<CR>", default_opts)
map('n', '<leader>tm', "<Cmd>ToggleTerm<CR>", default_opts)

-- toggle fugitive
map("n", "<leader>gs", vim.cmd.Git)
vim.cmd([[
  augroup FugitiveToggle
    autocmd!
    autocmd Filetype fugitive nnoremap <buffer> <silent> <leader>gs :close<CR>
  augroup END
]])
map("n", "<leader>GS", ':Git ') -- without CR

map('n', '<leader>ff', "<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>", default_opts) -- format file

map("n", "<leader>gb", '<Cmd>Gitsigns toggle_current_line_blame<CR>') -- toggles in-line Git blame

-- My own noted "plugin".
map('n', '<Leader>qq', '<Cmd>NotedGlobal<CR>', opts)
map('n', '<Leader>qw', '<Cmd>NotedTodo<CR>', opts)
map('n', '<Leader>qe', '<Cmd>NotedProject<CR>', opts)

-- treesj
map('n', '<Leader>sj', '<Cmd>TSJToggle<CR>', opts)
map('n', '<Leader>sk', '<Cmd>TSJSplit<CR>', opts)
map('n', '<Leader>sl', '<Cmd>TSJJoin<CR>', opts)

-- z=: bring up word suggestions
-- zg: add to dictionary
-- zw: remove from dictionary
-- :set spell
-- :set nospell
vim.opt.spell = true
vim.opt.spellcapcheck = ''
