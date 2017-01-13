" Java specific settings

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

" Set <leader>\ to run make (need to define 'makeprg')
nnoremap <buffer> <leader>\ :silent lmake \| lwindow \| redraw!<CR>

