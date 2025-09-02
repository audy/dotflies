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
vim.o.ignorecase = true
vim.o.smartcase = true

-- System integration
vim.o.mouse = 'vin'
vim.o.clipboard = 'unnamedplus'

-- Editor appearance
vim.o.colorcolumn = "100"
vim.o.number = true
vim.o.relativenumber = false
vim.o.termguicolors = true
vim.opt.termguicolors = true
vim.o.winborder = "rounded"

-- Indentation
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.smarttab = false
vim.o.wrap = false

-- File handling
vim.o.autowrite = true
vim.o.autoread = true
vim.o.backup = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undoreload = 10000

-- File directories
vim.o.undodir = vim.fn.expand('~/.vim/tmp/undo//')
vim.o.backupdir = vim.fn.expand('~/.vim/tmp/backup//')
vim.o.directory = vim.fn.expand('~/.vim/tmp/swap//')

-- UI improvements
vim.o.shortmess = vim.o.shortmess .. 'F'

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

-- ================================
-- PLUGINS
-- ================================

vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/tpope/vim-dispatch" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://kylechui/nvim-surround" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/gbprod/nord.nvim" },
  { src = "https://github.com/petertriho/nvim-scrollbar" },
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
    local max_filesize = 1024 * 1024   -- 1MiB
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
