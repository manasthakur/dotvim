" This file contains miscellaneous settings/commands, for record

" -------------------------------------
" CtrlP {{{
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
nnoremap <silent> , :CtrlPBuffer<CR>
nnoremap <silent> ; :CtrlPBufTag<CR>
nnoremap <silent> <C-K> :CtrlPLine<CR>

" }}}
" -------------------------------------
" Tagbar {{{
" -------------------------------------

" Don't sort the tags
let g:tagbar_sort = 0

" Maps
nnoremap <silent> <leader>d :TagbarToggle<CR>
nnoremap <silent> <leader>f :TagbarCurrentTag<CR>

" }}}
" -------------------------------------
