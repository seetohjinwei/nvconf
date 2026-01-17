-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

-- UI

vim.cmd.colorscheme("nordfox")

vim.opt.termguicolors = true -- Enable true colors

vim.opt.guicursor = "i:block" -- Use block cursor in insert mode

vim.opt.colorcolumn = "120"
vim.opt.signcolumn = "yes:1" -- Always show sign column

vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = "tab: ,multispace:|   ,eol:󰌑"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

vim.opt.cursorline = true -- Highlight the current line

vim.opt.wrap = true
vim.opt.breakindent = true

vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

vim.opt.winborder = "rounded" -- Use rounded borders for windows

-- netrw (file explorer)
-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/

vim.g.netrw_banner = 0 -- Disable the banner
vim.g.netrw_liststyle = 3

-- Commands

vim.opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer

vim.opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu

vim.opt.hlsearch = true

-- File management

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.nvim/undodir'

-- Editing

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 4
vim.opt.shiftround = true

vim.opt.clipboard = "unnamedplus"

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

-- File types

vim.cmd [[ autocmd Filetype go setlocal tabstop=8 shiftwidth=8 softtabstop=8 ]]
vim.cmd [[ autocmd BufNewFile,BufFilePre,BufRead *.in setlocal noeol binary fileformat=dos ]]
