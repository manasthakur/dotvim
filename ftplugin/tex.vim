"LaTeX specific settings

" Fix textwidth
setlocal textwidth=80

" Enable spell-check
setlocal spell

" Use '\\' to make (forced)
nnoremap <buffer> <leader>\ :!make -B<CR><CR>

" Include completion for words containg ':' and '-'
setlocal iskeyword+=:,-

" Fold using syntax 
setlocal foldmethod=expr

" Get fold-expression using 'MyFoldLevel()'
setlocal foldexpr=MyFoldLevel(v:lnum)

" Function that returns foldlevel for a line
function! MyFoldLevel(lnum)
	let cur_line = getline(a:lnum)

	if cur_line =~ '^\s*\\section'
		return '>1'
	endif

	if cur_line =~ '^\s*\\subsection'
		return '>2'
	endif

	if cur_line =~ '^\s*\\subsubsection'
		return '>3'
	endif

	" Fold following environments
	let fold_envs = ['tabular', 'figure', 'algorithm', 'minipage', 'verbatim', 'semiverbatim', 'lstlisting']
	let envs = '\(' . join(fold_envs, '\|') . '\)'

	if cur_line =~ '^\s*\\begin{' . envs
		return 'a1'
	endif

	if cur_line =~ '^\s*\\end{' . envs
		return 's1'
	endif

	return '='
endfunction

