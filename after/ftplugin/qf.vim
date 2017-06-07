" Quickfix/Location-list specific settings

" Is this a location-list or a quickfix-list?
let s:len_loclist = len(getloclist(0))

" Close using 'q'
" Jump to entry and close list using 'O'
" Add number of entries to the window title (shows up in statusline)
if s:len_loclist
    nnoremap <buffer><silent> q :lclose<CR>
    nnoremap <buffer><silent> O <CR>:lclose<CR>
    let w:quickfix_title = "[" . s:len_loclist . " entries] " . w:quickfix_title
else 
    nnoremap <buffer><silent> q :cclose<CR>
    nnoremap <buffer><silent> O <CR>:cclose<CR>
    let s:len_qflist = len(filter(getqflist(), 'v:val.valid'))
    if s:len_qflist
        let w:quickfix_title = "[" . s:len_qflist . " entries] " . w:quickfix_title
    endif
endif

" Enable line numbing, but disable relative line-numbers
setlocal number norelativenumber

" Disable cursorline (as colorscheme takes care of highlighting the current entry)
setlocal nocursorline
