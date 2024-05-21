--
-- Plugins
--

-- use virtualenv for Python dependencies
vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim/bin/python"

--
-- Plugin Manager (https://github.com/junegunn/vim-plug)
--

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('neomake/neomake') -- autodetects mypy, flake8, snakefmt, etc...


Plug('cloudhead/neovim-fuzzy')
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('Shougo/deoplete.nvim', { ['do'] = ':UpdateRemotePlugins' })
Plug('SirVer/ultisnips')
Plug('pechorin/any-jump.vim')

Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})

-- colors
Plug('haishanh/night-owl.vim')
Plug('rose-pine/neovim')
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })


Plug('LukeGoodsell/nextflow-vim')

-- python

Plug('sbdchd/neoformat')
Plug('psf/black', { ['branch'] = 'stable' })
Plug('deoplete-plugins/deoplete-jedi')
Plug('snakemake/snakemake', {['rtp'] = 'misc/vim'})

vim.call('plug#end')

--
-- Plugins
--

-- [neomake]

-- Neomake automake configuration
-- vim.fn['neomake#configure#automake']('w')

-- Neomake settings for Python
vim.g.neomake_python_flake8_maker = { args = { '--ignore=E501,W503,E203', '--format=default' } }
vim.g.neomake_python_enabled_makers = { 'flake8', 'mypy' }

-- Black line length
vim.g.black_linelength = 100

-- Autocommands
vim.cmd([[
  autocmd BufWritePre *.py execute ':Black'
  autocmd BufWritePre Snakefile execute ':Neoformat'
]])

-- [anyjump]

-- AnyJump settings
vim.g.any_jump_references_only_for_current_filetype = 1

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

-- Always use pwd as root
local function fuzzy_getroot()
  return "."
end

-- Map <C-p> to :FuzzyOpen
vim.api.nvim_set_keymap('n', '<C-p>', ':FuzzyOpen<CR>', { noremap = true, silent = true })

-- [black]
vim.g.black_linelength = 100

-- [neomake]
vim.g.neoformat_snakemake_snakefmt = {
    exe = 'snakefmt',
    args = { '-l', tostring(vim.g.black_linelength), '-' },
    stdin = 1,
}

vim.g.neoformat_enabled_snakemake = { 'snakefmt' }


if vim.fn.exists(':Neoformat') == 2 then
  vim.api.nvim_command('command! Snakefmt :Neoformat! snakemake snakefmt')
end


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
  ensure_installed = { "c", "vim", "python", "bash", "ruby", "lua" },
  auto_install = true,
  highlight = {
    enable = true,
    disable = {'markdown'},
  },
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
-- Custom Commands
--

vim.api.nvim_command('command! Conf execute "tabe ~/.config/nvim/init.lua"')


-- Space+ww to trim trailing whitespace
vim.api.nvim_set_keymap('n', '<leader>ww', 'mz:%s/\\s\\+$//<CR>:let @/=\'\'<CR>`z', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

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
-- Behavior
--

-- Use version control for version control
vim.o.autowrite = true
vim.o.autoread = true

vim.o.autoindent = true

-- Defaults
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- Respect plugin's preferences
vim.cmd('filetype plugin indent on')

-- Override markdown
vim.cmd([[
  autocmd Filetype markdown setlocal ts=2 sw=2 expandtab
]])

vim.o.wrap = false
vim.o.expandtab = true  -- Expand tabs to spaces
vim.o.smarttab = false  -- No tabs to begin with

vim.o.backup = true
vim.o.swapfile = false

vim.o.undodir = '~/.vim/tmp/undo//'     -- Undo files
vim.o.backupdir = '~/.vim/tmp/backup//' -- Backups
vim.o.directory = '~/.vim/tmp/swap//'   -- Swap files
vim.o.undofile = true
vim.o.undoreload = 10000

vim.o.number = true
vim.o.relativenumber = true

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

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


-- So colors work in tmux
vim.o.t_Co = '256'
vim.o.termguicolors = true

vim.cmd('syntax enable')

-- Reduce "press Enter ..." messages
vim.o.shortmess = vim.o.shortmess .. 'F'

-- Colorscheme
vim.cmd('colorscheme catppuccin-mocha')

-- Airline theme
vim.g.airline_theme = 'catppuccin'

-- Highlight pesky invisible chars
vim.cmd('syntax match nonascii "[^\\x00-\\x7F]"')
vim.cmd('highlight nonascii guibg=Red ctermbg=2')
