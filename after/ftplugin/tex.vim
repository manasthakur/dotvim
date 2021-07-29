" LaTeX specific settings

" Enable spell-check
setlocal spell

" Use ,, to make (forced)
nnoremap <buffer> ,, :!make -B<CR><CR>

" Use ;; to run pdflatex on current buffer
nnoremap <buffer> ;; :!pdflatex %<CR><CR>

" Complete words containing ':' and '-'
setlocal iskeyword+=:,-
