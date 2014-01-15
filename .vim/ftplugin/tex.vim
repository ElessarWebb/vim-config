set spell
filetype plugin indent on

" too slow with tex for some reason
set nocursorline

" vim lateX suite
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_MultipleCompileFormats="pdf"
" let g:Imap_UsePlaceHolders=0
let g:Tex_UseMakefile=0
let g:Tex_GotoError=0
let g:Tex_ShowErrorContext = 0
let g:Tex_ViewRule_pdf='evince &> /dev/null'
let g:Tex_CompileRule_pdf='rubber -fd'

" ignore all warnings below level
let g:TCLevel = 1

" AUTOSAVE!! every minute
" yes, I enabled this after a nasty fail.
autosave 60
