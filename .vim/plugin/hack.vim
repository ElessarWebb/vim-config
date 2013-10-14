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
"
" HackForHipHop Checker v1.2 for Vim
"

if !exists("g:fb_hack_autoclose")
  let g:fb_hack_autoclose = 1
endif

if !exists("g:fb_hack_on")
  " Set this to 0 if you don't like the autocommand on write
  let g:fb_hack_on = 1
endif

if !exists("g:fb_hack_snips")
  " Set this to 0 if you don't like the hhs/hhp insert snippets
  let g:fb_hack_snips = 1
endif

function! s:Exec(cmd)
  let ret = system(a:cmd)
  return strpart(ret, 0, strlen(ret) - 1)
endfunction

function! s:CheckHack()
  let old_make = &makeprg
  let old_fmt = &errorformat
  let temp = s:Exec('mktemp')
  call system('~/hh/hh_server --check ~/code | sed "s/No errors!//" > '.temp)
  let &errorformat = '%EFile "%f"\, line %l\, characters %c-%.%#,'
  let &errorformat.= '%Z%m,'
  let &errorformat.= 'Error: %m,'
  let &errorformat.= '%m,'
  execute 'cgetfile '.temp
  if g:fb_hack_autoclose == 1
    botright cwindow
  else 
    botright copen
  endif

  let &makeprg = old_make
  let &errorformat = old_fmt
endfunction

function! s:CheckHackAutocommand()
  if g:fb_hack_on == "1"
    " TODO: Add a small delay to make sure Hack server gets notified of the change.
    call s:CheckHack()
    redraw!
  endif
endfunction

function! s:CheckHackCommand()
  call s:CheckHack()
  redraw!
endfunction

function! s:HackToggleAutocommand()
  if g:fb_hack_on == "1"
      let g:fb_hack_on = "0"
  else
      let g:fb_hack_on = "1"
  endif
endfunction 

function! s:HackToggleAutoclose()
  if g:fb_hack_autoclose == 1
    let g:fb_hack_autoclose = 0
  else
    let g:fb_hack_autoclose = 1
  endif
endfunction

function! s:HackTypeCW() 
  let cmd='hh_client --type-at-pos '.fnameescape('~/www/'.expand('%')).':'.line('.').':'.col('.')
  let output='HackType: '.system(cmd)
  let output=substitute(output, '\n$', '', '')
  echo output
endfunction

if g:fb_hack_snips == 1
  iabbrev hhs <?hh // strict
\<CR>// Copyright 2004-present Facebook. All Rights Reserved.
  iabbrev hhp <?hh
\<CR>// Copyright 2004-present Facebook. All Rights Reserved.
  iabbrev hhd <?hh // decl
\<CR>// Copyright 2004-present Facebook. All Rights Reserved.
endif

command! HackMake call s:CheckHackCommand()
command! HackToggle call s:HackToggleAutocommand()
command! HackToggleAutoclose call s:HackToggleAutoclose()
command! HackType call s:HackTypeCW()

" Using [; and ]; to switch between quickfix windows
noremap [; :colder<CR>
noremap ]; :cnewer<CR>

au BufWritePost *.php call s:CheckHackAutocommand()
au BufWritePost *.hhi call s:CheckHackAutocommand()
au BufRead,BufNewFile *.hhi set filetype=php

" Keep quickfix window at an adjusted height.
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
