""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype-specific settings are in '.vim/ftplugin'             "
"          (b) Plugin-specific settings are in '.vim/plugin'                 "
"          (c) Toggle folds using 'za'                                       "
"                                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------------------------------------------------------------------------
" INITIALIZATION {{{
"-----------------------------------------------------------------------------

" Enable filetype detection, and filetype-based plugins and indents
filetype plugin indent on

" Enable syntax highlights
syntax enable

" Load the builtin matchit plugin (allows jumping among matching keywords using '%')
packadd! matchit

" }}}
"-----------------------------------------------------------------------------
" FORMATTING {{{
"-----------------------------------------------------------------------------

" Copy the indent of previous line
set autoindent

" While editing, count a <Tab> as 4 spaces
set softtabstop=4

" While changing indents with '<' and '>', use 4 spaces
set shiftwidth=4

" Replace tabs with spaces (unless forced using <C-V><Tab>)
set expandtab

" Backspace everything
set backspace=indent,eol,start

" Remove comment-leader when joining lines using 'J'
set formatoptions+=j

" Unicode characters for list mode (show up on ':set list')
set listchars=tab:»\ ,trail:·

" }}}
"-----------------------------------------------------------------------------
" BEHAVIOR {{{
"-----------------------------------------------------------------------------

" Wrap long lines
set linebreak

" Don't show '@'s when a line doesn't fit the screen
set display=lastline

" Keep one extra line while scrolling (for context)
set scrolloff=1

" Keep 200 lines of command-line history
set history=200

" Enable mouse in all the modes
set mouse=a

" Time-out for key codes up to 100ms
set ttimeout
set ttimeoutlen=100

" Behavioral autocommands
augroup vimrc_behavior
    " Clear the autocommands of this group
    autocmd!

    " Restore the last-known location on opening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ execute "normal! g'\"" | endif

    " Don't move the cursor to start-of-line when switching buffers
    autocmd BufLeave * set nostartofline |
                \ autocmd CursorMoved,CursorMovedI * set startofline |
                \ autocmd! vimrc_behavior CursorMoved,CursorMovedI

    " Automatically open quickfix/location windows when populated
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" }}}
"-----------------------------------------------------------------------------
" SHORTHANDS {{{
"-----------------------------------------------------------------------------

" Exit insert mode with 'jk'
inoremap jk <Esc>

