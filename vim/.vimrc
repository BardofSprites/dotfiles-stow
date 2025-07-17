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
Plug 'zah/nim.vim'
call plug#end()
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

function! BardFindNotesFile()
  let l:cmd = "find ~/Notes/denote -type f -name '*.org' " .
        \ "! -path '*/.git/*' ! -path '*/.cache/*' | " .
        \ "grep -E './[0-9]{8}T[0-9]{6}--.*\\.org$'"
  call fzf#run(fzf#wrap({
        \ 'source': l:cmd,
        \ 'sink': 'e',
        \ 'options': '--prompt "Notes> " --preview "cat {}"'
        \ }))
endfunction

command! FindNotesFile call BardFindNotesFile()

function! BardSearchNotes()
  call fzf#vim#grep(
        \ "rg --column --line-number --no-heading --color=always " .
        \ "--hidden --glob '!**/.git/*' --glob '!**/.cache/*' " .
        \ "' ' ~/Notes/denote", 1,
        \ fzf#vim#with_preview(), 0)
endfunction

command! SearchNotes call BardSearchNotes()

" KEYBINDS
let mapleader = " "
nnoremap <Leader>fn :FindNotesFile<CR>
nnoremap <Leader>sn :SearchNotes<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>b  :Marks<CR>
