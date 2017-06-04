"LaTeX specific settings

" Enable spell-check
setlocal spell

" Use ',,' to make (forced)
nnoremap <buffer> ,, :!make -B<CR><CR>

" Complete words containing ':' and '-'
setlocal iskeyword+=:,-
