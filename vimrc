""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype settings are in '.vim/ftplugin'                      "
"          (b) Plugin settings are in '.vim/plugin'                          "
"          (c) Toggle folds using 'za'                                       "
"                                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" INITIALIZATION {{{

" Enable filetype detection, and filetype-based plugins and indents
filetype plugin indent on

" Enable syntax highlights
syntax enable

" Load the builtin matchit plugin (allows jumping among matching keywords using '%')
packadd! matchit

" Put all the swap files (with full path as name) at '~/.vim/.swap/'
set directory=~/.vim/.swap//

" }}}

" FORMATTING {{{

" Copy indent from current line when starting a new line
set autoindent

" While editing, count a <Tab> as 4 spaces
set softtabstop=4

" Use 4 spaces for each step of (auto)indent
set shiftwidth=4

" Replace tabs with spaces (unless forced using <C-V><Tab>)
set expandtab

" Allow backspacing over everything
set backspace=indent,eol,start

" Remove comment-leader when joining lines (using 'J')
set formatoptions+=j

" Unicode characters for list mode (show-up on ':set list')
set listchars=tab:»\ ,trail:·

" }}}

" BEHAVIOR {{{

" Wrap long lines
set linebreak

" When a line doesn't fit the screen, show 's@'s only at the end
set display=lastline

" Keep one extra line while scrolling (for context)
set scrolloff=1

" Keep 200 lines of command-line history
set history=200

" Enable mouse in all the modes
set mouse=a

" Time-out for key-codes in 50ms (leads to a faster <Esc>)
set ttimeoutlen=50

" Don't redraw screen while executing macros
set lazyredraw

" Behavioral autocommands
augroup vimrc_behavior
    " Clear the autocommands of this group
    autocmd!

    " Restore the last-known position on opening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ execute "normal! g'\"" | endif

    " Don't move the cursor to start-of-line when switching buffers
    autocmd BufLeave * set nostartofline |
                \ autocmd CursorMoved,CursorMovedI * set startofline |
                \ autocmd! vimrc_behavior CursorMoved,CursorMovedI

    " Automatically open quickfix/location windows when populated
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow

    " Make completions case-sensitive (assuming `ignorecase` is set)
    autocmd InsertEnter * set noignorecase
    autocmd InsertLeave * set ignorecase
augroup END

" }}}

" SHORTHANDS {{{

" Exit insert mode with 'jk'
inoremap jk <Esc>

" Expand '{<CR>' to a block and place cursor inside
inoremap {<CR> {<CR>}<Esc>O

" Auto-insert closing parenthesis
inoremap ( ()<Left>

" Skip over closing parenthesis
inoremap <expr> ) getline('.')[col('.')-1] == ")" ? "\<Right>" : ")"

" Surround selected text with parentheses using 'gsp'
xnoremap gsp c()<Esc>P

" Delete surrounding parentheses using 'dsp'
nnoremap dsp di(vabp

" Surround selected text with a block and re-indent using 'gsb'
xnoremap gsb c{<CR>}<Esc>P`[V`]=[{i<Space><Left>

" Delete surrounding block and re-indent using 'dsb'
nnoremap dsb "bdi{ddkdd"bP`[V`]=

" Copy till end of line using 'Y'
nnoremap Y y$

" Run macro from register 'q' using 'Q'
nnoremap Q @q

" Select previously changed/yanked text using 'gV'
nnoremap gV `[V`]

" Update buffer using ,w
nnoremap ,w :update<CR>

" Multipurpose ,q
"   - If multiple windows are open, closes the current window
"   - Else deletes the current buffer
function! MultiClose()
    if winnr('$') > 1
        close
    else
        bdelete
    endif
endfunction
nnoremap <silent> ,q :call MultiClose()<CR>

" Clear search highlights using \\ (handy with 'hlsearch')
nnoremap \\ :noh<CR>

" Toggles
"   - Spellcheck        : cos
"   - Paste             : cop
"   - List              : col
"   - Highlight matches : coh
"   - Background        : cob
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap cop :setlocal paste!<CR>:setlocal paste?<CR>
nnoremap col :setlocal list!<CR>:setlocal list?<CR>
nnoremap coh :setlocal hlsearch!<CR>:setlocal hlsearch?<CR>
nnoremap cob :set background=<C-R>=(&background=='dark'?'light':'dark')<CR><CR>

" }}}

" NAVIGATION {{{

" Enable switching buffers without saving them
set hidden

" Confirm before quitting vim with unsaved buffers
set confirm

" Ignore following patterns while expanding file-names
set wildignore+=tags,*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls

" Reduce the priority of following patterns while expanding file-names
set suffixes+=*.bib,*.log,*.jpg,*.png,*.dvi,*.ps,*.pdf

" Use <C-Z> to start wildcard-expansion in command-line mappings
set wildcharm=<C-Z>

" Search and open files recursively
"   - from current working directory     : ,e
"   - from the directory of current file : ,E
"   (press <C-A> to list and open multiple matching files)
nnoremap ,e :n **/*
nnoremap ,E :n <C-R>=fnameescape(expand('%:p:h'))<CR>/<C-Z><S-Tab>

" Switch buffer
"   - silently      : ,b
"   - after listing : ,f
nnoremap ,b :b <C-Z><S-Tab>
nnoremap ,f :ls<CR>:b<Space>

" Switch to alternate buffer using ,r
nnoremap ,r :b#<CR>

" Split buffer vertically using :vsb (:sb splits horizontallly)
cnoremap vsb vertical sb

" Bracket maps for cycling back-and-forth
"   - Buffers        : [b and ]b
"   - Quickfix lists : [q and ]q
"   - Location lists : [w and ]w
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [w :lprevious<CR>
nnoremap ]w :lnext<CR>

" Tags
"   - goto first match :  ,t
"   - list if multiple : ,lt
"   - show preview     : ,pt
nnoremap  ,t :tag /
nnoremap ,lt :tjump /
nnoremap ,pt :ptag /

" }}}

" COMPLETION {{{

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

" Select entry from completion-menu using <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

" Insert <Tab> after non-space characters using <S-Tab>
inoremap <S-Tab> <Space><Tab>

" }}}

" SEARCHING {{{

" Don't highlight matched items
set nohlsearch

" Show matches while typing the search-term
set incsearch

" Ignore case while searching, but act smartly with capitals
set ignorecase
set smartcase

" Grep
"   - standard     :  ,a
"   - current word : ,ca
if executable('rg')
    " If available, use 'ripgrep' as the grep-program
    set grepprg=rg\ --smart-case\ --vimgrep

    " Display column numbers as well
    set grepformat^=%f:%l:%c:%m

    " Define a 'Grep' command
    command! -nargs=+ Grep silent lgrep! <args> | redraw!
else
    " Use vimgrep
    command! -nargs=+ Grep silent lvimgrep /<args>/gj ** | redraw!
endif
nnoremap  ,a :Grep<Space>
nnoremap ,ca :Grep <C-R><C-W><CR>

" }}}

" COMMENTING {{{

" Toggle comments
"   - visual mode :  ,c
"   - normal mode : ,cc
function! ToggleComments() range
    " Get space-trimmed LHS-only commenstring
    let cmt_str = substitute(split(substitute(substitute(&commentstring, '\S\zs%s', ' %s', ''), '%s\ze\S', '%s ', ''), '%s', 1)[0], ' ', '', '')

    " Check if the first line is commented
    if match(getline('.'), cmt_str) == 0
        " Yes ==> uncomment
        execute a:firstline.",".a:lastline."s]^".cmt_str."]"
        execute "normal! ``"
    else
        " No ==> comment
        execute a:firstline.","a:lastline."s]^]".cmt_str
        execute "normal! ``"
    endif
endfunction
xnoremap  ,c :call ToggleComments()<CR>
nnoremap ,cc :call ToggleComments()<CR>

" }}}

" SESSIONS {{{

" Don't save options while saving sessions
set sessionoptions-=options

" Save session using ,ss
nnoremap ,ss :mksession! ~/.vim/.sessions/<C-Z><S-Tab>

" Open session using ,so
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

" UTILITIES {{{

" Netrw (Vim's builtin file manager)
"   - Open using '-'
"   - Disable the banner
"   - Hide './' and '../' entries
"   - Keep the alternate buffer
nnoremap - :Explore<CR>
let g:netrw_banner = 0
let g:netrw_list_hide = '^\.\.\=/$'
let g:netrw_altfile = 1

" Toggle a notepad window on the right using :Npad
command! Npad execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .npad'

" Tabularize selected text using ,t
xnoremap ,t :'<,'>!column -t<CR>

" Write a file with sudo when it was opened without, using :SudoWrite
command! SudoWrite w !sudo tee % > /dev/null

" Remove clutter using :DistractionFree
command! DistractionFree set nonumber | set norelativenumber | set laststatus=1 | set noruler | set nospell

" }}}

" APPEARANCE {{{

" Always display the statusline
set laststatus=2

" Show a ruler at bottom-right
set ruler

" Show line numbers
set number

" Show relative line numbers
set relativenumber

" Custom statusline with fugitive (if exists) and ruler
set statusline=%<\ %f\ %h%m%r\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" Show (partial) command in the last line of the screen
set showcmd

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

" ========================
" vim: set fen fdm=marker:
" ========================
