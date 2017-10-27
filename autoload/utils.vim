" Some utility functions that are not currently used in the vimrc,
" but might be useful occassionally

" Function to get the number of listed buffers
function! utils#NumListedBufs() abort
	return len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
endfunction

" Echo highlight-group of text under cursor
function! utils#HighlightGroup() abort
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