" Expand '{<CR>' to a block and place cursor inside
inoremap {<CR> {<CR>}<Esc>O

" Auto-insert closing parenthesis
inoremap ( ()<Left>

" Skip over closing parenthesis
inoremap <expr> ) getline('.')[col('.')-1] == ")" ? "\<Right>" : ")"

" Surround selected text with parentheses using 'gsb'
xnoremap gsb c(<C-R>")<Esc>

" Copy till end of line using 'Y'
nnoremap Y y$

" Run macro from register 'q' with 'Q'
nnoremap Q @q

" Select recently pasted text using 'gV' (capital 'V')
"   (Note: 'gv' selects recently selected text by default)
nnoremap gV `[V`]

" Toggles
"   - Spellcheck        : cos
"   - Paste             : cop
"   - List              : col
"   - Search highlights : coh
"   - Background        : cob
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap cop :setlocal paste!<CR>:setlocal paste?<CR>
nnoremap col :setlocal list!<CR>:setlocal list?<CR>
nnoremap coh :setlocal hlsearch!<CR>:setlocal hlsearch?<CR>
nnoremap cob :set background=<C-R>=&background=='dark'?'light':'dark'<CR><CR>

" }}}
"-----------------------------------------------------------------------------
" NAVIGATION {{{
"-----------------------------------------------------------------------------

" Enable switching buffers without saving them
set hidden

" Confirm when quitting vim with unsaved buffers
set confirm

" Search for files in the directory of the current file, as well as recursively in the current directory (:pwd)
set path=.,**

" Ignore following file-types while expanding file-names
set wildignore+=*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls

" Use <C-Z> to start wildcard-expansion in command-line mappings
set wildcharm=<C-Z>

" Find file and edit
"   - in current window :  ,f
"   - in a split        : ,sf
"   - in a vsplit       : ,vf
nnoremap  ,f :find *
nnoremap ,sf :sfind *
nnoremap ,vf :vert sfind *

" Buffers
"   - switch           :  ,b
"       - in a split   : ,sb
"       - in a vsplit  : ,vb
"   - list and switch  : ,lb
"   - alternate buffer :  ,r
"   - previous buffer  :  [b
"   - next buffer      :  ]b
"   - update buffer    :  ,w
"   - delete buffer    :  ,q
nnoremap  ,b :b <C-Z><S-Tab>
nnoremap ,sb :sb <C-Z><S-Tab>
nnoremap ,vb :vert sb <C-Z><S-Tab>
nnoremap ,lb :ls<CR>:b<Space>
nnoremap  ,r :b#<CR>
nnoremap  [b :bprevious<CR>
nnoremap  ]b :bnext<CR>
nnoremap  ,w :update<CR>
nnoremap  ,q :bdelete<CR>

" Goto tag
"   - first match      :  ,t
"   - list if multiple : ,lt
"   - preview the tag  : ,pt
nnoremap  ,t :tag /
nnoremap ,lt :tjump /
nnoremap ,pt :ptag /

" Switch among quickfix entries using [q and ]q
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>

" }}}
"-----------------------------------------------------------------------------
" COMPLETION {{{
"-----------------------------------------------------------------------------

" Visual completion for command-menu
set wildmenu

" Ignore case in command-line completion
set wildignorecase

" Don't complete from included files
set complete-=i

" Use <Tab> for clever insert-mode completion
function! CleverTab() abort
    " If completion-menu is visible, keep scrolling
    if pumvisible()
        return "\<C-N>"
    endif

    let str = matchstr(strpart(getline('.'), 0, col('.')-1), '[^ \t]*$')
    if empty(str)
        " After spaces, return the <Tab> literal
        return "\<Tab>"
    else
        if match(str, '\/') != -1
            " File-completion on seeing a '/'
            return "\<C-X>\<C-F>"
        else
            " Complete based on the 'complete' option
            return "\<C-P>"
        endif
    endif
endfunction
inoremap <silent> <Tab> <C-R>=CleverTab()<CR>

" Select an entry from the completion-menu using <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

" Insert <Tab> after non-space characters using Shift-Tab
inoremap <S-Tab> <Space><Tab>

" }}}
"-----------------------------------------------------------------------------
" SEARCHING {{{
"-----------------------------------------------------------------------------

" Don't highlight matched items
set nohlsearch

" Show matches while typing the search-term
set incsearch

" Ignore case while searching, but act smartly with capitals
set ignorecase
set smartcase

if executable('rg')
    " If available, use 'ripgrep' as the grep-program
    set grepprg=rg\ --smart-case\ --vimgrep

    " Display column numbers as well
    set grepformat^=%f:%l:%c:%m

    " Define a 'Grep' command
    command! -nargs=+ Grep silent grep! <args> | redraw!

    " Grep
    "   - standard     :  ,a
    "   - current word : ,ca
    nnoremap  ,a :Grep<Space>
    nnoremap ,ca :Grep <C-R><C-W><CR>
endif

" }}}
"-----------------------------------------------------------------------------
" COMMENTING {{{
"-----------------------------------------------------------------------------

" Toggle comments
"   - normal mode : ,cc
"   - visual mode :  ,c
function! ToggleComments() range
    " Get a space-trimmed commenstring
    let cmt_str = substitute(split(substitute(substitute(&commentstring, '\S\zs%s', ' %s', ''), '%s\ze\S', '%s ', ''), '%s', 1)[0], ' ', '', '')

    " Check if the first line is already commented
    if match(getline('.'), cmt_str) == 0
        " Yes ==> uncomment mode
        execute a:firstline.",".a:lastline . "s]^" . cmt_str . "]"
        execute "normal! ``"
    else
        " No ==> comment mode
        execute a:firstline.","a:lastline . "s]^]" . cmt_str
        execute "normal! ``"
    endif
endfunction
nnoremap ,cc :call ToggleComments()<CR>
xnoremap  ,c :call ToggleComments()<CR>

" }}}
"-----------------------------------------------------------------------------
" SESSIONS {{{
"-----------------------------------------------------------------------------

" Don't save options while saving sessions
set sessionoptions-=options

" Save a session using ,ss
nnoremap ,ss :mksession! ~/.vim/.sessions/<C-Z><S-Tab>

" Open a session using ,so
nnoremap ,so :source ~/.vim/.sessions/<C-Z><S-Tab>

" Automatically save session before leaving vim
augroup vimrc_session
    autocmd!
    autocmd VimLeavePre * if !empty(v:this_session) |
                \ execute "mksession! " . fnameescape(v:this_session) |
                \ else | mksession! ~/.vim/.sessions/previous.vim | endif
augroup END

" Restore previous session using ,sp
nnoremap <silent> ,sp :source ~/.vim/.sessions/previous.vim<CR>

" }}}
"-----------------------------------------------------------------------------
" UTILITIES {{{
"-----------------------------------------------------------------------------

" Toggle a notepad window using ,x
function! ToggleNotepad()
    let scr_winnr = bufwinnr('.notepad')
    if scr_winnr != -1
        execute scr_winnr . 'close'
    else
        execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .notepad'
    endif
endfunction
nnoremap <silent> ,x :call ToggleNotepad()<CR>

" Tabularize selected text using ,t
xnoremap ,t :'<,'>!column -t<CR>

" Write a file with sudo when it was opened without, using :SudoWrite
command! SudoWrite w !sudo tee % > /dev/null

" Remove clutter using :DistractionFree
command! DistractionFree set nonumber | set norelativenumber | set laststatus=1 | set noruler | set nospell

" }}}
"-----------------------------------------------------------------------------
" APPEARANCE {{{
"-----------------------------------------------------------------------------

" Display statusline all the time
set laststatus=2

" Show a ruler at right-bottom
set ruler

" Show line numbers
set number

" Show relative line numbers
set relativenumber

" Custom statusline with fugitive and ruler
set statusline=%<\ %f\ %h%m%r\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" Different cursor shapes in different modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Highlight current line in the active window
augroup vimrc_cursorline
    autocmd!
    autocmd VimEnter * set cursorline
    autocmd WinEnter * if &filetype != "qf" && !&diff | set cursorline | endif
    autocmd WinLeave * set nocursorline
augroup END

" Use seoul colorscheme
colorscheme seoul

" }}}
"-----------------------------------------------------------------------------
" vim: set fen fdm=marker:
"-----------------------------------------------------------------------------
