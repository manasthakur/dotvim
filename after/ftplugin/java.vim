" Java specific settings

" Enable related plugins
packadd tagbar
packadd vim-asyncmake

" Set proper errorformat
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

" The variable 'b:asyncmakeprg' holds the default build command
let b:asyncmakeprg = 'javac '
if isdirectory("../bin")
    let b:asyncmakeprg .= '-d ../bin/ '
endif
let b:asyncmakeprg .= expand('%')

" Set ,, to compile using the variable 'b:asyncmakeprg'
nnoremap <buffer> <silent> ,, :AsyncMake<CR>

" Set SPACE+r to execute a script in the right tmux pane
nnoremap <silent> <Space>r :call job_start("tmux send-keys -t right '../scripts/run.sh' C-m")<CR>
