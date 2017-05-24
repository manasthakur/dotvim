" Java specific maps

" List all classes and public/private/protected methods
nnoremap <buffer> ,f :call GlobalSearch("^\\s*\\(class\\\|public\\\|private\\\|protected\\).*{")<CR>

" Echo current method's header (works if explicit access-modifiers have been used)
nnoremap <buffer> ,m :echo getline(search("^\\s*\\(public\\\|private\\\|protected\\).*{", 'bn'))<CR>

" Search among visit methods
nnoremap <buffer> ,vm :keeppatterns ilist /visit.*.*{<Left><Left><Left>
