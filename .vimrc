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
Plugin 'gmarik/vundle'

" My Plugins
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'skammer/vim-css-color'
Plugin 'groenewege/vim-less'
Plugin 'closetag.vim'
Plugin 'django.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'guersam/vim-j'
Plugin 'endel/vim-github-colorscheme'
Plugin 'Rykka/riv.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'rubik/vim-dg'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Shougo/vimproc.vim'
Plugin 'dag/vim2hs'
Plugin 'scrooloose/syntastic'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'myusuf3/numbers.vim'

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
map <C-Right> :bn<CR>
map <C-Left> :bp<CR>
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

" ###########################################################################
" Python mappings.
" F2: Open IPython2 and then return VIM
" F5: Run the current file with IPython2
" F7: Run current file's doctest with IPython in verbose mode
"
" Note that if you do not have an executable called ipython2 in the PATH these
" commands will not work for you. Also, ipython2, if present will run Python 2
" version. You should replace ipython2 with the ipython executable you want to
" use (usually simple ipython or ipython3).
"au filetype python map <F2> :w<CR> :!clear<CR> :!ipython2<CR>
"au filetype python map <F5> :w<CR> :!clear<CR> :!ipython2 %<CR>
"au filetype python map <F7> :w<CR> :!clear<CR> :!python2 -m doctest -v %<CR>


" Filetype-specific settings
" Add colorscheme for Kivy files
au BufRead,BufNewFile *.kv set filetype=kivy
au! Syntax kivy source $HOME/.vim/syntax/kivy.vim

" Custom indent for Cram/Gobble files
au BufRead,BufNewFile *.t set filetype=gobble
au Filetype gobble setlocal shiftwidth=2 tabstop=2 softtabstop=2

" HTML: map set htmldjango filetype for every html file
au BufRead,BufNewFile *.html set filetype=html syntax=mustache
" Closetag.vim
au Filetype html,htmldjango,xml,xsl source $HOME/.vim/bundle/closetag.vim/plugin/closetag.vim
iabbrev </ <C-_>
" Local settings
autocmd FileType vim,html,htmldjango,xml,javascript,coffee setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4
" Disable help split
autocmd FileType help :autocmd BufEnter * wincmd o

" Colorscheme
set background=dark
colorscheme solarized

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Activate Mustache abbreviations
" let g:mustache_abbreviations = 1
" Keep PyComplexity always on
let g:complexity_always_on = 1
" ctrlP options
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0
set wildignore+=*/tmp/*,*.so,*.sw[op],*.zip,*.pyc
" It needs The Silver Searcher
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore "*.pyc"'
" Syntastic options
let g:syntastic_haskell_checkers=['hlint']
let g:syntastic_python_checkers=['frosted', 'pep8', 'python']
" Airline options
set laststatus=2
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

let g:dg_highlight_builtins = 0
