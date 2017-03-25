" C/C++ specific folding

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

" Custom foldtext
function! CFoldText()
    let foldsize = (v:foldend - v:foldstart + 1)
    return '+' . v:folddashes . ' ' . foldsize . ' lines: INCLUDES '
endfunction
setlocal foldtext=CFoldText()
