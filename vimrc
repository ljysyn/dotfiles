
" my favorrate
set nu
set nobackup
set cc=80
set fileencoding=utf-8
set encoding=utf-8
set guifont="DejaVu\ Sans\ Mono\ for\ Powerline"

" for vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle 
" required!
Bundle 'gmarik/vundle'

" plugin from vim-script

" plugin from github
Bundle 'scrooloose/nerdtree'
Bundle 'sirver/ultisnips'
Bundle 'Valloric/YouCompleteMe'
Bundle 'jiangmiao/auto-pairs'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'wincent/command-t'

filetype plugin indent on

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
