local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    lazy = false, -- doesn't seem to work properly when lazy-loaded
    keys = {
      { "<leader>gs", "<Cmd>Git<CR>", default_opts, desc = "Fugitive Toggle" },
      { "<leader>GS", ':Git ', default_opts, desc = ":Git" },
    },

    -- <leader>gs closes Fugitive window if in it
    config = function()
      vim.cmd([[
        augroup FugitiveToggle
        autocmd!
        autocmd Filetype fugitive nnoremap <buffer> <silent> <leader>gs :close<CR>
        augroup END
      ]])
    end,
  },
  {
    'tpope/vim-rhubarb',
    dependencies = {
      'tpope/vim-fugitive',
    },
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    lazy = false,
    keys = {
      { "<leader>gb", "<Cmd>Gitsigns toggle_current_line_blame<CR>", default_opts, desc = "Gitsigns Toggle" },
    },
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          "filename",
          "navic", -- navic goes after filename

          -- Component specific options
          color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
          -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
          -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
          --   be enough when the lualine section isn't changing colors based on the mode.
          -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
          --   the current section.

          navic_opts = nil  -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
        }
      },
      -- alternatively, use winbar (top status bar) for navic
      -- winbar = {
      --   lualine_c = {
      --     "navic",
      --     color_correction = nil,
      --     navic_opts = nil
      --   }
      -- },
    },
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = { },
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- load colorscheme here
      vim.cmd [[ colorscheme kanagawa-wave ]]
    end,
  },

  {
    "ribru17/bamboo.nvim",
    lazy = true,
    -- priority = 1000,
    config = function()
      -- load colorscheme here
      -- vim.cmd [[ colorscheme bamboo ]]
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ee", "<Cmd>Neotree toggle<CR>", default_opts, desc = "NeoTree" },
    },
    config = function ()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require('neo-tree').setup {}
    end,
  },

  {
    "projekt0n/github-nvim-theme",
    version = 'v0.0.7',
    lazy = true,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup {}
    end,
  },

  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {
    "windwp/nvim-ts-autotag",
  },

  {
    "cpea2506/one_monokai.nvim",
    lazy = true,
    config = function()
      -- require("one_monokai").setup {}
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    lazy = true,
    keys = {
      { "<leader>ew", "<Cmd>SymbolsOutline<CR>", default_opts, desc = "SymbolsOutline" },
    },
    config = function()
      require("symbols-outline").setup()
    end,
  },

  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup({
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
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    keys = {
      { "<leader>tm", "<Cmd>ToggleTerm<CR>", default_opts, desc = "ToggleTerm" },
    },
    config = function()
      require("toggleterm").setup {}
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
      -- require("tokyonight").setup {}
    end,
  },

  -- neovim treesitter splitjoin
  {
    'Wansmer/treesj',
    lazy = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      { "<leader>sj", "<Cmd>TSJToggle<CR>", default_opts, desc = "TSJToggle" },
      { "<leader>sk", "<Cmd>TSJSplit<CR>", default_opts, desc = "TSJSplit" },
      { "<leader>sl", "<Cmd>TSJJoin<CR>", default_opts, desc = "TSJJoin" },
    },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>er", "<Cmd>TroubleToggle<CR>", default_opts, desc = "Trouble Toggle" },
    },
    opts = {

    },
  },

  {
    "elzr/vim-json",
    config = function()
      vim.cmd([[ let g:vim_json_syntax_conceal = 0 ]])
    end,
  },

  {
    "preservim/vim-markdown",
    dependencies = {
      "godlygeek/tabular",
    },
    config = function()
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

      -- pandoc markdown code blocks
      vim.cmd([[
        let g:pandoc#syntax#codeblocks#embeds#langs = [ "bash", "c", "cpp", "html", "java", "javascript", "py=python", "python", "rust", "shell=sh", "sh", "typescript" ]
        let g:pandoc#syntax#conceal#conceal_code_blocks=1
      ]])
    end,
  },

  {
    "vim-pandoc/vim-pandoc-syntax",
    config = function()
      -- TODO: code blocks are slightly broken (only the first code block is correct...)
      vim.o.conceallevel = 0
      vim.cmd([[
        augroup pandoc_syntax
          au! BufNewFile,BufFilePre,BufRead *.md
            \ set filetype=markdown.pandoc |
            \ setlocal conceallevel=2
        augroup END
      ]])

      vim.cmd([[
        let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']
      ]])
    end,
  },

  {

    "zbirenbaum/copilot.lua",
    -- cmd = "Copilot",
    -- event = "InsertEnter",
    config = function()
      return require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },


  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },

  -- Enables buffer text as fallback.
  {
    "/hrsh7th/cmp-buffer",
    config = function ()
    end
  },

  -- putting everything directly in this table instead
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

vim.o.relativenumber = true

vim.o.ignorecase = false
vim.o.smartcase = false

