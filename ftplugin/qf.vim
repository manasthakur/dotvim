" Quickfix/Location-list specific settings

" Is this a location-list or a quickfix-list?
let b:qf_isloclist = len(getloclist(0)) > 0 ? 1 : 0

" Close using 'q'
" Jump to entry and close using 'O'
if b:qf_isloclist
    nnoremap <buffer><silent> q :lclose<CR>
    nnoremap <buffer><silent> O <CR>:lclose<CR>
else 
    nnoremap <buffer><silent> q :cclose<CR>
    nnoremap <buffer><silent> O <CR>:cclose<CR>
endif

" Disable cursorline (as colorscheme takes care of highlighting the current entry)
setlocal nocursorline

