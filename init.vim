""" General Settings """
" Undo history.
set undofile
set undodir=$HOME/.cache/nvim/undo

" Timeout length.
set timeoutlen=1000

""" Keyboard Shortcuts """
" Set the <leader> key.
let mapleader = " "

" Shortcuts for escape.
inoremap jj <Esc>
inoremap ii <Esc>

" Clear highlights.
nnoremap <CR> :noh<CR><CR>

""" Vim Plug """
" VSCode flag.
let is_vscode = exists('g:vscode')
function! Cond(cond, ...)
  let l:opts = get(a:000, 0, {})
  return a:cond ? l:opts : extend(l:opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.local/share/nvim/plugins')

" VSCode NVim.
Plug 'asvetliakov/vim-easymotion', Cond(is_vscode, { 'as': 'vsc-easymotion' })

" Vanilla NVim.
Plug 'airblade/vim-gitgutter', Cond(!is_vscode)
Plug 'airblade/vim-rooter', Cond(!is_vscode)
Plug 'bronson/vim-trailing-whitespace', Cond(!is_vscode)
Plug 'christoomey/vim-tmux-navigator', Cond(!is_vscode)
Plug 'easymotion/vim-easymotion', Cond(!is_vscode)
Plug 'google/vim-codefmt', Cond(!is_vscode)
Plug 'google/vim-glaive', Cond(!is_vscode)
Plug 'google/vim-maktaba', Cond(!is_vscode)
Plug 'junegunn/fzf', Cond(!is_vscode, { 'do' : { -> fzf#install() } })
Plug 'junegunn/fzf.vim', Cond(!is_vscode)
Plug 'scrooloose/nerdcommenter', Cond(!is_vscode)
Plug 'tpope/vim-fugitive', Cond(!is_vscode)
Plug 'vim-airline/vim-airline', Cond(!is_vscode)

call plug#end()

""" (asvetliakov, easymotion) Vim EasyMotion Settings
" Ignore case when searching for match.
let g:EasyMotion_smartcase = 1

" Allow typing of lowercase letters for uppercase letter jumps.
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys = 'HJKLGFDSA['

" Jump to first match with enter or space.
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1

" Remap character/word searches.
nmap f <plug>(easymotion-bd-fl)
nmap F <plug>(easymotion-bd-f)
nmap t <plug>(easymotion-bd-tl)
nmap T <plug>(easymotion-bd-t)
nmap W <plug>(easymotion-bd-wl)
nmap E <plug>(easymotion-bd-el)
nmap B <plug>(easymotion-bl)
nmap K <plug>(easymotion-k)
nmap J <plug>(easymotion-j)

""" Context Specific NVim Settings """
if is_vscode
    """ VSCode NVim """

    """ Keyboard Shortcuts """
    " Save file.
    nnoremap <leader>w <Cmd>call VSCodeCall('workbench.action.files.save')<CR>

    " Close file.
    nnoremap <leader>d <Cmd>call VSCodeCall('workbench.action.closeActiveEditor')<CR>

else
    """ Vanilla NVim """

    """ General Settings """
    " Tab and indent settings.
    set autoindent
    set smartindent

    set expandtab
    set smarttab

    set shiftwidth=4
    set softtabstop=4
    set tabstop=4

    " Allow changing buffers with changes.
    set hidden

    " Always show signcolumns.
    set signcolumn=yes

    " Clear signcolumn color.
    highlight clear SignColumn

    " Show line numbers.
    set number
    set relativenumber

    " Refresh buffers that haven't been modified.
    " Trigger `autoread` when files changes on disk.
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

    " Notification after file change.
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost *
            \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

    """ Keyboard Shortcuts """
    " Shortcuts for quitting vim (only if no modifications have been made).
    nnoremap <C-c> :q<CR>

    " Toggle line numbers.
    nnoremap <leader>n :set nu!<CR>:set rnu!<CR>

    " Open file anywhere in line.
    nnoremap gf ^f/gf
    nnoremap <leader>f gf

    " Shortcuts for buffer navigation.
    nnoremap <Tab> :bn<CR>:redraw<CR>:GitGutter<CR>
    nnoremap <S-Tab> :bp<CR>:redraw<CR>:GitGutter<CR>
    nnoremap <leader>d :bd<CR>
    nnoremap <leader>w :FixWhitespace<CR>:update<CR>:GitGutter<CR>
    nnoremap <leader><leader>w :update<CR>:GitGutter<CR>

    " Toggle spellcheck.
    nnoremap <leader>c :call ToggleSpellCheck()<CR>
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

    """ Vim Plugins """

    """ (airblade) Vim GitGutter Settings
    " Sign column colors.
    let g:gitgutter_set_sign_backgrounds = 1

    " Shortcuts.
    nnoremap <leader>k :GitGutterPrevHunk<CR>
    nnoremap <leader>j :GitGutterNextHunk<CR>
    nnoremap <leader>u :GitGutterUndoHunk<CR>
    nnoremap <leader>s :GitGutterStageHunk<CR>
    nnoremap <leader>g :GitGutterFold<CR>

    """ (airblade) Vim Rooter Settings
    " Stop Rooter from echoing the project directory.
    let g:rooter_silent_chdir = 1

    """ (google) Vim Glaive Settings
    " Need following line for installing plugin.
    call glaive#Install()

    " Autoformat settings.
    Glaive codefmt
        \   plugin[mappings]=',='
        \   clang_format_executable='/bin/clang-format'
        \   clang_format_style='file'

    augroup autoformat
        autocmd!
        autocmd FileType bzl AutoFormatBuffer buildifier
        autocmd FileType c,cc,cpp,javascript AutoFormatBuffer clang-format
        autocmd FileType python AutoFormatBuffer autopep8
    augroup END

    """ (junegunn) FZF Settings
    nnoremap <leader>o :execute 'Files '.FindRootDirectory()<CR>
    nnoremap <leader>m :History<CR>
    nnoremap // :Ag<CR>

    """ (scrooloose) NERD Commenter Settings
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
    nmap <C-_> <plug>NERDCommenterToggle
    vmap <C-_> <plug>NERDCommenterToggle

    """ (tpope) Vim Fugitive Settings
    " Shortcuts.
    nnoremap <leader>b :Git blame<CR>

    """ (vim-airline) Vim Airline settings
    set laststatus=2
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme = 'dark'
endif
