""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype settings are in 'after/ftplugin'                     "
"          (b) Plugins reside in 'pack/bundle'                               "
"          (c) Toggle folds using 'za'                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 1. INITIALIZATION {{{

" Enable filetype detection, and filetype-based plugins and indentation
filetype plugin indent on

" Enable syntax highlights
syntax enable

" Load the builtin matchit plugin (allows jumping among matching keywords using %)
runtime macros/matchit.vim

" Put all the swap files (with full path as name) at '~/.vim/.swap/'
set directory=~/.vim/.swap//

" Don't create backup files
set nobackup

" Clear autocommands
augroup vimrc
    autocmd!
augroup END

" Change the default flavor for LaTeX files (affects 'filetype')
let g:tex_flavor = "latex"

" Disable netrw (using dirvish instead)
let g:loaded_netrwPlugin = 1

" }}}

" 2. FORMATTING {{{

" Copy the indent of current line when starting a new line
set autoindent

" Count existing tabs as 4 spaces
set tabstop=4

" Backspace over 4 characters; further, treat a TAB literal as 4 spaces
set softtabstop=4

" Use 4 spaces for each step of (auto)indent
set shiftwidth=4

" Allow backspacing over all characters
set backspace=indent,eol,start

" Remove comment-leader when joining lines (using J)
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

" Characters for list mode (show up on ':set list')
set listchars=tab:>\ ,trail:-

" }}}

" 3. BEHAVIOR {{{

" Wrap long lines
set linebreak

" When a line doesn't fit the screen, show '@'s only at the end
set display=lastline

" Keep cursor off by a line while scrolling (for context)
set scrolloff=1

" Draw the screen lazily (speeds up scroll and macro-execution)
set lazyredraw

" Keep 1000 lines of command-line history
set history=1000

" Enable mouse in all the modes
set mouse=a

" Time-out for key-codes in 50ms (leads to a faster ESC)
set ttimeoutlen=50

" On opening a file, restore the last-known position
autocmd vimrc BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
            \ execute "normal! g'\"" | endif

" Don't move the cursor to start-of-line when switching buffers
autocmd vimrc BufLeave * set nostartofline |
            \ autocmd CursorMoved,CursorMovedI * set startofline |
            \ autocmd! vimrc CursorMoved,CursorMovedI

" Make insert-mode completions case-sensitive
autocmd vimrc InsertEnter * set noignorecase
autocmd vimrc InsertLeave * set ignorecase

" Automatically open quickfix/location windows when populated
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost l* lwindow

" }}}

" 4. SHORTHANDS {{{

" Exit insert and select modes using jk
inoremap jk <Esc>
snoremap jk <Esc>

" Auto-insert closing parenthesis/brace
inoremap ( ()<Left>
inoremap { {}<Left>

" Auto-delete closing parenthesis/brace
function! BetterBackSpace() abort
    let cur_line = getline('.')
    let before_char = cur_line[col('.')-2]
    let after_char = cur_line[col('.')-1]
    if (before_char == '(' && after_char == ')') || before_char == '{' && after_char == '}'
        return "\<Del>\<BS>"
    else
        return "\<BS>"
endfunction
inoremap <silent> <BS> <C-r>=BetterBackSpace()<CR>

" Skip over closing parenthesis/brace
inoremap <expr> ) getline('.')[col('.')-1] == ")" ? "\<Right>" : ")"
inoremap <expr> } getline('.')[col('.')-1] == "}" ? "\<Right>" : "}"

" Intelligent ENTER
"   - selects entry in completion menu
"   - expands block if the next character is '}'
"   - works normally otherwise
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : ((getline('.')[col('.')-1] == '}') ? "\<CR>\<C-o>O" : "\<C-g>u\<CR>")

" Copy selected text and paste it indented using CTRL-k
xnoremap <C-k> "xc
inoremap <C-k> <Esc>"_dd"xP=']']A

" Scroll without moving the cursor using CTRL-j and CTRL-k
nnoremap <C-j> j<C-e>
nnoremap <C-k> k<C-y>

" Copy till end-of-line using Y
nnoremap Y y$

" Execute macro from register q using Q
nnoremap Q @q

" Select previously changed/yanked text using gV
nnoremap gV '[V']

