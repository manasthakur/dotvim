" Java specific settings

" List all classes and public/private/protected methods
nnoremap <buffer> ,d :keeppatterns ilist /\s\(class\\|public\\|private\\|protected\).*{<CR>:

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> ,m :echo getline(search("\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap ,vm :keeppatterns /visit.*{<Left>

" Function to handle job-exit
function! ExitHandler(job, exit_status) abort
    execute 'cgetfile ' . g:async_outfile
    echo ""
    if a:exit_status == 0
        echo "No errors!"
    endif
    unlet g:async_outfile
endfunction

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

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

" Set ,, to compile using 'ant'
if v:version >= 800
    nnoremap <buffer> <silent> ,, :call RunAsync('ant')<CR>
else
    nnoremap <buffer> ,, :silent make! \| cwindow \| redraw!<CR>
endif
