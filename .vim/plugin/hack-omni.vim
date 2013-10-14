"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Copyright 2012-2013 Facebook.
"
"  Licensed under the Apache License, Version 2.0 (the "License");
"  you may not use this file except in compliance with the License.
"  You may obtain a copy of the License at
"
"      http://www.apache.org/licenses/LICENSE-2.0
"
"  Unless required by applicable law or agreed to in writing, software
"  distributed under the License is distributed on an "AS IS" BASIS,
"  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"  See the License for the specific language governing permissions and
"  limitations under the License.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" HackForHipHop Omni Complete for Vim
" 
" Delegates all to hackomni.py script

if !exists("g:fb_hack_omnicomplete")
  " set this to 0 in your vimrc if you'd like to disable the 
  " auto activation of Hack's omni completion settings
  let g:fb_hack_omnicomplete = 1
endif

let s:vim_script_filename=expand("<sfile>")

fun! HackOmniComplete(findstart, base)
python << endpython
# 1. import
import vim, os, sys
sys.path.append(os.path.abspath(os.path.dirname(vim.eval('s:vim_script_filename'))))
import hackomni

# 2. delegate
base = vim.eval('a:base')
findstart = bool(int(vim.eval('a:findstart')))
hackomni.HackOmniComplete(findstart, base).main()

endpython
endfun

if g:fb_hack_omnicomplete == 1

  autocmd FileType php set omnifunc=HackOmniComplete
  " Use CTRL-Space to run autocomplete in gVim and other nonconsole vim GUIs
  autocmd FileType php imap <C-space> <C-x><C-o>
  autocmd FileType php imap <A-space> <C-x><C-o>

endif
