-- Keybindings

local function keymap(modes, lhs, rhs, opts)
    opts = opts or { noremap=true, silent=true }
    vim.keymap.set(modes, lhs, rhs, opts)
end

-- Splits
keymap('n', '<Leader>tt', ':vsplit<CR>')
keymap('n', '<Leader>ty', ':split<CR>')
keymap('n', '<Leader>tw', ':close<CR>')

-- netrw
keymap('n', '<Leader>e', ':Oil<CR>')

-- Fast insertion of leader key
keymap('i', ';\'', ';')

-- :noh
keymap('n', '<Leader>l', ':noh<CR>')

-- Add semicolon to EOL
keymap('n', '<Leader>;', 'mpA;<Esc>`p:delmarks p<CR>')
keymap('i', '<Leader>;', '<Esc>mpA;<Esc>`p:delmarks p<CR>a')

-- Use C-s for increment because C-a is used by tmux
keymap('n', '<C-s>', '<C-a>')

-- Format file using LSP
keymap('n', '<leader>ff', '<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>')

-- Disable space in normal / visual modes
keymap({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- LSP

keymap('n', '<leader>rn', vim.lsp.buf.rename)
keymap('n', '<leader>.', vim.lsp.buf.code_action)

keymap('n', 'gd', vim.lsp.buf.definition)
keymap('n', 'gr', '<Cmd>FzfLua lsp_references<CR>')

-- Plugins

keymap('n', '<leader>ps', '<cmd>lua vim.pack.update()<CR>')

keymap('n', '<leader>sf', '<Cmd>FzfLua files<CR>')
keymap('n', '<leader>sg', '<Cmd>FzfLua live_grep<CR>')

keymap('n', '<leader>gs', '<Cmd>Git<CR>')

-- Focus pane (similar to tmux)
keymap('n', '<C-w>m', '<Cmd>FocusPaneToggle<CR>')
