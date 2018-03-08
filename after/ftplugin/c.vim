" C/C++ specific settings

" Change default commentstring
setlocal commentstring=//\ %s

" Add cscope database, if present in current directory
if filereadable('cscope.out')
    cs add cscope.out
endif

" Enable related plugins
packadd tagbar
packadd vim-asyncmake

" List/unlist all tags using ,l
nnoremap <buffer> <silent> ,l :Tagbar<CR>

" List current tag using ,m
nnoremap <buffer> <silent> ,m :TagbarCurrentTag<CR>

" The variable 'b:asyncmakeprg' holds the default build command
let b:asyncmakeprg = 'g++ ' . expand('%')

" Set ,, to compile using the variable 'b:asyncmakeprg'
nnoremap <buffer> <silent> ,, :AsyncMake<CR>

" Automatically run AsyncMake on buffer-entry and file-save
"augroup asyncmake
"  autocmd!
"  autocmd BufWritePost,BufEnter *.c,*.cpp silent! :AsyncMake!
"augroup END

" Find the callers of the function under cursor
nmap <C-\>c :cs find c <C-R>=expand('<cword>')<CR><CR>

" Prefer cscope over ctags for <C-]>
set cscopetag

" Echo current method's header (works for simple well-structured programs)
"function! CurrentFunction()
"    " Get the previous uncommented line that starts without space and ends with '{'
"    let startline = getline(search("^[^ \s\t\/\/].*[^:]$", 'nb'))
"    " Check if the line contains 'class' or 'struct'
"    if startline =~ ".*\\(class\\|struct\\).*"
"        " If yes, then print the value of the motion '[m'
"        execute "normal! mxHmy`x[m"
"        let startline = getline('.')
"        execute "normal! `yzt`x"
"        echo startline
"    else
"        " Else print the line itself
"        echo startline
"    endif
"endfunction
"nnoremap <Leader>m :call CurrentFunction()<CR>

" Fold using expressions
setlocal foldmethod=expr

" Fold import blocks
function! CFoldExpr()
    let pattern = '^\(\/\/ \)\?#include'
    let curline = getline(v:lnum)
    if match(curline, pattern) >= 0
        return '1'
    endif
    let nextline = getline(v:lnum+1)
    if match(nextline, pattern) >= 0
        return '='
    endif
endfunction
setlocal foldexpr=CFoldExpr()
"
"" Custom foldtext
"function! CFoldText()
"    let foldsize = (v:foldend - v:foldstart + 1)
"    return '+' . v:folddashes . ' ' . foldsize . ' lines: INCLUDES '
"endfunction
"setlocal foldtext=CFoldText()
