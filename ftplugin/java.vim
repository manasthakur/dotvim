" Java specific settings

" Set <leader>\ to run make (need to define 'makeprg')
function! Javac()
	execute 'silent lmake'
	redraw!
	if len(getloclist(0)) > 0
		execute 'lopen'
	else
		echo 'No errors!'
	endif
endfunction
nnoremap <leader>\ :call Javac()<CR>

