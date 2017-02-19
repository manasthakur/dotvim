" C++ specific settings

" Change default commentstring
setlocal commentstring=//\ %s

" Add cscope database, if present in current directory
if filereadable('cscope.out')
    cs add cscope.out
endif

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>

" Prefer cscope over ctags for <C-]>
set cscopetag

