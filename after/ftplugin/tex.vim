" LaTeX specific settings

" Enable spell-check
setlocal spell

" Use ,, to make (forced)
nnoremap <buffer> ,, :!make -B<CR><CR>

" Complete words containing ':' and '-'
setlocal iskeyword+=:,-

" Fold using expressions 
setlocal foldmethod=expr

" Get fold-expression using 'MyFoldLevel()'
setlocal foldexpr=MyFoldLevel()

" Function that returns foldlevel for a line
function! MyFoldLevel()
    let cur_line = getline(v:lnum)

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
    let fold_envs = ['figure', 'algorithm', 'frame']
    let envs = '\(' . join(fold_envs, '\|') . '\)'

    if cur_line =~ '^\s*\\begin{' . envs
        return 'a1'
    endif

    if cur_line =~ '^\s*\\end{' . envs
        return 's1'
    endif

    return '='
endfunction