vim.o.signcolumn = "yes"
vim.o.colorcolumn = "120"

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
-- vim.o.ignorecase = true
-- vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- z=: bring up word suggestions
-- zg: add to dictionary
-- zw: remove from dictionary
-- :set spell
-- :set nospell
vim.opt.spell = true
vim.opt.spellcapcheck = ''

-- scroll offset (this gets annoying)
-- vim.o.scrolloff = 4

-- [[ Basic Keymaps ]]

-- my mappings

map('n', '<Leader>tt', ':vsplit<CR>', opts)
map('n', '<Leader>ty', ':split<CR>', opts)
map('n', '<Leader>tw', ':close<CR>', opts)
map('n', '<Leader>l', ':noh<CR>', opts)
map('i', '<Leader>c', '<Esc>cc', opts)
map('i', '<Leader>d', '<Esc>dd', opts)

map('n', '<Leader>;', 'mpA;<Esc>`p:delmarks p<CR>', opts)
map('i', '<Leader>;', '<Esc>mpA;<Esc>`p:delmarks p<CR>a', opts)

map('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- colorscheme
vim.cmd [[ autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred ]]
vim.cmd [[ match ExtraWhitespace /\s\+$/ ]]
vim.cmd [[ autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ ]]

-- toggle colorscheme
function _toggleColorscheme()
  if vim.g.colors_name == 'kanagawa' then
    print("Switching to light theme...")
    vim.cmd [[ colorscheme github_light_colorblind ]]
  else
    print("Switching to dark theme...")
    vim.cmd [[ colorscheme kanagawa ]]
  end
end
vim.api.nvim_create_user_command("ToggleColorscheme", _toggleColorscheme, {})
map('n', '<Leader>00', '<Cmd>ToggleColorscheme<CR>', opts)
map('n', '<leader>99', "<Cmd>Telescope colorscheme<CR>", { desc = 'Colorscheme with preview' })

map('n', '<leader>ff', "<Cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>", default_opts) -- format file

-- My own noted "plugin".
map('n', '<Leader>qq', '<Cmd>NotedGlobal<CR>', opts)
map('n', '<Leader>qw', '<Cmd>NotedTodo<CR>', opts)
map('n', '<Leader>qe', '<Cmd>NotedProject<CR>', opts)

-- Keymaps for better default experience
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Don't save a newline at the end of *.in files.
vim.cmd [[ autocmd BufNewFile,BufFilePre,BufRead *.in setlocal noeol binary fileformat=dos ]]

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
map('n', '<leader>/', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
map('n', '<leader>sd', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
map('n', '<leader>ss', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
map('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
map('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- map('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- keywords: languages ts syntax highlighting
-- :TSInstallInfo
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    -- Web Frontend
    'html', 'css', 'scss',
    'tsx', 'typescript', 'javascript',
    'astro',

    -- Other langauges
    'python',
    'sql',
    'c', 'cpp',
    'go',
    'java',
    'rust',
    'lua',
    'ruby',
    'bash',

    -- Make words look pretty
    -- 'markdown', -- using vim-pandoc-syntax for this
    'latex',

    -- Neat comments
    'comment',

    -- Configs
    'gitcommit', 'gitignore', 'git_config',
    'make', 'cmake',
    'json', 'yaml', 'toml',
    'dockerfile',
    -- I don't use vimfiles, but it's here just in case
    'vimdoc', 'vim',
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
  },
}

-- Diagnostic keymaps
map('n', 'g[', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" });
map('n', 'g]', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- map('n', '<leader>p', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- tmux
-- map('n', 'CTRL', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local navic = require("nvim-navic")

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    navic.attach(client, bufnr)

    map('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>.', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
-- keywords: Mason mason add lsp add lsp-add add-lsp language
local servers = {
  clangd = {},
  pyright = {},
  tsserver = {},
  cssls = {},
  gopls = {},
  rust_analyzer = {},

  -- lua_ls = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup()

local mason_null_ls = require("mason-null-ls")
mason_null_ls.setup({
  ensure_installed = {
    "prettier",
    "black",
    "gofumpt",
    "rustfmt",
  },
  automatic_installation = false,
  -- ensure that args like "--print-width 120" are split into **two** strings => "--print-width", "120"
  handlers = {
    function() end, -- disable automatic setup of all null-ls sources
    prettier = function(source_name, methods)
      null_ls.register(formatting.prettier.with({ extra_args = {
        "--trailing-comma",
        "all",
        "--print-width",
        "120",
      } }))
    end,
    black = function(source_name, methods)
      null_ls.register(formatting.black.with({ extra_args = { "--fast" } }))
    end,
    gofumpt = function(source_name, methods)
      null_ls.register(formatting.gofumpt.with({  }))
    end,
    rustfmt = function(source_name, methods)
      null_ls.register(formatting.rustfmt.with({  }))
    end,
  },
})

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = "copilot" },
    {
      name = "buffer",
      option = {
        -- gets all buffers
        -- get_bufnrs = function()
        --   return vim.api.nvim_list_bufs()
        -- end,

        -- gets visible buffers
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,

      -- Below is the default comparato list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
}
