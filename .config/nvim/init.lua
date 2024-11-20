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

-- linting + formatting
Plug('mfussenegger/nvim-lint')
Plug('stevearc/conform.nvim')

-- ctrl-P
Plug('cloudhead/neovim-fuzzy')

Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')

-- autocomplete
Plug('Shougo/deoplete.nvim', { ['do'] = ':UpdateRemotePlugins' })
Plug('pechorin/any-jump.vim')

-- the tree
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

Plug("kylechui/nvim-surround")

-- colors / syntax
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

-- language-specific plugins

Plug('LukeGoodsell/nextflow-vim')
Plug('deoplete-plugins/deoplete-jedi')

vim.call('plug#end')

--
-- Plugin Configuration
--

--- [nvim-lint]
require("lint").linters_by_ft = {
    python = { "ruff", "mypy" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

--- [conform.nvim]

-- TODO: check if project uses black / flake8? inspect pyproject.toml?
require("conform").setup({
  formatters_by_ft = {
    -- Conform will run multiple formatters sequentially
    python = { "ruff_format" },
    rust = { "rustfmt" },
    javascript = { { "prettier" } },
    typescript = { { "prettier" } },
    typescriptvue = { { "prettier" } },
  },
  -- format async
  format_after_save = {
    lsp_format = "fallback",
  },
})

require("conform").formatters.ruff_format = {
  append_args = { "--line-length", "100" },
}

--- [nvim-surround]

require("nvim-surround").setup({})

-- [anyjump]

-- AnyJump settings
vim.g.any_jump_references_only_for_current_filetype = 1

-- Any-jump window size & position options
vim.g.any_jump_window_width_ratio  = 1
vim.g.any_jump_window_height_ratio = 1
vim.g.any_jump_window_top_offset   = 0

-- Keybindings for AnyJump
vim.api.nvim_set_keymap('n', '<leader>j', ':AnyJump<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>j', ':AnyJumpVisual<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ab', ':AnyJumpBack<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>al', ':AnyJumpLastResults<CR>', { noremap = true, silent = true })

-- [neovim-fuzzy]

-- Don't look for mercurial
vim.g.fuzzy_rootcmds = {
  { "git", "rev-parse", "--show-toplevel" }
}

-- Map <C-p> to :FuzzyOpen
vim.api.nvim_set_keymap('n', '<C-p>', ':FuzzyOpen<CR>', { noremap = true, silent = true })

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

-- [deoplete]
vim.g['deoplete#enable_at_startup'] = 1


-- Deoplete custom options
vim.fn['deoplete#custom#option']({
  auto_complete_delay = 200,
  max_list = 12,
})

-- [snakemake] (default is to fold everything)
vim.o.foldlevelstart = 99
vim.o.foldlevel = 99

-- disable built-in neovim file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--
-- Interface
--

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.ignorecase = true  -- Case-insensitive search
vim.o.smartcase = true  -- Don't be case insensitive if uppercase characters are included in search query

vim.o.mouse = 'vin'
vim.o.clipboard = 'unnamedplus'

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
