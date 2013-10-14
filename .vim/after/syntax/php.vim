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

" Vim syntax file for Hack
"
" Language: HackForHipHop (PHP)
"
" Facebook/XHP classes and functions
syn keyword phpFunctions param_post param_get starts_with contained 
syn keyword phpFunctions wait wait_for wait_forv wait_forva result wait_for_result contained
syn keyword phpFunctions must_prepare contained
syn keyword phpType void attribute category children enum required mixed use tuple contained

""""""""""""""""""""""""""""""""" " HACK " """"""""""""""""""""""""""""""""

syn region hackGenericType contained matchgroup=hackGenericType
      \ start="\w\+<"hs=e
      \ end=">"
      \ contains=hackGenericType2

syn region hackGenericType2 contained  matchgroup=hackGenericType2
      \ start="\w\+<"hs=e
      \ end=">"
      \ contains=hackGenericType3

syn region hackGenericType3 contained  matchgroup=hackGenericType3
      \ start="\w\+<"hs=e
      \ end=">"
      \ contains=hackGenericType

syn region phpRegion matchgroup=Delimiter keepend
      \ start="<?hh\( // partial\| // strict\| // decl\|\s*\)\(\s\|$\)" 
      \ end="?>" 
      \ contains=@phpClTop

" This messes up things, because ArrayAccess<T> would render ArrayAccess as a
" keyword and then <T> will become XHP. If you figure out how to fix this,
" LMK please.
syn cluster phpClConst remove=phpClasses,hackGenericType
syn cluster phpClInside add=hackGenericType

hi def link hackGenericType Type
hi def link hackGenericType2 Keyword
hi def link hackGenericType3 Special

