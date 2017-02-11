" Manas's vimrc
" vim: set fen fdm=marker:
" Filetype-specific settings are in '.vim/ftplugin'
" Toggle folds using 'za'
" =============================================================================
" SETTINGS {{{
" =============================================================================

filetype plugin indent on	    " Enable filetype-based plugins and indentation
syntax enable			    " Enable syntax-highlights
packadd! matchit		    " Load the builtin matchit plugin
set showmatch			    " Highlight matching parenthesis

set softtabstop=4		    " Number of spaces a <Tab> counts for
set shiftwidth=4		    " Number of spaces for indentation
set autoindent			    " Start next line from where the current one does
set listchars=tab:»\ ,trail:·	    " Unicode characters for list mode

set foldmethod=marker		    " Fold using markers
set backspace=indent,eol,start	    " Make backspace work everywhere
set linebreak			    " Break lines visually when they don't fit into the screen
set formatoptions+=j		    " Remove comment-leader when joining commented lines
set display=lastline		    " Don't show '@'s when a line doesn't fit the screen
set virtualedit=block		    " Allow virtual-editing in visual-block mode

set hidden			    " Enable opening other file while keeping the previous one in buffer
set confirm			    " Confirm when closing vim with unsaved buffers

set laststatus=2		    " Display statusline all the time
set scrolloff=1			    " Keep one extra line while scrolling
set wildmenu			    " Visual autocomplete for command menu
set wildignorecase		    " Ignore case in wildmenu (not needed on macOS)

set ruler			    " Show line and column numbers at bottom-right
set number			    " Show line number in front of each line
set relativenumber		    " Show relative line numbers

set nohlsearch			    " Don't highlight previously matched items
set incsearch			    " Show matches while typing the search-term
set ignorecase			    " Ignore case while searching
set smartcase			    " Don't ignore case when search-term contains capitals

set ttimeout			    " Time-out for key codes
set ttimeoutlen=100		    " Wait up to 100ms after <Esc> for special key

set history=200			    " Keep 200 lines of command-line history
set sessionoptions-=options	    " Don't save options while saving sessions
set mouse=a			    " Enable mouse in all the modes
set pastetoggle=<F2>		    " Toggle paste using <F2>

" }}}
" =============================================================================
" MAPPINGS {{{
" =============================================================================

" Scroll using Ctrl-Dn and Ctrl-Up (won't work on macOS)
noremap <C-Down> <C-F>
noremap <C-Up> <C-B>

" Buffers
nnoremap <leader>w :update<CR>
nnoremap <leader>q :bdelete<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

" Tabs
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>

" Quickfix lists
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" Location lists
nnoremap ]w :lnext<CR>
nnoremap [w :lprevious<CR>

" Make 'Y' behave like other capitals
nnoremap Y y$

" Run macro from register 'q' with 'Q'
nnoremap Q @q

" Create block
inoremap {<CR> {<CR>}<Esc>O

" Tabularize selected text
xnoremap <leader>t :'<,'>!column -t<CR>

" Write a file with sudo when it was opened without
cnoremap w!! w !sudo tee % > /dev/null

" Toggles
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap col :setlocal list!<CR>:setlocal list?<CR>
nnoremap coh :setlocal hlsearch!<CR>:setlocal hlsearch?<CR>
nnoremap cob :set background=<C-R>=&background=='dark'?'light':'dark'<CR><CR>

" }}}
" =============================================================================
" AUTOCOMMANDS {{{
" =============================================================================

augroup vimrc
    " Clear the autocommands of this group
    autocmd!

    " Highlight current line in the active window
    autocmd VimEnter * set cursorline
    autocmd WinEnter * if !&diff | set cursorline | endif
    autocmd WinLeave * set nocursorline

    " Automatically open quickfix/location lists when populated
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow

    " Don't move cursor to start of line when switching buffers
    autocmd BufLeave * set nostartofline |
		\ autocmd CursorMoved,CursorMovedI * set startofline |autocmd! vimrc CursorMoved,CursorMovedI
augroup END

" }}}
" =============================================================================
" NAVIGATION {{{
" =============================================================================

" Recurse
set path=.,**

" Ignore-list
set wildignore+=*.class,*.o,*.out,*.aux,*.bbl,*.blg,*.cls
set wildignore+=*.tar.*,*.zip,*.jar
set wildignore+=*.pdf,*.ps,*.dvi,*.gif,*.jpg,*.png,*.mp3,*.mp4,*.avi

" Files
nnoremap <C-P> :find *

" Buffers
nnoremap , :ls<CR>:b<SPACE>

" Alternate buffer
nnoremap <C-K> :b#<CR>

" Tags
nnoremap ; :tag /

" }}}
" =============================================================================
" SEARCHING {{{
" =============================================================================

if executable('ag')
    " If available, use 'ag' as the grep-program
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat^=%f:%l:%c:%m
else
    set grepprg=grep\ -IRn\ --exclude=tags\ $*\ .
endif

" Maps
command! -nargs=+ Grep silent lgrep! <args> | redraw!
nnoremap <leader>a :Grep<Space>
nnoremap <leader>c :Grep <C-R><C-W><CR>

" }}}
" =============================================================================
" COMPLETION {{{
" =============================================================================

" Don't complete from included files
set complete-=i

" Use <Tab> for completion
function! CleverTab() abort
    if pumvisible()
        return "\<C-E>"
    endif

    let str = matchstr(strpart(getline('.'), 0, col('.')-1), '[^ \t]*$')
    if empty(str)
        return "\<Tab>"
    else
        if match(str, '\/') != -1
            return "\<C-X>\<C-F>"
        else
            return "\<C-P>"
        endif
    endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

" Make <CR> select an entry from completion-menu
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

" Insert <Tab> at end of lines using <Shift-Tab>
inoremap <S-Tab> <Space><Tab>

" }}}
" =============================================================================
" SCRATCHPAD {{{
" =============================================================================

" Toggle a scratch window
function! ToggleScratch()
    let scr_winnr = bufwinnr('.scratchpad')
    if scr_winnr != -1
	execute scr_winnr . 'close'
    else
	execute 'rightbelow ' . float2nr(0.2 * winwidth(0)) . 'vsplit +setlocal\ filetype=markdown\ nobuflisted .scratchpad'
    endif
endfunction
nnoremap <silent> <leader>x :call ToggleScratch()<CR>

" }}}
" =============================================================================
" APPEARANCE {{{
" =============================================================================

" Custom statusline with fugitive and ruler
set statusline=%<\ %f\ %h%m%r\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" Different cursor shapes in different modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Seoul colorscheme
colorscheme seoul

" }}}
" =============================================================================
" CSCOPE {{{
" =============================================================================

" Add cscope database, if present in current directory
if filereadable('cscope.out')
    cs add cscope.out
endif

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>

" }}}
" =============================================================================
" ULTISNIPS {{{
" =============================================================================

" Use custom snippet-diretory
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

" Maps
let g:UltiSnipsExpandTrigger='<C-J>'
let g:UltiSnipsListSnippets='<C-K>'

" }}}
" =============================================================================
