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

" The variable 'b:dispatch' holds the default build command
let b:dispatch = 'javac '
if isdirectory("../bin")
    let b:dispatch .= '-d ../bin/ '
endif
let b:dispatch .= expand('%')

" Define a 'Dispatch' command
command! -nargs=* -complete=file Dispatch call Dispatch(<q-args>)

" Set ,, to compile using the variable 'b:dispatch'
nnoremap <buffer> <silent> ,, :Dispatch<CR>

" Function to build (async for Vim 8+)
function! Dispatch(cmd) abort
  if !empty(a:cmd)
    let b:dispatch = a:cmd
  endif
  if v:version >= 800
    " The async version (Vim 8+)
    echo "Compiling: " . b:dispatch
    let s:dispatch_outfile = tempname()
    call job_start(b:dispatch, {'exit_cb': 'ExitHandler', 'err_io': 'file', 'err_name': s:dispatch_outfile})
  else
    " The synchronous version
    let &makeprg = b:dispatch
    execute "silent make!" | redraw!
  endif
endfunction

" Function to handle job-exit (Vim 8+)
function! ExitHandler(job, exit_status) abort
  execute "cgetfile " . s:dispatch_outfile
  echo ""
  if a:exit_status == 0
    echo "No errors!"
  endif
  unlet s:dispatch_outfile
endfunction
