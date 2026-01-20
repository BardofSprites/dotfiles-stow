syntax enable
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set noesckeys
set relativenumber
set number
set ignorecase
set smartcase
set incsearch
set modeline
set nohlsearch

autocmd FileType org,outline setlocal nofoldenable
call plug#begin()
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'ap/vim-css-color'
call plug#end()

" KEYBINDS
let mapleader = " "
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>d :Ex<CR>
