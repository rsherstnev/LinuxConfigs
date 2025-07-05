call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'psliwka/vim-smoothie'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
call plug#end()

syntax on
set nocompatible
set number
set cursorline
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set noerrorbells
set nobackup
set noswapfile
set noundofile
set listchars=tab:→\ ,trail:␣,extends:…,space:·,eol:$
set iminsert=0
set mouse=a
set wrap
set linebreak
set clipboard=unnamedplus
set laststatus=3

colorscheme catppuccin-mocha

autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

function! TogglePaste()
    if &paste
        set nopaste
        echo "🔴 Paste Mode OFF"
    else
        set paste
        echo "🟢 Paste Mode ON"
    endif
endfunction

nnoremap <F1> :call TogglePaste()<CR>
inoremap <F1> <C-O>:call TogglePaste()<CR>
nnoremap <F2> :set list!<CR>
nnoremap <F3> :set number!<CR>

lua << END
require('lualine').setup {
  options = {
    theme = 'catppuccin',
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 2 }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}
END
