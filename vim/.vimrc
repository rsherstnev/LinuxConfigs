"call plug#begin('~/.vim/plugins')
"Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim', { 'on': 'Files' }
"Plug 'psliwka/vim-smoothie'
"call plug#end()

set nocompatible
let mapleader = " "

syntax on
filetype plugin indent on
set encoding=utf-8
set number
set cursorline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set noerrorbells
set nobackup
set noswapfile
set listchars=tab:→\ ,trail:␣,extends:…,space:·,eol:$
set mouse=a
set wrap
set linebreak
set laststatus=2
set backspace=indent,eol,start
set wildmenu
set wildmode=longest:full,full
set scrolloff=5
set sidescrolloff=5
set splitbelow
set splitright
set hidden

set t_ut=
set termguicolors
set background=dark
colorscheme sorbet "habamax, unokai или iceberg (внешняя)
set statusline=%f\ %y\ %m\ %{&readonly?'%#Error#🔴 READ ONLY%*':''}\ %=L:%l/%L\ C:%c\ %p%%

augroup filetype_indent
  autocmd!
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType json,html,css,javascript,typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType go setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  autocmd FileType make setlocal noexpandtab tabstop=4
augroup END

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

nnoremap <leader><space> :nohlsearch<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

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
nnoremap <F4> :set relativenumber!<CR>
