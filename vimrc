" Manas's vimrc
" vim: set fen fdm=marker:
" Filetype-specific settings are in '.vim/ftplugin'
" Toggle folds using 'za'
" =============================================================================
" SETTINGS {{{1
" =============================================================================

filetype plugin indent on	    " Enable filetype-based plugins and indentation
syntax enable			    " Enable syntax-coloring
packadd! matchit		    " Load vim's builtin matchit plugin
set showmatch			    " Highlight matching parenthesis

set softtabstop=4		    " Number of spaces a <Tab> counts for
set shiftwidth=4		    " Number of spaces for indentation
set autoindent			    " Start next line from where the previous one did

set foldmethod=marker		    " Fold using markers
set backspace=indent,eol,start	    " Make backspace work everywhere
set linebreak			    " Break lines visually when they don't fit into the screen
set formatoptions+=j		    " Remove comment-leader when joining commented lines
set sessionoptions-=options	    " Don't save options while saving sessions

set hidden			    " Enable opening other file while keeping the previous one in buffer
set confirm			    " Confirm when closing vim with unsaved buffers

set laststatus=2		    " Display statusline all the time
set scrolloff=1			    " Keep one extra line while scrolling
set display=lastline		    " Don't show '@'s when a line doesn't fit the screen
set wildmenu			    " Visual autocomplete for command menu
set wildignorecase		    " Ignore case in wildmenu (like zsh; not needed on macOS)
set suffixes+=.class		    " Decrease the priority of listed file-types during expansion

set ruler			    " Show ruler with line and column numbers at bottom-right
set number			    " Show line numbers on the left hand side
set relativenumber		    " Show relative line numbers

set nohlsearch			    " Don't highlight matches (enabled by default on some Vim versions)
set incsearch			    " Show matches while typing the search-term
set ignorecase			    " Ignore case while searching
set smartcase			    " Don't ignore case when search-term contains capitals

set history=200			    " Keep 200 lines of command-line history
set ttimeout			    " Time-out for key codes
set ttimeoutlen=100		    " Wait up to 100ms after <Esc> for special key
set mouse=a			    " Enable mouse

" }}}1
" =============================================================================
" MAPPINGS {{{1
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

" Quickfix-lists
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" Location-lists
nnoremap ]w :lnext<CR>
nnoremap [w :lprevious<CR>

" Make 'Y' behave like other capitals
nnoremap Y y$

" Run macro from register 'q' with 'Q'
nnoremap Q @q

" Auto-insert ending brace and a new line to write above
inoremap {<CR> {<CR>}<C-O>O

" Toggles
nnoremap cop :setlocal paste!<CR>:setlocal paste?<CR>
nnoremap cos :setlocal spell!<CR>:setlocal spell?<CR>
nnoremap coh :setlocal hlsearch!<CR>:setlocal hlsearch?<CR>
nnoremap cob :set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR>

" }}}1
" =============================================================================
" AUTOCOMMANDS {{{1
" =============================================================================

augroup vimrc
    " Clear the autocommands of this group
    autocmd!

    " Highlight current line in the active window
    autocmd VimEnter * set cursorline
    autocmd WinEnter * if &filetype != "tagbar" | set cursorline | endif
    autocmd WinLeave * set nocursorline

    " Automatically open quickfix/location lists when populated
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" }}}1
" =============================================================================
" SEARCHING {{{1
" =============================================================================

if executable('ag')
    " If available, use 'ag' as the grep-program
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat^=%f:%l:%c:%m
else
    set grepprg=grep\ -IRn\ --exclude=tags\ $*\ .
endif

" Maps
command! -nargs=+ -bar Grep silent lgrep! <args> | redraw!
nnoremap <leader>a :Grep<Space>
nnoremap <leader>c :Grep <C-R><C-W><CR>

" }}}1
" =============================================================================
" COMPLETION {{{1
" =============================================================================

" Don't complete from include files
set complete-=i

" Complete filenames and keywords with <Tab>
function! CleverTab() abort
    let str = strpart(getline('.'), 0, col('.')-1)
    if pumvisible()
        return "\<C-E>"
    elseif empty(matchstr(str, '[^ \t]*$'))
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

" Insert <Tab> at end-of-lines using <Shift-Tab>
inoremap <S-Tab> <Space><Tab>

" }}}1
" =============================================================================
" SCRATCHPAD {{{1
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

" }}}1
" =============================================================================
" APPEARANCE {{{1
" =============================================================================

" Custom statusline with ruler and fugitive
set statusline=%<%f\ %h%m%r\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}%=%-14.(%l,%c%V%)\ %P

" Use 24-bit true colors, if available
if has('termguicolors')
    set termguicolors
endif

" Use seoul colorscheme
colorscheme seoul

" Reset guicolors and colorscheme for incompatible environments
function! ResetColors()
    if has('termguicolors')
        set notermguicolors
    endif
    colorscheme default
endfunction
nnoremap <leader>r :call ResetColors()<CR>

" Different cursor shapes in different modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" }}}1
" =============================================================================
" CSCOPE {{{1
" =============================================================================

" Add cscope database, if present in current directory
if filereadable('cscope.out')
    cs add cscope.out
endif

" Prefer cscope over ctags for <C-]>
set cscopetag

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>

" }}}1
" =============================================================================
" PLUGINS {{{1
" =============================================================================

" -------------------------------------
" CtrlP {{{2
" -------------------------------------

" No statusline for CtrlP
function! DisableStatus()
    set laststatus=0
endfunction
function! EnableStatus()
    set laststatus=2
endfunction
let g:ctrlp_buffer_func = {
            \ 'enter': 'DisableStatus',
            \ 'exit':  'EnableStatus',
            \ }

" Ignore list
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(class|o|so)$',
            \ }

" Search only from the current directory
let g:ctrlp_working_path_mode = 'a'

" Open multiple marked files in hidden buffers
let g:ctrlp_open_multiple_files = 'i'

" Maps
nnoremap <silent>, :CtrlPBuffer<CR>
nnoremap <silent>; :CtrlPBufTag<CR>
nnoremap <silent><C-K> :CtrlPLine<CR>

" }}}2
" -------------------------------------
" UltiSnips {{{2
" -------------------------------------

" Use custom snippet-diretory
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

" Maps
let g:UltiSnipsExpandTrigger='<C-J>'
let g:UltiSnipsListSnippets='<C-K>'

" }}}2
" -------------------------------------
" Tagbar {{{2
" -------------------------------------

" Don't sort the tags
let g:tagbar_sort = 0

" Maps
nnoremap <silent><leader>d :TagbarToggle<CR>
nnoremap <silent><leader>f :TagbarCurrentTag<CR>

" }}}2
" -------------------------------------

" }}}1
" =============================================================================
