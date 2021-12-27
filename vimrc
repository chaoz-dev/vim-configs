""" General Settings.
set nocp
filetype plugin indent on

" Copy to clipboard.
set clipboard^=unnamed

" Allow changing buffers with changes.
set hidden

" Always show signcolumns.
set signcolumn=yes

" Set backspace behavior to work as expected.
set backspace=indent,eol,start

" Show line numbers.
set number
set relativenumber

" Tab and indent settings.
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Refresh buffers that haven't been modified.
set autoread

" Make directory function.
let s:vim_cache_dir=$HOME."/.cache/vim"
function! s:make_dir(dir)
    if !isdirectory(a:dir)
        call mkdir(a:dir, "p", 0700)
    endif
endfunction

" Directory for undo history.
let s:undo_dir=s:vim_cache_dir."/undo//"
call s:make_dir(s:undo_dir)

let &undodir=s:undo_dir
set undofile

" Directory for swap files.
let s:swap_dir=s:vim_cache_dir."/swap//"
call s:make_dir(s:swap_dir)

let &directory=s:swap_dir

" Directory for backup files.
let s:backup_dir=s:vim_cache_dir."/backup//"
call s:make_dir(s:backup_dir)

let &backupdir=s:backup_dir

" Enable 256 colors in vim.
set t_Co=256

" Remove pause when leaving insert mode.
set ttimeoutlen=10

" Change delay of diff to 1 sec.
set updatetime=250

" Highlight on search.
set hlsearch

" Close vim quick fix window if buffer closes (ie. will close vim if quick fix window is only window open).
aug QFClose
      au!
      au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

function! s:CombineSelection(line1, line2, cp)
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

""" Change cursor shape depending on mode.

" Terminal for MacOS.
" Cursor settings:
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)

""" Keyboard Shortcuts.
" Set the <leader> key.
:let mapleader = " "

" Shortcuts for escape.
inoremap jj <Esc>

" Shortcuts to clear search.
nnoremap <leader><leader><leader> :noh<CR>:redraw<CR>

" Shortcuts for quitting vim (only if no modifications have been made).
nnoremap <C-c> :q<CR>

" Shortcuts for buffer navigation.
nnoremap <Tab> :bn<CR>:redraw<CR>
nnoremap <S-Tab> :bp<CR>:redraw<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>w :FixWhitespace<CR>:update<CR>
nnoremap <leader><leader>w :update<CR>

" Toggle spellcheck.
nnoremap <leader><leader>s :call ToggleSpellCheck()<CR>

function! ToggleSpellCheck()
    set spell! spelllang=en_us
    highlight clear SpellBad
    highlight SpellBad cterm=bold,reverse
    highlight clear SpellCap
    highlight clear SpellRare
    highlight clear SpellLocal

    if &spell
        echo "Spell Check ON"
    else
        echo "Spell Check OFF"
    endif
endfunction

""" Vim Plugins.
call plug#begin('$HOME/.vim/plugins')

Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-maktaba'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lfv89/vim-interestingwords'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'

call plug#end()

""" Vim-GitGutter Settings.
" Shortcuts.
nmap gk <Plug>(GitGutterPrevHunk)
nmap gj <Plug>(GitGutterNextHunk)
nmap gu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterStageHunk)

""" Vim-Rooter Settings.
" Disable echoing project directory.
let g:rooter_silent_chdir = 1

""" Vim-EasyMotion Settings.
" Remap trigger to single leader.
map <leader> <plug>(easymotion-prefix)

" Remap search (2 characters) to single key.
nmap s <plug>(easymotion-s2)

" Remap character/word searches.
nmap f <plug>(easymotion-bd-fl)
nmap t <plug>(easymotion-bd-tl)
nmap W <plug>(easymotion-wl)
nmap E <plug>(easymotion-el)
nmap B <plug>(easymotion-bl)

" Search smartcase.
let g:EasyMotion_smartcase = 1

" Enable fuzzy search.
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

""" Vim-Glaive Settings.
" Need following line for installing plugin.
call glaive#Install()

" Autoformat settings.
Glaive codefmt
    \   plugin[mappings]=',='
    \   clang_format_executable='/bin/clang-format'
    \   clang_format_style='file'

augroup autoformat
    autocmd!
    " autocmd FileType bzl AutoFormatBuffer buildifier
    autocmd FileType c,cc,cpp,javascript AutoFormatBuffer clang-format
    " autocmd FileType dart AutoFormatBuffer dartfmt
    " autocmd FileType go AutoFormatBuffer gofmt
    " autocmd FileType gn AutoFormatBuffer gn
    " autocmd FileType html,css,json AutoFormatBuffer js-beautify
    " autocmd FileType java AutoFormatBuffer google-java-format
    autocmd FileType python AutoFormatBuffer autopep8
augroup END

""" NERD Commenter Settings.
" Allow commenting and inverting of empty lines (useful when commenting code).
let g:NERDCommentEmptyLines = 1

" Disable all default mappings.
let g:NERDCreateDefaultMappings = 0

" Disable uncommenting of lines with alternative commenting styles.
let g:NERDRemoveAltComs = 0

" Add spaces after comment delimiters by default.
let g:NERDSpaceDelims = 1

" Enable trimming of trailing whitespace when uncommenting.
let g:NERDTrimTrailingWhitespace = 1

" Use compact syntax for prettified multi-line comments.
let g:NERDCompactSexyComs = 1

" Enable NERDCommenterToggle to check if all selected lines are commented or not.
let g:NERDToggleCheckAllLines = 1

" Shortcuts.
nmap // <plug>NERDCommenterToggle
vmap // <plug>NERDCommenterToggle

""" FZF Settings.
nmap <C-m> :History<CR>

""" Vim-Fugitive Settings.
" Shortcuts.
nnoremap <leader><leader>g :Git blame<CR>

""" Vim-Airline Settings
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'
