" Java specific settings

" Set <leader>\ to run make (need to define 'makeprg')
function! Javac()
	execute 'silent make'
	redraw!
	if len(getqflist()) > 0
		execute 'copen'
	else
		echo 'No errors!'
	endif
endfunction
nnoremap <leader>\ :call Javac()<CR>

