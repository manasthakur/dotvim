" Source the main vimrc
source ~/.vim/vimrc

" Python location for speeding up Neovim
if has('nvim')
    if has('mac')
        let g:python_host_prog = '/usr/local/bin/python'
        let g:python3_host_prog = '/usr/local/bin/python3'
    else
        let g:python_host_prog = '/usr/bin/python'
        let g:python3_host_prog = '/usr/bin/python3'
    endif
endif

" Show substitution effects while typing
if has('nvim')
    set inccommand=nosplit
endif

" Terminal-specific mappings
if has('nvim')
    " Open terminal in a new tab using <A-t>
    nnoremap <A-t> :tabedit <bar> terminal<CR>

    " Exit terminal mode using <A-\>
    tnoremap <A-\> <C-\><C-n>

    " Switch splits using <A-h,j,k,l>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><c-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l

    " Switch tabs using [t and ]t
    tnoremap [t <C-\><C-n>:tabprevious<CR>
    tnoremap ]t <C-\><C-n>:tabnext<CR>

    " Automatically start insert-mode in terminal windows
    augroup vimrc
        autocmd WinEnter term://* startinsert
    augroup END
endif
