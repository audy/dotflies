--
-- Plugins
--

-- use system python
-- TODO: ubuntu, windows
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

--
-- Plugin Manager (https://github.com/junegunn/vim-plug)
--

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('tpope/vim-fugitive')
Plug('folke/which-key.nvim')

-- LSP
Plug('neovim/nvim-lspconfig')

-- linting + formatting
Plug('stevearc/conform.nvim')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')

-- the tree
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

Plug("kylechui/nvim-surround")

-- colors / syntax
Plug 'vimpostor/vim-lumen' -- light/dark detection that works in tmux
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

vim.call('plug#end')

--
-- Base Config
-- (needs to run before plugins)

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

--
-- Plugin Configuration
--

-- LSP

require('lspconfig').pyright.setup({})

--- [conform.nvim]

-- TODO: check if project uses black / flake8? inspect pyproject.toml?
require("conform").setup({
  formatters_by_ft = {
    -- Conform will run multiple formatters sequentially
    python = { "ruff_format" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptvue = { "prettier" },
    typescriptreact = { "prettier" },
  },
  -- format async
  format_after_save = {
    lsp_format = "fallback",
  },
})

require("conform").formatters.ruff_format = {
  append_args = { "--line-length", "100" },
}


-- ruff format doesn't sort imports
-- but ruff check complains when the imports aren't sorted
-- type :Imports to sort them...
vim.api.nvim_create_user_command("Imports", function()
  local file = vim.api.nvim_buf_get_name(0) -- Get the current file name
  vim.fn.jobstart({ "ruff", "check", "--select", "I", "--fix", file }, {
    stdout = function(_, data) print(data) end,
    stderr = function(_, data) print("Error: " .. data) end,
    on_exit = function()
      vim.cmd("edit") -- Reload the buffer to reflect the changes
    end,
  })
end, { nargs = 0 })

--- [nvim-surround]

require("nvim-surround").setup({})

-- [telescope]
require('telescope').setup({
  defaults = {
    layout_strategy = 'vertical',  -- This gives you horizontal split
    layout_config = {
      height = 0.999,        -- Almost full height
      width = 0.999,         -- Almost full width
      vertical = {
        height = 0.999,
        preview_cutoff = 10,  -- When to hide preview
      },
    },
  },
  pickers = {
    lsp_references = {
      show_line = false,       -- No line content in results
      fname_width = 80,        -- More space for filenames
    },
    lsp_definitions = {
      show_line = false,
      fname_width = 80,
    },
  }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>jd', '<cmd>Telescope lsp_definitions<cr>')
vim.keymap.set('n', '<leader>jr', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<leader>ji', '<cmd>Telescope lsp_implementations<cr>')
vim.keymap.set('n', '<leader>jt', '<cmd>Telescope lsp_type_definitions<cr>')
-- Replace FuzzyOpen  
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<cr>')

-- [nvim-tree]
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- [nvim-treesitter]
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "vim", "python", "bash", "ruby", "lua", "markdown" },
  auto_install = true,
  highlight = {
    enable = true,
    -- disable = { 'markdown' },
  },

  -- disable treesitter on large files
  disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
          return true
      end
  end,
}

-- disable built-in neovim file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
-- Interface
--

vim.o.ignorecase = true  -- Case-insensitive search
vim.o.smartcase = true  -- Don't be case insensitive if uppercase characters are included in search query

vim.o.mouse = 'vin'
vim.o.clipboard = 'unnamedplus'

vim.o.colorcolumn = "100"

-- Kill window with q
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', { noremap = true, silent = true })

--
-- Custom Commands
--

vim.api.nvim_command('command! Conf execute "tabe ~/.config/nvim/init.lua"')

-- Space+ww to trim trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>ww', 'mz:%s/\\s\\+$//<CR>:let @/=\'\'<CR>`z', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

--
-- Behavior
--

-- Use version control for version control
vim.o.autowrite = true
vim.o.autoread = true

-- indenting (when not defined by ft)
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

-- Respect plugin's preferences
vim.cmd('filetype plugin indent on')

vim.o.wrap = false
vim.o.expandtab = true  -- Expand tabs to spaces
vim.o.smarttab = false  -- No tabs to begin with

vim.o.backup = true
vim.o.swapfile = false

vim.o.undodir = vim.fn.expand('~/.vim/tmp/undo//')     -- Undo files
vim.o.backupdir = vim.fn.expand('~/.vim/tmp/backup//') -- Backups
vim.o.directory = vim.fn.expand('~/.vim/tmp/swap//')   -- Swap files
vim.o.undofile = true
vim.o.undoreload = 10000

vim.o.number = true
vim.o.relativenumber = false

-- Return to same line when you reopen vim
vim.cmd([[
  augroup line_return
    au!
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   execute 'normal! g`"zvzz' |
      \ endif
  augroup END
]])

--
-- Appearance
--

vim.cmd('colorscheme catppuccin-mocha')

-- So colors work in tmux
vim.o.termguicolors = true
vim.opt.termguicolors = true

vim.cmd('syntax enable')

-- Reduce "press Enter ..." messages
vim.o.shortmess = vim.o.shortmess .. 'F'

-- Airline theme
vim.g.airline_theme = 'catppuccin'

-- Highlight pesky invisible chars
vim.cmd('syntax match nonascii "[^\\x00-\\x7F]"')
vim.cmd('highlight nonascii guibg=Red ctermbg=2')
