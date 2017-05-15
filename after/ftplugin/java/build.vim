" Asynchronous compilation using ant

" Use 'ant' as the compiler (sets 'makeprg' and 'errorformat')
compiler ant

if has('nvim')
    packadd neomake
    " Run Neomake! on buffer-write and buffer-open
    augroup neomake-java
        autocmd!
        autocmd BufWritePost,BufEnter * Neomake!
    augroup END
    " Set ,, to compile using 'ant'
    nnoremap <buffer> ,, :silent make! \| cwindow \| redraw!<CR>
else
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

        " Set ,, to compile using 'ant'
        nnoremap <buffer> <silent> ,, :call RunAsync('ant')<CR>
    else
        nnoremap <buffer> ,, :silent make! \| cwindow \| redraw!<CR>
    endif
endif
