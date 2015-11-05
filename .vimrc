filetype off
" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set nocompatible
filetype off

set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage itself
Plugin 'VundleVim/Vundle.vim'

" My Plugins
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'groenewege/vim-less'
Plugin 'kchmck/vim-coffee-script'
Plugin 'guersam/vim-j'
Plugin 'Rykka/riv.vim'
Plugin 'rubik/vim-dg'
Plugin 'scrooloose/nerdcommenter'
Plugin 'neovimhaskell/haskell-vim'
Plugin 'scrooloose/syntastic'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'myusuf3/numbers.vim'
Plugin 'hdima/python-syntax'
Plugin 'rubik/vim-radon'
Plugin 'lervag/vim-latex'
Plugin 'chrisgillis/vim-bootstrap3-snippets'
Plugin 'SirVer/ultisnips'
Plugin 'rubik/vim-snippets'
Plugin 'rubik/vim-smlpp'

call vundle#end()

filetype on
filetype plugin indent on
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

let $PATH = $PATH . ':' . expand('~/.cabal/bin')

syntax enable

" ##########################################################################
" Mappings.
" Switch between buffers
map <C-l> :bn<CR>
map <C-h> :bp<CR>
" Toggle paste mode
command P :set paste! paste?
" Toggle search highlights and show current value
noremap <F4> :set hlsearch! hlsearch?<CR>
" Copy selected text to clipboard via xclip
vnoremap <F8> :w !xclip -selection c<CR><ESC>
" Expand html tags (zencoding-vim)
map <C-y>o i<CR><Up><End><CR>
imap <C-y>o <CR><Up><End><CR>
" Editing a protected file as 'sudo'
cnorea W w !sudo tee % >/dev/null<CR>
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Filetype-specific settings
" Add colorscheme for Kivy files
au BufRead,BufNewFile *.kv set filetype=kivy
au! Syntax kivy source $HOME/.vim/syntax/kivy.vim
" Set the correct filetype for new TeX files
let g:tex_flavor = 'tex'

" Local settings
autocmd FileType vim,html,htmldjango,xml,javascript,coffee setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4
" Disable help split
autocmd FileType help :autocmd BufEnter * wincmd o

" Colorscheme
set background=dark
colorscheme solarized

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

hi! link pythonPreCondit Include
hi SignColumn ctermfg=12 guifg=Cyan guibg=Grey

" Python location
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'
" Keep vim-radon always on
let g:radon_always_on = 1
" ctrlP options
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0
set wildignore+=*/tmp/*,*.so,*.sw[op],*.zip,*.pyc
" It needs The Silver Searcher
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore "*.pyc"'
" Syntastic options
let g:syntastic_haskell_checkers=['hlint']
let g:syntastic_python_checkers=['frosted', 'pep8', 'python']
" Mustache-Handlebars options
let g:mustache_abbreviations=1
" Airline options
set laststatus=2
" UltiSnips configuration
"let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" GCC Syntastic Checker
let g:syntastic_c_compiler_options = "-Wall -Wextra -pedantic -std=c99"
" Change the leader key
let mapleader = ','

" General settings
set number
set hlsearch
set hidden
set expandtab
set textwidth=79
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ignorecase
set autoindent
set colorcolumn=+1
set nofoldenable
set foldlevelstart=99
set foldlevel=99
highlight ColorColumn ctermbg=lightcyan
highlight Normal ctermbg=none
highlight NonText ctermbg=none

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>.
set pastetoggle=<F2>
set incsearch

let g:dg_highlight_builtins = 0
