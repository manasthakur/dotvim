" Java specific folding

" Fold using expressions
setlocal foldmethod=expr

" Fold import blocks
function! JavaFoldExpr()
    let pattern = '^\(\/\/\)\?import'
    let curline = getline(v:lnum)
    if match(curline, pattern) >= 0
        return '1'
    endif
    let nextline = getline(v:lnum+1)
    if match(nextline, pattern) >= 0
        return '='
    endif
endfunction
setlocal foldexpr=JavaFoldExpr()

" Custom foldtext
function! JavaFoldText()
    let foldsize = (v:foldend - v:foldstart + 1)
    return '+' . v:folddashes . ' ' . foldsize . ' lines: IMPORTS '
endfunction
setlocal foldtext=JavaFoldText()
