" Java specific settings

" List all classes and public/private/protected methods
nnoremap <buffer> ,d :call GlobalSearch("^\\s*\\(class\\\|public\\\|private\\\|protected\\).*{")<CR>

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> ,m :echo getline(search("^\\s*\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap <buffer> ,vm :keeppatterns ilist /visit.*.*{<Left><Left><Left>

" Set proper errorformat
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

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

" Enable asynchronous error-checking
packadd vim-asyncmake

" The variable 'b:dispatch' holds the default build command
let b:dispatch = 'javac -Xlint '
if isdirectory("../obj")
    let b:dispatch .= '-d ../obj/ '
endif
let b:dispatch .= expand('%')

" Set ,, to compile using the variable 'b:dispatch'
nnoremap <buffer> <silent> ,, :Dispatch<CR>
