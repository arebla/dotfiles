" File: ~/.vimrc

" Automatically reload the configuration file after saving it
autocmd! BufWritePost $MYVIMRC luafile %

" General options
set number relativenumber
set encoding=utf-8
" set clipboard=unnamedplus
set clipboard+=unnamedplus
set cursorline
set showcmd
set ruler
set nobackup
set noswapfile
set visualbell
set incsearch
set ignorecase

" Indentation options
set tabstop=4
set shiftwidth=4
set expandtab

let mapleader = ' '
let maplocalleader = ' '

" Mappings

" Map 'jk' to exit insert mode
inoremap jk <Esc>
" Map 'ññ' or ';;' to save the file
nnoremap ññ :w<CR>
nnoremap ;; :w<CR>
" Map 'bd' to close the current buffer
nnoremap bd :bd<CR>
" Map '\\' to clear the search highlight
nnoremap \\ :noh<CR>
" Map 'oo' to insert a line below and exit insert mode
nnoremap oo o<Esc>
" Map 'OO' to insert a line above and exit insert mode, then move down
nnoremap OO O<Esc>j
" Move down by visual line
nnoremap j gj
vnoremap j gj
" Move up by visual line
nnoremap k gk
vnoremap k gk

" Map <C-c> to copy the selected text to the system clipboard in visual mode
xnoremap <C-c> "*y

" Map <C-BS> and <C-H> to <C-W> in command-line mode
cnoremap <C-BS> <C-\><C-O>db
cnoremap <C-H> <C-\><C-O>db
inoremap <C-H> <C-\><C-O>db
inoremap <C-BS> <C-\><C-O>db

" Map <C-l> to correct previous spelling mistakes
inoremap <C-l> <C-g>u<Esc>[s1z=`]a<C-g>u
