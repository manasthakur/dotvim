" Manas's vimrc
" vim: set foldenable foldmethod=marker:
" Toggle folds using 'za'
" =============================================================================
" BASIC SETTINGS {{{1
" =============================================================================

set tabstop=4	                    "number of spaces a TAB character is shown as
set softtabstop=4                   "number of spaces inserted per TAB
set shiftwidth=4                    "number of spaces for auto-indentation
set expandtab                       "expand tabs to spaces
set autoindent                      "next line starts from where previous one did
filetype plugin indent on           "enable filetype-based plugins and indentation

syntax enable                       "enable syntax-coloring
set foldmethod=marker               "fold using markers
set backspace=indent,eol,start      "make backspace work everywhere

set hidden                          "enable opening other file while keeping the previous one in buffer
set laststatus=2                    "display statusline all the time
set confirm                         "confirm when closing vim with unsaved buffers
set scrolloff=1                     "keep one extra line while scrolling for context

set ruler                           "show ruler with line and column numbers at bottom-right
set number                          "show line numbers on the left hand side
set relativenumber                  "show relative line numbers

set showmatch                       "highlight matching parenthesis
set nohlsearch                      "don't highlight matches (not needed in some Vim versions)
set incsearch                       "show search matches as you type

set ignorecase                      "ignore case while searching
set smartcase                       "don't ignore case when search term consists capital letters
set wildmenu                        "visual autocomplete for command menu
set wildignorecase                  "ignore case in wildmenu (like zsh; not needed on macOS)

set history=200                     "keep 200 lines of command line history
set ttimeout                        "time out for key codes
set ttimeoutlen=100                 "wait up to 100ms after Esc for special key
set mouse=a                         "enable mouse for all activities

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

" Toggle spellcheck
nnoremap <leader>s :set spell!<CR>

" Toggle paste
set pastetoggle=<leader>z

" Auto-insert ending brace and a new line to write above
inoremap {<CR> {<CR>}<C-O>O

" }}}1
" =============================================================================
" SEARCHING {{{1
" =============================================================================

if executable('ag')
    " If available, use 'ag' as the grep-program
    set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
    set grepformat^=%f:%l:%c:%m

    " Shorthand to search the word under cursor
    nnoremap <leader>c :silent lgrep! <cword> \| lopen<CR><C-l>
else
    set grepprg=grep\ -IRn\ --exclude=tags\ $*\ .
endif

" Grep and open the results in the quickfix window
function! Search()
    let grep_term = input("Search: ")
    if !empty(grep_term)
        execute 'silent lgrep!' grep_term | lopen
    else
        echo
    endif
    redraw!
endfunction
nnoremap <leader>a :call Search()<CR>

" }}}1
" =============================================================================
" COMPLETION {{{1
" =============================================================================

" Don't complete from include files
set complete-=i         

" Complete filenames and keywords with <Tab>
function! CleverTab()
    let str = strpart(getline('.'), 0, col('.')-1)
    if empty(matchstr(str, '[^ \t]*$'))
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

" Type '<Tab>' literal at end-of-lines using <Shift-Tab>
inoremap <S-Tab> <C-V><Tab>

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

" Reset guicolors and colorscheme for incompatible environments using '\r'
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
" Sessionist {{{2
" -------------------------------------

" Don't save options while saving sessions
set sessionoptions-=options

" }}}2
" -------------------------------------
" Scratchpad {{{2
" -------------------------------------

" Toggle scratchpad using '\x'
nnoremap <leader>x :ScratchpadToggle<CR>  

" }}}2
" -------------------------------------
" MatchIt {{{2
" -------------------------------------

" Load vim's builtin matching plugin
runtime! macros/matchit.vim

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
nnoremap <silent><leader>t :CtrlPBufTag<CR>
nnoremap <silent><C-k> : CtrlPLine<CR>

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

" Sort tags in order of their appearance (default: name)
let g:tagbar_sort = 0

" Mappings
nnoremap <silent><leader>d :TagbarToggle<CR>
nnoremap <silent><leader>f :TagbarCurrentTag<CR>

" }}}2
" -------------------------------------

" }}}1
" =============================================================================
