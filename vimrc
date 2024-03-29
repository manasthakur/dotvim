""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype settings are in 'after/ftplugin'                     "
"          (b) Plugins reside in 'pack/*'                                    "
"          (c) Toggle folds using 'za'                                       "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 1. INITIALIZATION {{{

" Enable filetype detection, and filetype-based plugins and indentation
filetype plugin indent on

" Enable syntax highlights
syntax on

" Load the builtin matchit plugin (allows jumping among matching keywords using %)
runtime macros/matchit.vim

" Put all the swap files (with full path as name) at '~/.vim/.swap/'
set directory=~/.vim/.swap//

" Don't create backup files
set nobackup

" Look out for five modelines
set modelines=5

" Clear autocommands
augroup vimrc
    autocmd!
augroup END

" Change the default flavor for LaTeX files (affects 'filetype')
let g:tex_flavor = "latex"

" }}}

" 2. FORMATTING {{{

" Copy the indent of current line onto next
set autoindent

" Backspace, tab, and indent with 4 spaces
set shiftwidth=4
set softtabstop=4
set expandtab

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

" Wait only 50 ms after ESC
set ttimeoutlen=50

" Wrap long lines
set linebreak

" When a line doesn't fit the screen, show '@'s only at the end
set display=lastline

" Keep cursor off by a line while scrolling (for context)
set scrolloff=1

" Keep 1000 lines of command-line history
set history=1000

" Enable mouse in all the modes
set mouse=a

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

" }}}

" 4. SHORTHANDS {{{

" Exit insert mode using jk
inoremap jk <Esc>

" Keep the selection after shifting text
xnoremap > >gv
xnoremap < <gv

" Scroll without moving the cursor using CTRL+j and CTRL+k
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

" Auto-insert closing parenthesis/brace
inoremap <expr> ( col('.') < col('$') ? "(" : "()\<Left>"
inoremap <expr> { col('.') < col('$') ? "{" : "{}\<Left>"

" Skip over closing parenthesis/brace
inoremap <expr> ) getline('.')[col('.')-1] == ")" ? "\<Right>" : ")"
inoremap <expr> } getline('.')[col('.')-1] == "}" ? "\<Right>" : "}"

" Expand opening-brace followed by ENTER to a block and place cursor inside
inoremap {<CR> {<CR>}<Esc>O

" Auto-delete closing parenthesis/brace
function! BetterBackSpace() abort
    let cur_line = getline('.')
    let before_char = cur_line[col('.')-2]
    let after_char = cur_line[col('.')-1]
    if (before_char == '(' && after_char == ')') || (before_char == '{' && after_char == '}')
        return "\<Del>\<BS>"
    else
        return "\<BS>"
endfunction
inoremap <silent> <BS> <C-r>=BetterBackSpace()<CR>

" Search selected text using *
xnoremap * "xy/\V<C-r>x<CR>

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

" Compatibility mode with coc (useful over SSH connections)
function! CompatibilityMode() abort
    if g:colors_name != "default"
        colorscheme default
        highlight CursorLine cterm=NONE ctermbg=255
        highlight Visual cterm=NONE ctermbg=255
    else
        silent! colorscheme apprentice
    endif
    set foldenable!
endfunction
nnoremap <silent> coc :call CompatibilityMode()<CR>

" }}}

" 5. NAVIGATION {{{

" Enable switching buffers without saving them
set hidden

" Confirm before quitting vim with unsaved buffers
set confirm

" Update buffer using ,w
nnoremap ,w :update<CR>

" By default 'find' files recursively under the current directory
set path=.,**

" Ignore following patterns while expanding file-names
set wildignore+=tags,*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls,*.jpg,*.png,*.dvi,*.ps,*.pdf

" Reduce the priority of following patterns while expanding file-names
set suffixes+=*.bib,*.log

" Use CTRL+z to start wildcard-expansion in command-line mappings
set wildcharm=<C-z>

" Find and open file in current window, horizontal (s), or vertical (v) split
" (capital versions search the directory of the current file)
nnoremap ,f :find *
nnoremap ,s :sfind *
nnoremap ,v :vert sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h'))<CR>/**/*
nnoremap ,S :sfind <C-R>=fnameescape(expand('%:p:h'))<CR>/**/*
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h'))<CR>/**/*

" Switch buffer
nnoremap ,b :b<Space>

" List buffers
nnoremap ,l :ls<CR>:b<Space>

" Switch to alternate buffer using ,r
nnoremap ,r :b#<CR>

" Bracket maps to cycle back-and-forth
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
"   - goto first match : ,t
"       - current word : ,T
"   - list if multiple : ,j
"       - current word : ,J
"   - show preview     : ,p
"       - current word : ,P
nnoremap ,t :tag /
nnoremap ,T :tag <C-r><C-w><CR>
nnoremap ,j :tjump /
nnoremap ,J :tjump <C-r><C-w><CR>
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

" Don't complete (in insert-mode) from included files
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

" Use SHIFT-TAB for traversing the completion menu in reverse, and to insert tabs after non-space characters
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

" 8. SESSIONS {{{

" Don't save options and mapings as part of sessions
set sessionoptions-=options

" Save session using <Space>ss
nnoremap <Space>ss :mksession! ~/.vim/.sessions/<C-z><S-Tab>

" Open session using <Space>so
nnoremap <Space>so :source ~/.vim/.sessions/<C-z><S-Tab>

" Automatically save session before leaving vim
autocmd vimrc VimLeavePre * if !empty(v:this_session) |
            \ execute "mksession! " . fnameescape(v:this_session) |
            \ else | mksession! ~/.vim/.sessions/previous.vim | endif

" Restore previous (unnamed) session using <Space>sp
nnoremap <silent> <Space>sp :source ~/.vim/.sessions/previous.vim<CR>

" Function to get the session name
function! SessionName() abort
    if empty(v:this_session)
        return ""
    else
        let l:session_name = fnamemodify(v:this_session, ':t:r')
        return "[".l:session_name."] "
    endif
endfunction

" }}}

" 9. APPEARANCE {{{

" Show line and column numbers at bottom-right
set ruler

" Display statusline all the time
set laststatus=2

" Custom statusline
set statusline=\ %<%f                                                                     " File name
set statusline+=\ %h%m%r                                                                  " Help, RO, Modified
set statusline+=%{SessionName()}                                                          " Git directory-name
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}                   " Git branch
set statusline+=%=                                                                        " Separator
set statusline+=%#WarningMsg#%{exists('g:loaded_asyncmake')?asyncmake#statusline():''}%*  " Quickfix validity
set statusline+=\ %-20.(%y\ \ c%c%V%)                                                     " Filetype, and real-virtual column numbers
set statusline+=\ %l/%L\                                                                  " Current and total line numbers

" Show (partial) command in the last line of the screen
set showcmd

" Different cursor-shapes in different modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" No cursorline in diff, quickfix, and inactive windows
autocmd vimrc VimEnter * set cursorline
autocmd vimrc WinEnter * if &filetype != "qf" && !&diff | set cursorline | endif
autocmd vimrc WinLeave * set nocursorline

" Colorscheme
highlight CursorLineNr cterm=NONE ctermbg=255
highlight CursorLine cterm=NONE ctermbg=255
highlight Visual cterm=NONE ctermbg=255

" }}}

" 10. PLUGIN SETTINGS {{{

" (a) NETRW

" Open using '-' (also jumps to current file)
function! OpenNetrw() abort
    let l:alt_file = fnameescape(expand('%:t'))
    execute "Explore"
    call search(l:alt_file)
endfunction
nnoremap <silent> - :call OpenNetrw()<CR>

" Disable the banner
let g:netrw_banner = 0

" Hide './' and '../' entries
let g:netrw_list_hide = '^\.\.\=/$'

" Maintain the alternate buffer
let g:netrw_altfile = 1

" (b) TAGBAR

" Sort based on order
let g:tagbar_sort = 0

" List/unlist all tags using SPACE+b
nnoremap <silent> <Space>b :Tagbar<CR>

" List current tag using SPACE+m
nnoremap <silent> <Space>m :TagbarCurrentTag<CR>

" }}}

" ========================
" vim: set fen fdm=marker:
" ========================
