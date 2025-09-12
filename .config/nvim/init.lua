-- ================================
-- LEADER KEYS
-- ================================

local vim = vim

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- ================================
-- CORE SETTINGS
-- ================================

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- System integration
vim.opt.mouse = 'vin'
vim.opt.clipboard = 'unnamedplus'

-- Editor appearance
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true          -- highlight current line
vim.opt.cursorlineopt = "number"   -- only highlight the line number
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true

vim.opt.winborder = "rounded"

-- Indentation
vim.opt.autoindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = false
vim.opt.wrap = false

-- File handling
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.backup = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undoreload = 10000

-- File directories
vim.opt.undodir = vim.fn.expand('~/.vim/tmp/undo//')
vim.opt.backupdir = vim.fn.expand('~/.vim/tmp/backup//')
vim.opt.directory = vim.fn.expand('~/.vim/tmp/swap//')

-- UI improvements
vim.opt.shortmess = vim.o.shortmess .. 'F'

-- Don't fold anything by default
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Appearance & Syntax

vim.cmd('syntax enable')

-- Highlight non-ASCII characters
vim.cmd('syntax match nonascii "[^\\x00-\\x7F]"')
vim.cmd('highlight nonascii guibg=Red ctermbg=2')

-- Status line styling
vim.cmd(":hi statusline guibg=NONE")

-- Is this needed?
vim.cmd('filetype plugin indent on')

vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = "rounded",
    source = "always"
  }
})

-- custom filetypes
vim.filetype.add({
  extension = {
    nf = "nextflow",
  },
})

-- ================================
-- PLUGINS
-- ================================

vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/gbprod/nord.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-mini/mini.completion" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/petertriho/nvim-scrollbar" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/tpope/vim-dispatch" },
  { src = "https://github.com/tpope/vim-fugitive" },
})

-- ================================
-- PLUGIN CONFIGURATION
-- ================================

require("scrollbar").setup()

require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.999,
      width = 0.999,
      vertical = {
        height = 0.999,
        preview_cutoff = 10,
      },
    },
  },
  pickers = {
    lsp_references = {
      show_line = false,
      fname_width = 80,
    },
    lsp_definitions = {
      show_line = false,
      fname_width = 80,
    },
  }
})

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  auto_install = true,
  disable = function(lang, buf)
    local max_filesize = 1024 * 1024 -- 1MiB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
  end,
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
})

-- Use groovy treesitter as stand-in for nextflow
vim.treesitter.language.register("groovy", "nf")

require("oil").setup({
  columns = {
    "icon"
  },
  delete_to_trash = true,
  view_options = {
    show_hidden = false,
    is_hidden_file = function(name, bufnr)
      if name == ".github" then
        return false
      elseif name:match("^%.") then
        return true
      elseif name == "__pycache__" then
        return true
      else
        return false
      end
    end,
  }
})

vim.cmd("colorscheme nord")

require('mini.completion').setup(
  {
    -- Delay (debounce type, in ms) between certain Neovim event and action.
    -- This can be used to (virtually) disable certain automatic actions by
    -- setting very high delay time (like 10^7).
    delay = { completion = 500, info = 100, signature = 50 },

    -- Configuration for action windows:
    -- - `height` and `width` are maximum dimensions.
    -- - `border` defines border (as in `nvim_open_win()`; default "single").
    window = {
      info = { height = 25, width = 80, border = "rounded" },
      signature = { height = 25, width = 80, border = "rounded" },
    },

    -- Way of how module does LSP completion
    lsp_completion = {
      -- `source_func` should be one of 'completefunc' or 'omnifunc'.
      source_func = 'omnifunc',

      -- `auto_setup` should be boolean indicating if LSP completion is set up
      -- on every `BufEnter` event.
      auto_setup = true,

      -- A function which takes LSP 'textDocument/completion' response items
      -- (each with `client_id` field for item's server) and word to complete.
      -- Output should be a table of the same nature as input. Common use case
      -- is custom filter/sort. Default: `default_process_items`
      process_items = nil,

      -- A function which takes a snippet as string and inserts it at cursor.
      -- Default: `default_snippet_insert` which tries to use 'mini.snippets'
      -- and falls back to `vim.snippet.expand` (on Neovim>=0.10).
      snippet_insert = nil,
    },

    -- Fallback action as function/string. Executed in Insert mode.
    -- To use built-in completion (`:h ins-completion`), set its mapping as
    -- string. Example: set '<C-x><C-l>' for 'whole lines' completion.
    fallback_action = '<C-n>',

    -- Module mappings. Use `''` (empty string) to disable one. Some of them
    -- might conflict with system mappings.
    mappings = {
      -- Force two-step/fallback completions
      force_twostep = '<C-Space>',
      force_fallback = '<A-Space>',

      -- Scroll info/signature window down/up. When overriding, check for
      -- conflicts with built-in keys for popup menu (like `<C-u>`/`<C-o>`
      -- for 'completefunc'/'omnifunc' source function; or `<C-n>`/`<C-p>`).
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
    },
  })

-- ================================
-- LSP CONFIGURATION
-- ================================

vim.lsp.enable({
  'bashls',
  'cssls',
  'gopls',
  'html',
  'lua_ls',
  'pyright',
  'ruff',
  'rust_analyzer',
  'ts_ls',
  'nextflow_ls',
})

vim.lsp.config('nextflow_ls', {
  cmd = { 'java', '-jar', '/Users/audy/Code/nf-language-server/language-server-all.jar' },
  filetypes = { 'nextflow' },
  settings = {
    nextflow = {
      files = {
        exclude = { '.git', '.nf-test', 'work' },
      },
    },
  },
})

-- ================================
-- AUTOCOMMANDS
-- ================================

-- Return to same line when reopening files
vim.cmd([[
  augroup line_return
    au!
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   execute 'normal! g`"zvzz' |
      \ endif
  augroup END
]])

-- ================================
-- COMMANDS
-- ================================

-- `Conf`: Open Neovim config
vim.api.nvim_command('command! Conf execute "tabe ~/.config/nvim/init.lua"')

-- `Imports`: (Python) Sort imports
vim.api.nvim_create_user_command("Imports", function()
  local file = vim.api.nvim_buf_get_name(0)
  vim.fn.jobstart({ "ruff", "check", "--select", "I", "--fix", file }, {
    stdout = function(_, data) print(data) end,
    stderr = function(_, data) print("Error: " .. data) end,
    on_exit = function()
      vim.cmd("edit")
    end,
  })
end, { nargs = 0 })

-- ================================
-- KEYMAPS
-- ================================

-- Window management
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', { noremap = true, silent = true })

-- Whitespace cleanup
vim.api.nvim_set_keymap('n', '<leader>ww', 'mz:%s/\\s\\+$//<CR>:let @/=\'\'<CR>`z',
  { noremap = true, silent = true, desc = "Strip whitespace" })

-- LSP keymaps
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set('n', '<leader>li', ':Imports<CR>', { desc = "Sort imports" })
vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover, { desc = "Show hover" })

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>jd', '<cmd>Telescope lsp_definitions<cr>')
vim.keymap.set('n', '<leader>jr', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<leader>ji', '<cmd>Telescope lsp_implementations<cr>')
vim.keymap.set('n', '<leader>jt', '<cmd>Telescope lsp_type_definitions<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files no_ignore=false<cr>')
