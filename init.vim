""" General Settings.
set nocp
filetype plugin indent on

" Disable preview window.
set completeopt-=preview

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

" Mark text boundary.
set colorcolumn=120

" Refresh buffers that haven't been modified.
set autoread

" Use X Window clipboard to copy across vim sessions.
set clipboard=unnamedplus

" Enable spell checking.
set spell spelllang=en_us
highlight clear SpellBad
highlight SpellBad cterm=bold,reverse
highlight clear SpellCap
highlight clear SpellRare
highlight clear SpellLocal

" Enable 256 colors in vim.
set t_Co=256

" Remove pause when leaving insert mode.
set ttimeoutlen=10

" Change delay of diff to 1 sec.
set updatetime=250

" Close vim quick fix window if buffer closes (ie. will close vim if quick fix window is only window open).
aug QFClose
      au!
      au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

function! s:CombineSelection(line1, line2, cp)
    execute 'let char = "\u'.a:cp.'"'
    execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

""" Keyboard Shortcuts.
" Set the <leader> key.
:let mapleader = " "

" Shortcuts for escape.
noremap! kj <Esc>

" Shortcuts to clear search.
nnoremap <leader><leader> :noh<CR>:redraw<CR>

" Shortcuts for quitting vim (only if no modifications have been made).
nnoremap <C-c> :q<CR>

" Shortcuts for buffer navigation.
nnoremap <Tab> :bn<CR>:redraw<CR>:ls<CR>
nnoremap <S-Tab> :bn<CR>:redraw<CR>:ls<CR>
nnoremap kd :bd<CR>
nnoremap kf :update<CR>

""" Vim Plugins.
call plug#begin('~/.local/share/nvim/plugins')

Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-maktaba'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'tpope/vim-fugitive'
Plug 'unblevable/quick-scope'
Plug 'Valloric/ListToggle'
Plug 'Valloric/YouCompleteMe'

call plug#end()

""" Vim-GitGutter Settings.
nnoremap <leader><leader>gg <plug>GitGutter
nnoremap <leader><leader>ga <Plug>GitGutterPrevHunk
nnoremap <leader><leader>gs <Plug>GitGutterNextHunk
nnoremap <leader><leader>gd <Plug>GitGutterUndoHunk
nnoremap <leader><leader>gf <Plug>GitGutterStageHunk

""" Vim-Rooter Settings.
" Disable echoing project directory.
let g:rooter_silent_chdir = 1

""" Vim-Trailing-Whitespace Settings.
nnoremap <leader><leader>w :FixWhitespace<CR>:update<CR>

""" Vim-EasyMotion Settings.
" Remap trigger to single leader.
map <leader> <plug>(easymotion-prefix)

" Remap search (2 characters) to single key.
nmap s <plug>(easymotion-s2)

" Remap bidirectional searches.
nmap <leader>w <plug>(easymotion-bd-w)
nmap <leader>W <plug>(easymotion-bd-W)
nmap <leader>e <plug>(easymotion-bd-e)
nmap <leader>E <plug>(easymotion-bd-E)

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
    \   clang_format_executable='clang-format'
    \   clang_format_style='file'

augroup autoformat
    autocmd!
    " autocmd FileType bzl AutoFormatBuffer buildifier
    autocmd FileType c,cc,cpp,proto,javascript AutoFormatBuffer clang-format
    " autocmd FileType dart AutoFormatBuffer dartfmt
    " autocmd FileType go AutoFormatBuffer gofmt
    " autocmd FileType gn AutoFormatBuffer gn
    " autocmd FileType html,css,json AutoFormatBuffer js-beautify
    " autocmd FileType java AutoFormatBuffer google-java-format
    autocmd FileType python AutoFormatBuffer autopep8
augroup END

""" ListToggle Settings.
let g:lt_location_list_toggle_map = '<leader><leader>ll'

""" YCM Settings.
" YCM server python interpreter.
let g:ycm_server_python_interpreter = '/usr/bin/python2'

" Enable auto-completion in comments.
let g:ycm_complete_in_comments = 1

" Disable YCM confirmation on vim initialization.
let g:ycm_confirm_extra_conf = 0

" File types for which YCM should trigger.
let g:ycm_filetype_whitelist = {
    \   'c'     : 1,
    \   'cc'    : 1,
    \   'cpp'   : 1,
    \   'h'     : 1,
    \   'hh'    : 1,
    \   'hpp'   : 1
    \}
let g:ycm_filetype_specific_completion_to_disable = {
    \   'gitcommit' : 1,
    \   'txt'       : 1
    \}

" Number of auto-complete candidates.
let g:ycm_max_num_candidates = 20
let g:ycm_min_num_identifier_candidate_chars = 2

" Display symbols.
let g:ycm_error_symbol = '!'
let g:ycm_warning_symbol = '?'
