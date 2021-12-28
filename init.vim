" Tab and indent settings.
set autoindent
set smartindent

set expandtab
set smarttab

set shiftwidth=4
set softtabstop=4
set tabstop=4

" Directory for undo history.
set undodir=$HOME/.cache/nvim/undo
set undofile

""" Keyboard Shortcuts.
" Set the <leader> key.
:let mapleader = " "

""" Vim Plugins.
call plug#begin('~/.local/share/nvim/plugins')

Plug 'asvetliakov/vim-easymotion'

call plug#end()

""" (asvetliakov) Vim-EasyMotion Settings.
" Ignore case when searching for match.
let g:EasyMotion_smartcase = 1

" Allow typing of lowercase letters for uppercase letter jumps.
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'JKLFDSA['

" Jump to first match with enter or space.
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1

" Remap character/word searches.
nmap f <plug>(easymotion-fl)
nmap F <plug>(easymotion-Fl)
nmap t <plug>(easymotion-tl)
nmap T <plug>(easymotion-Tl)
nmap W <plug>(easymotion-wl)
nmap E <plug>(easymotion-el)
nmap B <plug>(easymotion-bl)
