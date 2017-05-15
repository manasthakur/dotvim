""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype settings are in 'after/ftplugin'                     "
"          (b) Plugins reside in 'pack/bundle'                               "
"          (c) Toggle folds using 'za'                                       "
"                                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" INITIALIZATION {{{

" Enable filetype detection, and filetype-based plugins and indents
filetype plugin indent on

" Enable syntax highlights
syntax enable

" Load the builtin matchit plugin (allows jumping among matching keywords using '%')
if !has('nvim')
    runtime! matchit
endif

" Clear autocommands
augroup vimrc
    autocmd!
augroup END

" Python location for Neovim
if has('nvim')
    if has('mac')
        let g:python_host_prog = '/usr/local/bin/python'
        let g:python3_host_prog = '/usr/local/bin/python3'
    else
        let g:python_host_prog = '/usr/bin/python'
        let g:python3_host_prog = '/usr/bin/python3'
    endif
endif

" }}}

" FORMATTING {{{

" Copy the indent of current line when starting a new line
set autoindent

" Count existing tabs as 4 spaces
set tabstop=4

" Backspace over 4 characters; further, treat a <Tab> literal as 4 spaces
set softtabstop=4

" Use 4 spaces for each step of (auto)indent
set shiftwidth=4

" Replace tabs with spaces
set expandtab

" Allow backspacing over all characters
set backspace=indent,eol,start

" Remove comment-leader when joining lines (using 'J')
set formatoptions+=j

" Unicode characters for list mode (show up on ':set list')
set listchars=tab:»\ ,trail:·

" }}}

" BEHAVIOR {{{

" Wrap long lines
set linebreak

" When a line doesn't fit the screen, show '@'s only at the end
set display=lastline

" Keep one extra line while scrolling (for context)
set scrolloff=1

" Show substitution effects while typing
if has('nvim')
    set inccommand=nosplit
endif

" Enable mouse in all the modes
set mouse=a

" Time-out for key-codes in 50ms (leads to a faster <Esc>)
set ttimeoutlen=50

" Behavioral autocommands
augroup vimrc
    " On opening a file, restore the last-known position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ execute "normal! g'\"" | endif

    " Don't move the cursor to start-of-line when switching buffers
    autocmd BufLeave * set nostartofline |
                \ autocmd CursorMoved,CursorMovedI * set startofline |
                \ autocmd! vimrc CursorMoved,CursorMovedI

    " Make insert-mode completions case-sensitive
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

" Copy till end of line using 'Y'
nnoremap Y y$

" Run macro from register 'q' using 'Q'
nnoremap Q @q

" Select previously changed/yanked text using 'gV'
nnoremap gV `[V`]

" Update buffer using ,w
nnoremap ,w :update<CR>

" Multipurpose ,q
function! MultiClose()
    " If there are multiple windows, close the current one
    if winnr('$') > 1
        close
    else
        if tabpagenr('$') > 1
            " If there are multiple tabs and there is an alternate buffer,
            " restore the alternate buffer and keep the tab
            let alt_buf = bufnr('#')
            if alt_buf > 0 && buflisted(alt_buf)
                buffer # | bdelete #
            else
                bdelete
            endif
        else
            " Force delete a terminal tab (in Neovim)
            if &buftype == 'terminal'
                bdelete!
            else
                bdelete
            endif
        endif
    endif
endfunction
nnoremap <silent> ,q :call MultiClose()<CR>

" Toggle a notepad window on the right using :Npad
command! Npad execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .npad'

" Write a file with sudo when it was opened without, using :SudoWrite
command! SudoWrite w !sudo tee % > /dev/null

" Tabularize selected text using ,t
xnoremap ,t :'<,'>!column -t<CR>

" Toggles
"   - Number            : con
"   - Relative number   : cor
"   - Spellcheck        : cos
"   - List              : col
"   - Highlight matches : coh
"   - Background        : cob
nnoremap con :setlocal number!<CR>:setlocal number?<CR>
nnoremap cor :setlocal relativenumber!<CR>:setlocal relativenumber?<CR>
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
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

" Use <C-z> to start wildcard-expansion in command-line mappings
set wildcharm=<C-z>

" Search and open files recursively
"   - from current working directory     : ,e
"   - from the directory of current file : ,E
"   (press <C-A> to list and open multiple matching files)
nnoremap ,e :n **/*
nnoremap ,E :n <C-R>=fnameescape(expand('%:p:h'))<CR>/<C-z><S-Tab>

" Switch buffer
"   - silently      : ,b
"   - in a split    : ,sb
"   - in a vsplit   : ,vb
"   - after listing : ,f
nnoremap  ,b :b <C-z><S-Tab>
nnoremap ,sb :sb <C-z><S-Tab>
nnoremap ,vb :vertical sb <C-z><S-Tab>
nnoremap  ,f :ls<CR>:b<Space>

" Switch to alternate buffer using ,r
nnoremap ,r :b#<CR>

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

" Neovim-specific mappings
if has('nvim')
    " Split a terminal using ALT+s,v; tabedit a terminal using ALT+t
    nnoremap <A-s> :split <bar> terminal<CR>
    nnoremap <A-v> :vsplit <bar> terminal<CR>
    nnoremap <A-t> :tabedit <bar> terminal<CR>

    " Exit terminal mode using <Esc>
    tnoremap <A-\> <C-\><C-n>

    " Switch splits using ALT+h,j,k,l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><c-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l

    " Switch tabs using <A-[> and <A-]>
    nnoremap <A-[> gt
    nnoremap <A-]> gT
    tnoremap <A-[> <C-\><C-n>gt
    tnoremap <A-]> <C-\><C-n>gT

    " Automatically switch to insert mode in terminal windows
    augroup vimrc
        autocmd WinEnter term://* startinsert
    augroup END
endif

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
        return "\<C-n>"
    endif

    let str = matchstr(strpart(getline('.'), 0, col('.')-1), '[^ \t]*$')
    if empty(str)
        " After spaces, return the <Tab> literal
        return "\<Tab>"
    else
        if match(str, '\/') != -1
            " File-completion on seeing a '/'
            return "\<C-x>\<C-f>"
        else
            " Complete based on the 'complete' option
            return "\<C-p>"
        endif
    endif
endfunction
inoremap <silent> <Tab> <C-r>=CleverTab()<CR>

" Select entry from completion-menu using <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <S-Tab> for reverse-completion, and to insert tabs after non-space characters
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "<Space><Tab>"

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
    command! -nargs=+ Grep silent lgrep! <args> | lwindow | redraw!
else
    " Use vimgrep
    command! -nargs=+ Grep silent lvimgrep /<args>/gj ** | lwindow | redraw!
endif
nnoremap  ,a :Grep<Space>
nnoremap ,ca :Grep <C-r><C-w><CR>

" Better global searches
"   - standard     :  ,g
"   - current word : ,cg
function! GlobalSearch(...) abort
    " If no pattern was supplied, prompt for one
    if a:0 == 0
        let pattern = input(':g/')
    else
        let pattern = a:1
    endif
    if !empty(pattern)
        " Print lines matching the pattern, with line-numbers
        execute "g/" . pattern . "/#"
        " The valid value of 'choice' is a line-number
        let choice = input(':')
        if !empty(choice)
            " Jump to the entered line-number
            execute choice
        else
            " If no choice was entered, restore the cursor position
            execute "normal! \<C-o>"
        endif
    endif
endfunction
nnoremap <silent>  ,g :call GlobalSearch()<CR>
nnoremap <silent> ,cg :call GlobalSearch("<C-r><C-w>")<CR>

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
nnoremap ,ss :mksession! ~/.vim/.sessions/<C-z><S-Tab>

" Open session using ,so
nnoremap ,so :source ~/.vim/.sessions/<C-z><S-Tab>

" Automatically save session before leaving vim
augroup vimrc
    autocmd VimLeavePre * if !empty(v:this_session) |
                \ execute "mksession! " . fnameescape(v:this_session) |
                \ else | mksession! ~/.vim/.sessions/previous.vim | endif
augroup END

" Restore previous session using ,sp
nnoremap <silent> ,sp :source ~/.vim/.sessions/previous.vim<CR>

" }}}

" PLUGINS {{{

" Netrw (Vim's builtin file manager)
"   - Open using '-'
nnoremap - :Explore<CR>
"   - Disable the banner
let g:netrw_banner = 0
"   - Hide './' and '../' entries
let g:netrw_list_hide = '^\.\.\=/$'
"   - Keep the alternate buffer
let g:netrw_altfile = 1

" UltiSnips (Snippet manager)
"   - Use custom snippet-diretory
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']
"   - Fire a snippet using <C-j>
let g:UltiSnipsExpandTrigger='<C-j>'
"   - List available snippets using <C-k>
let g:UltiSnipsListSnippets='<C-k>'

" }}}

" APPEARANCE {{{

" Show position at bottom-right
set ruler

" Display statusline all the time
set laststatus=2

" Custom statusline with Fugitive (if exists) and ruler
set statusline=%<%f\ %h%m%r\%{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" No cursorline in diff, quickfix, and inactive windows
augroup vimrc
    autocmd VimEnter * set cursorline
    autocmd WinEnter * if &filetype != "qf" && !&diff | set cursorline | endif
    autocmd WinLeave * set nocursorline
augroup END

" Default colorscheme
colorscheme solarized

" }}}

" ========================
" vim: set fen fdm=marker:
" ========================
