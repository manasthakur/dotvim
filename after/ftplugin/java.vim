" Java specific settings

" List all classes and public/private/protected methods
nnoremap <buffer> <Leader>d :call GlobalSearch("^\\s*\\(class\\\|public\\\|private\\\|protected\\).*{")<CR>

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> <Leader>m :echo getline(search("^\\s*\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap <buffer> <Leader>vm :keeppatterns ilist /visit.*.*{<Left><Left><Left>

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

if v:version >= 800
    " Function to handle job-exit
    function! ExitHandler(job, exit_status) abort
        execute 'cgetfile ' . g:async_outfile
        echo ""
        if a:exit_status == 0
            echo "No errors!"
        endif
        unlet g:async_outfile
    endfunction

    " Function to run 'ant' asynchronously (Vim 8 only)
    function! RunAsync(command) abort
        if !filereadable(expand("build.xml"))
            echo "Buildfile: build.xml does not exist!"
        else
            echo "Compiling..."
            let g:async_outfile = tempname()
            call job_start(a:command, {'exit_cb': 'ExitHandler', 'out_io': 'file', 'out_name': g:async_outfile})
        endif
    endfunction

    " Set <Leader>, to compile using 'ant'
    nnoremap <buffer> <silent> <Leader>, :call RunAsync('ant')<CR>
else
    nnoremap <buffer> <Leader>, :silent make! \| cwindow \| redraw!<CR>
endif

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
