" C/C++ specific settings

" Enable related plugins
packadd tagbar
packadd vim-asyncmake

" Change default commentstring
setlocal commentstring=//\ %s

" Add cscope database, if present in current directory
if filereadable('cscope.out')
    cs add cscope.out
endif

" List/unlist all tags using ,l
nnoremap <buffer> <silent> ,l :Tagbar<CR>

" List current tag using ,m
nnoremap <buffer> <silent> ,m :TagbarCurrentTag<CR>

" The variable 'b:asyncmakeprg' holds the default build command
let b:asyncmakeprg = 'gcc ' . expand('%')

" Set ,, to compile using the variable 'b:asyncmakeprg'
nnoremap <buffer> <silent> ,, :AsyncMake<CR>

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>
