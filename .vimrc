" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" my favorrate
set nu
set nobackup
set cc=80
set fileencoding=utf-8

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
Bundle 'Valloric/YouCompleteMe'
Bundle 'jiangmiao/auto-pairs'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'

filetype plugin indent on

" key map
let mapleader = ','
inoremap jj <ESC>

" for nerdteee
map <F3> : NERDTreeToggle<CR>

" for YouCompleteMe
let g:ycm_confirm_extra_conf = 0
" disable diagnostrics show, such as ycm_err_symbol,
" you can use :YcmDiags to see them manual
let g:ycm_show_diagnostics_ui = 0
let g:ycm_err_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
" nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
nmap <F4> :YcmDiags<CR>

""" for auto-pairs
" use ctr-l to jump over pairs
let g:AutoPairsShortcutJump = '<C-l>'

""" for markdown
let g:vim_markdown_folding_disabled = 1

""" for cscope
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

