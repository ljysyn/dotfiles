

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" my favorrate
set nu
set nobackup
set cc=80
set fileencoding=utf-8
set encoding=utf-8
set guifont="DejaVu\ Sans\ Mono\ for\ Powerline"
set hls

" for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle 
" required!
Bundle 'VundleVim/Vundle.vim'

" plugin from vim-script

" plugin from github
Plugin 'scrooloose/nerdtree'
Plugin 'sirver/ultisnips'
Plugin 'Valloric/YouCompleteMe'
Plugin 'jiangmiao/auto-pairs'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wincent/command-t'

" All vundle plugin must upon this
call vundle#end()
filetype plugin indent on
" vundle end

""" key map {
let mapleader = ','
inoremap jj <ESC>
""" }

""" for airline {
set laststatus=2
"let g:airline_theme="badwolf"
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
""" }

""" for nerdteee {
map <F3> : NERDTreeToggle<CR>
""" }

""" for command-t {
map <F4> : CommandT<CR>
"""}

""" for YouCompleteMe {
let g:ycm_confirm_extra_conf = 0
" disable diagnostrics show, such as ycm_err_symbol,
" you can use :YcmDiags to see them manual
let g:ycm_show_diagnostics_ui = 0
let g:ycm_err_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
" nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
nmap <F5> :YcmDiags<CR>
""" }

""" for auto-pairs {
" use ctr-l to jump over pairs
let g:AutoPairsShortcutJump = '<C-l>'
""" }

""" for markdown {
let g:vim_markdown_folding_disabled = 1
""" }

""" for cscope {
" use gtags
set cscopeprg='/usr/bin/gtags-cscope'
" use ctr-] to jump
set cst
" auto add tags file
if filereadable("GTAGS")
	cs add GTAGS
elseif $CSCOPE_DB != ''
	cs add $CSCOPE_DB
endif
" keymap
set cscopequickfix=c-,d-,e-,f-,g0,i-,s-,t-
nmap <C-f>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-f>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-n> :cnext<CR>
nmap <C-p> :cprev<CR>
""" }
