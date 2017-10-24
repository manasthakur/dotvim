" Java specific settings

" List all classes and public/private/protected methods
nnoremap <buffer> ,l :call GlobalSearch("^\\s*\\(class\\\|public\\\|private\\\|protected\\).*{")<CR>

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> ,m :echo getline(search("^\\s*\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap <buffer> ,vm :keeppatterns ilist /visit.*.*{<Left><Left><Left>

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

" Set proper errorformat
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" Enable asynchronous error-checking
packadd vim-asyncmake

" Automatically run AsyncMake on buffer-entry and file-save
augroup asyncmake
  autocmd!
  autocmd BufWritePost *.java silent! :AsyncMake!
"  autocmd BufWritePost,BufEnter *.java silent! :AsyncMake!
augroup END

" The variable 'b:asyncmakeprg' holds the default build command
let b:asyncmakeprg = 'javac -Xlint '
if isdirectory("../obj")
    let b:asyncmakeprg .= '-d ../obj/ '
endif
let b:asyncmakeprg .= expand('%')

" Set ,, to compile using the variable 'b:asyncmakeprg'
nnoremap <buffer> <silent> ,, :AsyncMake<CR>
