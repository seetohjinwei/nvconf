-- Plugins are stored in ~/.local/share/nvim/site/pack/core/opt/ (Use `gf` to visit this!)
-- To remove plugins, manually delete them from the directory
-- TODO: surround

-- Git

vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})
require('gitsigns').setup({ signcolumn = true })

vim.pack.add({
    { src = "https://github.com/tpope/vim-fugitive" },
})
vim.cmd([[
  augroup FugitiveToggle
  autocmd!
  autocmd Filetype fugitive nnoremap <buffer> <silent> <leader>gs :close<CR>
  augroup END
]])

-- tmux

vim.pack.add({
    { src = "https://github.com/aserowy/tmux.nvim" },
})
require('tmux').setup(
    {
        copy_sync = {
            enable = false,
        },
        navigation = {
            -- cycles to opposite pane while navigating into the border
            cycle_navigation = false,

            -- enables default keybindings (C-hjkl) for normal mode
            enable_default_keybindings = true,

            -- prevents unzoom tmux when navigating beyond vim border
            persist_zoom = false,
        },
        resize = {
            -- enables default keybindings (A-hjkl) for normal mode
            enable_default_keybindings = true,

            -- sets resize steps for x axis
            resize_step_x = 5,

            -- sets resize steps for y axis
            resize_step_y = 5,
        }
    }
)

-- Editing

vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
})
require('nvim-autopairs').setup()

vim.pack.add({
    { src = "https://github.com/kylechui/nvim-surround" },
})
require('nvim-surround').setup()

vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
})
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end
local oil_show_details = false
require("oil").setup({
  keymaps = {
    ["="] = {
      desc = "Toggle file detail view",
      callback = function()
        oil_show_details = not oil_show_details
        if oil_show_details then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
})

-- BUG: This doesn't show ignored status for files in ignored directories
-- because of the git commmand (`git status --porcelain --ignored`) used.
vim.pack.add({
    { src = "https://github.com/benomahony/oil-git.nvim" },
})
require('oil-git').setup()

require('plugins.focus')

-- LSP

vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
})
require("mason").setup({})

vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})
require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    keymap = {
        preset = "default",
        ['K'] = {
            function(cmp)
                -- Show signature if in Normal mode
                if vim.api.nvim_get_mode().mode == 'n' and cmp.show_signature() then
                    return true
                end
                return false
            end,
            'fallback'
        },
        ['<C-space>'] = {},
        ['<C-p>'] = {},
        ['<Tab>'] = { 'select_and_accept' },
        ['<S-Tab>'] = {},
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- Re-binding ESC is annoying because it would require 2 clicks to go from Insert -> Normal in certain cases
        -- ['<Esc>'] = {
        --     function(cmp)
        --         if cmp.is_menu_visible() or cmp.is_signature_visible() then
        --             cmp.hide_signature()
        --             cmp.hide()
        --             return true
        --         end
        --         return false
        --     end,
        --     'fallback'
        -- },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    -- TODO: If I backspace, the completion doesn't show up anymore...
    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<Tab>'] = { 'accept' },
            ['<CR>'] = {},
        },
        completion = { menu = { auto_show = true } },
    },

    sources = {
        default = { 'lsp', 'buffer' },
    },

    signature = { enabled = true },
})

-- fzf

vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
})
local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            -- ["<C-f>"] = "preview-page-down",
            -- ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            -- ["ctrl-t"] = "first",
            -- ["ctrl-g"] = "last",
            -- ["ctrl-d"] = "half-page-down",
            -- ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})

-- colorscheme

vim.pack.add({
    { src = "https://github.com/EdenEast/nightfox.nvim" },
})
