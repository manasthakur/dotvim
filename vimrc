" Manas's vimrc
" vim: set foldenable foldmethod=marker:
" Filetype-specific settings are in .vim/ftplugin/
" Toggle folds using 'za'
" =============================================================================
" BASIC SETTINGS {{{1
" =============================================================================

set softtabstop=4		    " Number of spaces inserted per TAB
set shiftwidth=4		    " Number of spaces for auto-indentation
set autoindent			    " Start next line from where the previous one did

filetype plugin indent on	    " Enable filetype-based plugins and indentation
syntax enable			    " Enable syntax-coloring
packadd! matchit		    " Load vim's builtin matchit plugin
set showmatch			    " Highlight matching parenthesis

set foldmethod=marker		    " Fold using markers
set backspace=indent,eol,start	    " Make backspace work everywhere
set display=lastline		    " Don't show '@' lines when a line doesn't fit the screen
set formatoptions+=j		    " Remove comment-leader when joining commented lines
set sessionoptions-=options	    " Don't save options while saving sessions

set hidden			    " Enable opening other file while keeping the previous one in buffer
set confirm			    " Confirm when closing vim with unsaved buffers
set scrolloff=1			    " Keep one extra line while scrolling for context
set laststatus=2		    " Display statusline all the time
set wildmenu			    " Visual autocomplete for command menu
set wildignorecase		    " Ignore case in wildmenu (like zsh; not needed on macOS)

set ruler			    " Show ruler with line and column numbers at bottom-right
set number			    " Show line numbers on the left hand side
set relativenumber		    " Show relative line numbers

set nohlsearch			    " Don't highlight matches (not needed in some Vim versions)
set incsearch			    " Show search matches as you type
set ignorecase			    " Ignore case while searching
set smartcase			    " Don't ignore case when search term consists capital letters

set history=200			    " Keep 200 lines of command line history
set ttimeout			    " Time out for key codes
set ttimeoutlen=100		    " Wait up to 100ms after Esc for special key
set pastetoggle=<leader>z	    " Toggle paste using '<leader>z'
set mouse=a			    " Enable mouse for all activities

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

" Location-lists
nnoremap ]q :lnext<CR>
nnoremap [q :lprevious<CR>

" Make 'Y' behave like other capitals
nnoremap Y y$

" Run macro from register 'q' with 'Q'
nnoremap Q @q

" Auto-insert ending brace and a new line to write above
inoremap {<CR> {<CR>}<C-O>O

" Toggle spellcheck
nnoremap <leader>s :set spell!<CR>:set spell?<CR>

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

" Grep and open the results in the quickfix window
function! Search() abort
    let grep_term = input("Grep: ")
    if !empty(grep_term)
        execute 'silent lgrep!' grep_term | lopen
    else
        echo
    endif
    redraw!
endfunction
nnoremap <leader>a :call Search()<CR>
nmap <leader>c <leader>a<C-r><C-w><CR>

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

" Make '<CR>' select an entry from completion-menu
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Insert '<Tab>' at end-of-lines using <Shift-Tab>
inoremap <S-Tab> <Space><Tab>

" }}}1
" =============================================================================
" CSCOPE {{{1
" =============================================================================

" Add cscope database, if present in current directory
if filereadable("cscope.out")
    cs add cscope.out
endif

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	

" }}}1
" =============================================================================
" APPEARANCE {{{1
" =============================================================================

" Use 24-bit true colors, if available
if has('termguicolors')
    set termguicolors
endif

" Use seoul colorscheme
colorscheme seoul

" Highlight current line in insert mode
augroup vimrc
    autocmd!
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
augroup END

" Reset guicolors and colorscheme for incompatible environments
function! ResetColors()
    if has('termguicolors')
        set notermguicolors
    endif
    colorscheme default
endfunction
nnoremap <leader>r :call ResetColors()<CR>

" }}}1
" =============================================================================
" PLUGINS {{{1
" =============================================================================

" -------------------------------------
" Scratchpad {{{2
" -------------------------------------

" Toggle scratchpad
nnoremap <leader>x :ScratchpadToggle<CR>

" }}}2
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

" Mappings
nnoremap <silent>, :CtrlPBuffer<CR>
nnoremap <silent>; :CtrlPBufTag<CR>
nnoremap <silent><C-k> :CtrlPLine<CR>

" }}}2
" -------------------------------------
" UltiSnips {{{2
" -------------------------------------

" Use custom snippet-diretory instead of other plugins
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/mysnippets']

" Mappings
let g:UltiSnipsExpandTrigger='<C-J>'
let g:UltiSnipsListSnippets='<C-K>'

" }}}2
" -------------------------------------
" Tagbar {{{2
" -------------------------------------

" Don't sort the tags
let g:tagbar_sort = 0

" Mappings
nnoremap <silent><leader>d :TagbarToggle<CR>
nnoremap <silent><leader>f :TagbarCurrentTag<CR>

" }}}2
" -------------------------------------

" }}}1
" =============================================================================