" Delete surrounding brace-construct using dsc
nnoremap dsc diB"_ddk"_ddP=`]

" Paste and indent using =p and =P
nnoremap =p p'[V']=
nnoremap =P P'[V']=

" Copy selected text to system-clipboard using Y
xnoremap Y "+y

" Search selected text using *
xnoremap * "xy/\V<C-r>x<CR>

" Toggle a .npad window on the right using :Npad
command! Npad execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .npad'

" Write a file with sudo when it was opened without using :SudoWrite
command! SudoWrite w !sudo tee % > /dev/null

" Toggles
"   - Number            : con
"   - Relative number   : cor
"   - Spellcheck        : cos
"   - Paste             : cop
"   - List              : col
"   - Highlight matches : coh
nnoremap con :setlocal number!<CR>:setlocal number?<CR>
nnoremap cor :setlocal relativenumber!<CR>:setlocal relativenumber?<CR>
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap cop :setlocal paste!<CR>:setlocal paste?<CR>
nnoremap col :setlocal list!<CR>:setlocal list?<CR>
nnoremap coh :setlocal hlsearch!<CR>:setlocal hlsearch?<CR>

" }}}

" 5. NAVIGATION {{{

" Enable switching buffers without saving them
set hidden

" Confirm before quitting vim with unsaved buffers
set confirm

" Update buffer using ,w
nnoremap ,w :update<CR>

" Ignore following patterns while expanding file-names
set wildignore+=tags,*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls

" Reduce the priority of following patterns while expanding file-names
set suffixes+=*.bib,*.log,*.jpg,*.png,*.dvi,*.ps,*.pdf

" Use CTRL-z to start wildcard-expansion in command-line mappings
set wildcharm=<C-z>

" Search recursively and open files
"   - from the current working directory : ,e
"   - from the directory of current file : ,E
"   (press CTRL-a to list and open multiple matching files)
nnoremap ,e :n **/*
nnoremap ,E :n <C-R>=fnameescape(expand('%:p:h'))<CR>/**/*

" Switch buffer
"   - without listing : ,b
"   - after listing   : ,f
nnoremap ,b :b <C-z><S-Tab>
nnoremap ,f :ls<CR>:b<Space>

" Open a buffer in a vsplit using :vsb
" (:sb does the same in a split)
cnoremap vsb vertical sb

" Switch to alternate buffer using ,r
nnoremap ,r :b#<CR>

" Use <Space> to access window-navigation shortcuts
nnoremap <Space> <C-w>

" Bracket maps to cycle back-and-forth
"   - Buffers        : [b and ]b
"   - Tabs           : [t and ]t
"   - Quickfix lists : [q and ]q
"   - Location lists : [w and ]w
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [w :lprevious<CR>
nnoremap ]w :lnext<CR>

" Tags
"   - goto first match : ,t
"       - current word : ,T
"   - list if multiple : ,y
"       - current word : ,Y
"   - show preview     : ,p
"       - current word : ,P
nnoremap ,t :tag /
nnoremap ,T :tag <C-r><C-w><CR>
nnoremap ,y :tjump /
nnoremap ,Y :tjump <C-r><C-w><CR>
nnoremap ,p :ptag /
nnoremap ,P :ptag <C-r><C-w><CR>

" }}}

" 6. COMPLETION {{{

" Visual completion in the command-line
set wildmenu

" Ignore case in command-line completion
if exists('&wildignorecase')
    set wildignorecase
endif

" Don't complete from included files
set complete-=i

" Use TAB for clever insert-mode completion
function! CleverTab() abort
    " If completion-menu is visible, keep scrolling
    if pumvisible()
        return "\<C-n>"
    endif
    " Determine the pattern before the cursor
    let str = matchstr(strpart(getline('.'), 0, col('.')-1), '[^ \t]*$')
    if empty(str)
        " After spaces, return the TAB literal
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

" Use SHIFT-TAB for traversing the completion-menu in reverse, and to insert tabs after non-space characters
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "<Space><Tab>"

" }}}

" 7. SEARCHING {{{

" Don't highlight matched items
set nohlsearch

" Show the next match while typing the search-term
set incsearch

" Ignore case while searching, but act smartly with capitals
set ignorecase
set smartcase

" Grep
"   - prompt       : ,a
"   - current word : ,A
if executable('rg')
    " If available, use 'ripgrep' as the grep-program
    set grepprg=rg\ --smart-case\ --vimgrep

    " Display column numbers as well
    set grepformat^=%f:%l:%c:%m

    " Define a 'Grep' command
    command! -nargs=+ Grep silent lgrep! <args> | lwindow | redraw!
else
    " Use vimgrep in the 'Grep' command
    command! -nargs=+ Grep silent lvimgrep /<args>/gj ** | lwindow | redraw!
endif
nnoremap ,a :Grep<Space>
nnoremap ,A :Grep <C-r><C-w><CR>

" Better global searches
"   - prompt       : ,g
"   - current word : ,G
function! GlobalSearch(...) abort
    " If no pattern was supplied, prompt for one
    if a:0 == 0
        let pattern = input(':g/')
    else
        let pattern = a:1
    endif
    if !empty(pattern)
        " Print lines matching the pattern (along with line-numbers)
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
nnoremap <silent> ,g :call GlobalSearch()<CR>
nnoremap <silent> ,G :call GlobalSearch("<C-r><C-w>")<CR>

" }}}

" 8. COMMENTING {{{

" Easy comment toggles
"	- gc  : operator
"	- gcc : linewise
function! CommentToggle(type, ...)
  " Get the list of comment-markers
  let cmt_markers = split(substitute(substitute(&commentstring, '\S\zs%s', ' %s', ''), '%s\ze\S', '%s ', ''), '%s', 1)

  " Get space-trimmed LHS and RHS comment-markers
  let lhs_cmt_marker = substitute(cmt_markers[0], ' ', '', '')
  let rhs_cmt_marker = substitute(cmt_markers[1], ' ', '', '')

  " Check if the first line is commented
  if match(getline('.'), lhs_cmt_marker) == 0
    " Yes ==> uncomment
    if a:0
      " Visual mode
      silent execute "normal! :'<,'>s]^" . lhs_cmt_marker . "]\<CR>`<"
      silent execute "normal! :'<,'>s]" . rhs_cmt_marker . "$]]\<CR>`<"
    else
      " Normal mode
      silent execute "normal! :'[,']s]^" . lhs_cmt_marker . "]\<CR>`["
      silent execute "normal! :'[,']s]" . rhs_cmt_marker . "$]]\<CR>`["
    endif
  else
    " No ==> comment
    if a:0
      " Visual mode
      silent execute "normal! :'<,'>s]^]" . lhs_cmt_marker . "\<CR>`<"
      silent execute "normal! :'<,'>s]$]" . rhs_cmt_marker . "\<CR>`<"
    else
      " Normal mode
      silent execute "normal! :'[,']s]^]" . lhs_cmt_marker . "\<CR>`["
      silent execute "normal! :'[,']s]$]" . rhs_cmt_marker . "\<CR>`["
    endif
  endif
