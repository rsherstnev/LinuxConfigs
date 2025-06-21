call plug#begin('~/.vim/plugins')
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': 'Files' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
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
set laststatus=2
set clipboard=unnamedplus

set t_Co=256
set background=dark
colorscheme iceberg "gruvbox habamax
let g:airline_theme='wombat'
let g:airline_detect_paste=1
"set statusline=%F\ %y\ %m\ %r\ %=Line:%l/%L\ Col:%c

autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

function! TogglePaste()
    if &paste
        set nopaste
        echo "🛑 Paste mode OFF"
    else
        set paste
        echo "✅ Paste mode ON"
    endif
endfunction

nnoremap <F1> :call TogglePaste()<CR>
inoremap <F1> <C-O>:call TogglePaste()<CR>
nnoremap <F2> :set list!<CR>
nnoremap <F3> :set number!<CR>