" Quickfix/Location-list specific settings

" Is this a location-list or a quickfix-list?
let s:len_loclist = len(getloclist(0))

" Close using 'q'
" Jump to entry and close list using 'O'
" The horizontal split equivalents of '<CR>' and 'O' are 's' and 'S', respectively
" Add number of entries to the window title (shows up in statusline)
nnoremap <buffer><silent> O <CR><C-w>p<C-w>c
nnoremap <buffer><silent> s <C-w><CR><C-w>K
nnoremap <buffer><silent> S <C-w><CR><C-w>K<C-w>p<C-w>c
if s:len_loclist
    nnoremap <buffer><silent> q :lclose<CR>
    let w:quickfix_title = "[" . s:len_loclist . " entries] " . w:quickfix_title
else 
    nnoremap <buffer><silent> q :cclose<CR>
    let s:len_qflist = len(filter(getqflist(), 'v:val.valid'))
    if s:len_qflist
        let w:quickfix_title = "[" . s:len_qflist . " entries] " . w:quickfix_title
    endif
endif

" Enable line numbing, but disable relative line-numbers
setlocal number norelativenumber

" Disable cursorline (as colorscheme takes care of highlighting the current entry)
setlocal nocursorline