endfunction
nnoremap gc :<C-u>set opfunc=CommentToggle<CR>g@
xnoremap gc :<C-u>call CommentToggle(visualmode(), 1)<CR>
nnoremap gcc :<C-u>set opfunc=CommentToggle<bar>execute "normal! " . v:count1 . "g@_"<CR>

" }}}

" 9. SESSIONS {{{

" Don't save options and mapings as part of sessions
set sessionoptions-=options

" Save session using ,ss
nnoremap ,ss :mksession! ~/.vim/.sessions/<C-z><S-Tab>

" Open session using ,so
nnoremap ,so :source ~/.vim/.sessions/<C-z><S-Tab>

" Automatically save session before leaving vim
autocmd vimrc VimLeavePre * if !empty(v:this_session) |
            \ execute "mksession! " . fnameescape(v:this_session) |
            \ else | mksession! ~/.vim/.sessions/previous.vim | endif

" Restore previous (unnamed) session using ,sp
nnoremap <silent> ,sp :source ~/.vim/.sessions/previous.vim<CR>

" }}}

" 10. APPEARANCE {{{

" Show position at bottom-right
set ruler

" Display statusline all the time
set laststatus=2

" Custom statusline with git-branch-name (if fugitive is installed), and ruler
set statusline=%<%f\ %h%m%r\%{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" Show (partial) command in the last line of the screen
set showcmd

" Different cursor-shapes in different modes (tweaked for GNU-Screen as well)
if !empty($STY)
    let &t_SI.="\eP\e[6 q\e\\"
    let &t_EI.="\eP\e[2 q\e\\"
    if v:version > 704 || v:version == 704 && has("patch693")
        let &t_SR = "\eP\e[4 q\e\\"
    endif
else
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[2 q"
    if v:version > 704 || v:version == 704 && has("patch693")
        let &t_SR = "\<Esc>[4 q"
    endif
endif

" No cursorline in diff, quickfix, and inactive windows
autocmd vimrc VimEnter * set cursorline
autocmd vimrc WinEnter * if &filetype != "qf" && !&diff | set cursorline | endif
autocmd vimrc WinLeave * set nocursorline

" Colorscheme (doesn't complain if the specified colorscheme doesn't exist)
silent! colorscheme base16-ocean

" }}}

" ========================
" vim: set fen fdm=marker:
" ========================
