" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set nocompatible
filetype off

set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage itself
Bundle 'gmarik/vundle'

" My Bundles
Bundle 'mattn/zencoding-vim'
Bundle 'Command-T'
Bundle 'skammer/vim-css-color'
Bundle 'groenewege/vim-less'

filetype on
filetype plugin indent on

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim72/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

syntax on

" ##########################################################################
" Mappings.
" Switch between buffers
map <C-Right> :bn<CR>
map <C-Left> :bp<CR>
" Toggle paste mode
command P :set paste! paste?
" Toggle line numbers
nnoremap <F6> :set number!<CR>
" Toggle search highlights and show current value
noremap <F4> :set hlsearch! hlsearch?<CR>
" Copy selected text to clipboard via xclip
vnoremap <F8> :w !xclip -selection c<CR><ESC>
" Expand html tags (zencoding-vim)
map <C-y>o i<CR><Up><End><CR>
imap <C-y>o <CR><Up><End><CR>

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


" Add colorscheme for Kivy files
au BufRead,BufNewFile *.kv set filetype=kivy
au! Syntax kivy source $HOME/.vim/colors/kivy.vim

" Django: map set htmldjango filetype for every html file
au BufRead,BufNewFile *.html set filetype=htmldjango
au! Syntax htmldjango source $HOME/.vim/syntax/htmldjango.vim
" Closetag.vim
au Filetype htmldjango,xml,xsl source $HOME/.vim/scripts/closetag.vim
iabbrev </ <C-_>
" Local settings
autocmd FileType htmldjango,xml setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Colorscheme and filetype settings
set background=dark
" colorscheme navajo-night
colorscheme solarized

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Keep PyComplexity always on
let g:complexity_always_on = 1
" Change the leader key
let mapleader = ','

" vim-powerline
set rtp+=$HOME/.vim/bundle/powerline/powerline/bindings/vim

" General settings
set hlsearch
set hidden
set expandtab
set textwidth=79
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartcase
set autoindent
set colorcolumn=+1
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
