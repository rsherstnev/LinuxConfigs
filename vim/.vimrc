call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
call plug#end()

syntax on
set number
set cursorline
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set noswapfile
set iminsert=0
set autoindent
set mouse=a
set list
set shortmess=atI
set t_Co=256
set background=dark

colorscheme habamax
let g:airline_theme='wombat'

set backupdir=$HOME/.vim/backups
set directory=$HOME/.vim/swaps
if exists("&undodir")
	set undodir=$HOME/.vim/undo

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

map <F1> :NERDTreeToggle<CR>

nmap <F2> :w!<CR>
imap <F2> <Esc>:w!<CR>
vmap <F2> <Esc>:w!<CR>

nmap <F3> :q<CR>
imap <F3> <Esc>:q<CR>
vmap <F3> <Esc>:q<CR>

map <F4> :tabnew<CR>
imap <F4> <Esc>:tabnew<CR>
vmap <F4> <Esc>:tabnew<CR>

map <F5> :tabprev<CR>
imap <F5> <Esc>:tabprev<CR>
vmap <F5> <Esc>:tabprev<CR>

map <F6> :tabnext<CR>
imap <F6> <Esc>:tabnext<CR>
vmap <F6> <Esc>:tabnext<CR>