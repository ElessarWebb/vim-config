" ok ok, i'll use pathogen...
execute pathogen#infect()

" ok, ok i'll use syntax highlighting
syntax enable

" syntastic config
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <C-w>E :SyntasticCheck<CR>\| :SyntasticToggleMode<CR>

let mapleader = ","
let maplocalleader = "."

" Automatically cd into the directory that the file is in
" only enable if command-t is not installed
" set autochdir

" Preserves/Saves the state, executes a command, and returns to the saved state
function! Preserve(command)
	" save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")

	" Do the business:
	execute a:command

	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! call Preserve("%s/\\s\\+$//e") | endif

" indenting
set expandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent

" ctrlp behaviour
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_working_path_mode = 'ra'
nnoremap t :CtrlPTag<CR>
nnoremap \ :CtrlPLine<CR>
let g:ctrlp_buftag_types = {
      \'scala' : '--langmap=scala:+.scala'
      \}


" airline config
let g:airline_right_alt_sep = '' " ''
let g:airline_right_sep = '' " ''
let g:airline_left_alt_sep= '' " ''
let g:airline_left_sep = '' "''

" buffer stuff
set hidden
noremap <silent> <leader>d :bp\|:bd #<CR>
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" backspace fix
fixdel

" use the ftplugin files
filetype plugin on

" line no
set relativenumber
set number

" don't copy lineno's
set mouse=a

" wrap to previous/next line on move left at beginning, etc
set whichwrap+=<,>,h,l,[,]

" scrolling (keep n lines visible beneath and above cursor)
set scrolloff=10

" always show the statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set laststatus=2

" yeah you want this
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

" don't remove indent on #
inoremap # X<BS>#

" comment extending on newline
set formatoptions+=r

" use jj to go to cmd mode
inoremap jj <ESC>

" tabnew shorcut in cmd mode
noremap <C-t> :edit<Space>

" easier tabbing in cmd mode
noremap H :bprev<Enter>
noremap L :bnext<Enter>

" I like to forget to visually select the line when using gq to format a single line
noremap gq Vgq :noh<Enter>

" additionally it would be nice to remove double spaces
" after the paragraph is collapsed
vnoremap gq gq gv <Esc>:'<,'>s/	 / /g<Enter> :noh<Enter>

" easier window movement
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" Gundo
nnoremap <F3> :GundoToggle<CR>

" this is extreme in git add -p edit
noremap <Space> 0r <Esc>

" making stuff
noremap <LEADER>m :make<CR>

" do not swap "-register on visual replace put
vnoremap p "_dP

" don't create swapfiles
set noswapfile
" create backupfiles in another directory
set backupdir=~/.vim/backup

" recognize _ as a word boundary
set iskeyword-=_

set background=dark
set gfn=Inconsolata\ Medium\ 12

" let g:solarized_termcolors = 256
colorscheme solarized

" highlight current line
set cursorline

" highlight char line
set cc=100
set textwidth=100 " use in combination with gq to break paragraph

" highlight search results
set hlsearch

" ctags file
set tags=tags;/

" completion
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
	\ 'default' : '',
	\ 'vimshell' : $HOME.'/.vimshell_hist',
	\ 'scheme' : $HOME.'/.gosh_completions'
	\ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>	 neocomplcache#undo_completion()
inoremap <expr><C-l>	 neocomplcache#complete_common_string()
inoremap <expr><TAB>	pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>	pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" disable the scratch preview
set completeopt-=preview

" words less than 3 letters long aren't worth completing
let g:neocomplcache_auto_completion_start_length = 3

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" trinity toggles
nmap <F8>	:TrinityToggleTagList<CR> :TrinityToggleNERDTree<CR>
nmap <F9>	:TrinityToggleSourceExplorer<CR>
nmap <F10> :TrinityToggleTagList<CR>
nmap <F11> :TrinityToggleNERDTree<CR>

" Ranger filechooser
function! RangeChooser()
	let temp = tempname()
	" The option "--choosefiles" was added in ranger 1.5.1. Use the next line
	" with ranger 1.4.2 through 1.5.0 instead.
	"exec 'silent !ranger --choosefile=' . shellescape(temp)
	exec 'silent !ranger --choosefiles=' . shellescape(temp)
	if !filereadable(temp)
			" Nothing to read.
			return
	endif
	let names = readfile(temp)
	if empty(names)
			" Nothing to open.
			return
	endif
	" Edit the first item.
	exec 'edit ' . fnameescape(names[0])
	" Add any remaning items to the arg list/buffer list.
	for name in names[1:]
			exec 'argadd ' . fnameescape(name)
	endfor
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>
