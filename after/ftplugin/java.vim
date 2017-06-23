" Java specific settings

" List all classes and public/private/protected methods
nnoremap <buffer> ,d :call GlobalSearch("^\\s*\\(class\\\|public\\\|private\\\|protected\\).*{")<CR>

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> ,m :echo getline(search("^\\s*\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap <buffer> ,vm :keeppatterns ilist /visit.*.*{<Left><Left><Left>

" Set proper errorformat
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" The variable 'b:asyncmakeprg' holds a default javac command
let b:asyncmakeprg = "javac "
if isdirectory("../bin")
    let b:asyncmakeprg .= "-d ../bin/ "
endif
let b:asyncmakeprg .= expand('%')

" Set ,, to compile using the AsyncMake plugin
nnoremap <buffer> <silent> ,, :AsyncMake<CR>

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
