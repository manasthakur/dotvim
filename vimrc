""""""""""""""""""""""""""""""MANAS'S VIMRC"""""""""""""""""""""""""""""""""""
" AUTHOR:  Manas Thakur                                                      "
" EMAIL:   manasthakur17 AT gmail DOT com                                    "
" LICENSE: MIT                                                               "
"                                                                            "
" NOTE:    (a) Filetype-specific settings are in '.vim/ftplugin'             "
"          (b) Toggle folds using 'za'                                       "
"                                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------------------------------------------------------------------------
" SETTINGS {{{
"-----------------------------------------------------------------------------

" Enable filetype detection, and filetype-based plugins and indents
filetype plugin indent on

" Enable syntax-highlights
syntax enable

" Load the builtin matchit plugin; allows jumping among matching keywords using '%'
packadd! matchit

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

" Enable switching buffers without saving them
set hidden

" Confirm when quitting vim with unsaved buffers
set confirm

" Wrap long lines
set linebreak

" Remove comment-leader when joining lines using 'J'
set formatoptions+=j

" Unicode characters for list mode (show up on ':set list')
set listchars=tab:»\ ,trail:·

" Allow selecting arbitrary regions in visual-block mode
set virtualedit=block

" Don't show '@'s when a line doesn't fit the screen
set display=lastline

" Keep one extra line while scrolling (for context)
set scrolloff=1

" Keep 200 lines of command-line history
set history=200

" Don't save the values of options while saving sessions
set sessionoptions-=options

" Enable mouse in all modes
set mouse=a

" Time-out for key codes
set ttimeout

" Wait up to 100ms after <Esc> for special key
set ttimeoutlen=100

" }}}
"-----------------------------------------------------------------------------
" MAPPINGS {{{
"-----------------------------------------------------------------------------

" Exit insert mode with 'jj'
inoremap jk <Esc>

" Buffers
"   - Update : ,w
"   - Delete : ,q
"   - Switch : [b and ]b
nnoremap ,w :update<CR>
nnoremap ,q :bdelete<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" Quickfix lists
"   - Switch using [q and ]q
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>

" Make 'Y' behave like other capitals
nnoremap Y y$

" Run macro from register 'q' with 'Q'
nnoremap Q @q

" Select recently pasted text using 'gV' (capital 'V')
"   (Note: 'gv' selects recently selected text by default)
nnoremap gV `[V`]

" Expand '{<CR>' to a block and place cursor inside
inoremap {<CR> {<CR>}<Esc>O

" Tabularize selected text using ,t
xnoremap ,t :'<,'>!column -t<CR>

" Write a file with sudo when it was opened without, using ':w!!'
cnoremap w!! w !sudo tee % > /dev/null

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

" Search for files in the directory of the current file, as well as recursively in the current directory (:pwd)
set path=.,**

" Reduce priority of following file-types while expanding file-names
set suffixes+=*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls
set suffixes+=*.tar.*,*.zip,*.jar
set suffixes+=*.pdf,*.ps,*.dvi,*.gif,*.jpg,*.png,*.mp3,*.mp4,*.avi

" Find file and edit
"   - in current buffer :  ,e
"   - in a split        : ,se
"   - in a vsplit       : ,ve
nnoremap  ,e :find *
nnoremap ,se :sfind *
nnoremap ,ve :vertical sfind *

" List open files and switch
"   - over current buffer :  ,f
"   - in a split          : ,sf
"   - in a vsplit         : ,vf
"   - to alternate buffer :  ,r
nnoremap  ,f :ls<CR>:b<Space>
nnoremap ,sf :ls<CR>:sb<Space>
nnoremap ,vf :ls<CR>:vertical sb<Space>
nnoremap  ,r :b#<CR>

" Goto tag
"   - first match      :  ,g
"   - list if multiple : ,lg
nnoremap  ,g :tag /
nnoremap ,lg :tjump /

" Two behavioral changes:
"   (a) Restore the last-known location on opening a file
"   (b) Don't move the cursor to start-of-line when switching buffers
augroup vimrc_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \ execute "normal! g'\"" | endif
    autocmd BufLeave * set nostartofline |
                \ autocmd CursorMoved,CursorMovedI * set startofline |
                \ autocmd! vimrc_position CursorMoved,CursorMovedI
augroup END

" Automatically open quickfix/location lists when populated
augroup vimrc_qf
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

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
inoremap <Tab> <C-R>=CleverTab()<CR>

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
    "   - standard     : ,a
    "   - current word : ,c
    nnoremap ,a :Grep<Space>
    nnoremap ,c :Grep <C-R><C-W><CR>
endif

" }}}
"-----------------------------------------------------------------------------
" SCRATCHPAD {{{
"-----------------------------------------------------------------------------

" Toggle a scratch window using ,x
function! ToggleScratch()
    let scr_winnr = bufwinnr('.scratchpad')
    if scr_winnr != -1
        execute scr_winnr . 'close'
    else
        execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .scratchpad'
    endif
endfunction
nnoremap <silent> ,x :call ToggleScratch()<CR>

" }}}
"-----------------------------------------------------------------------------
" ULTISNIPS {{{
"-----------------------------------------------------------------------------

" Use custom snippet-diretory
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

" Maps
let g:UltiSnipsExpandTrigger='<C-J>'
let g:UltiSnipsListSnippets='<C-K>'

"  }}}
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

" A command for distraction-free vim
command! DistractionFree set nonumber | set norelativenumber | set laststatus=1 | set noruler | set nospell

" Use seoul colorscheme
colorscheme seoul

" }}}
"-----------------------------------------------------------------------------
" vim: set fen fdm=marker:                                                   |
"-----------------------------------------------------------------------------
