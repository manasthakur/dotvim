"LaTeX specific settings

" Enable spell-check
setlocal spell

" Use ',,' to make (forced)
if has('nvim')
    nnoremap <buffer> ,, :terminal make -B<CR>
else
    nnoremap <buffer> ,, :!make -B<CR><CR>
endif

" Complete words containing ':' and '-'
setlocal iskeyword+=:,-
