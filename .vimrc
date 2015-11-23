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

call plug#begin('~/.vim/autoload')

" My Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'mattn/emmet-vim'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'guersam/vim-j'
Plug 'Rykka/riv.vim'
Plug 'rubik/vim-dg'
Plug 'scrooloose/nerdcommenter'
Plug 'neovimhaskell/haskell-vim'
Plug 'scrooloose/syntastic'
Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'myusuf3/numbers.vim'
Plug 'hdima/python-syntax'
Plug 'rubik/vim-radon'
Plug 'lervag/vim-latex'
Plug 'chrisgillis/vim-bootstrap3-snippets'
Plug 'SirVer/ultisnips' | Plug 'rubik/vim-snippets'
Plug 'rubik/vim-smlpp'

call plug#end()

filetype on
filetype plugin indent on
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

let $PATH = $PATH . ':' . expand('~/.cabal/bin')

syntax enable

" ##########################################################################
" Mappings.
" Change the leader key
let mapleader = ','
" Use CtrlP for buffers
nnoremap <leader>b :CtrlPBuffer<CR>
" Switch between buffers
map <C-l> :bn<CR>
map <C-h> :bp<CR>
" Toggle search highlights and show current value
noremap <F4> :set hlsearch! hlsearch?<CR>
" Copy selected text to clipboard via xclip
vnoremap <F8> :w !xclip -selection c<CR><ESC>
" Expand html tags (emmet-vim)
map <C-y>o i<CR><Up><End><CR>
imap <C-y>o <CR><Up><End><CR>
" Editing a protected file as 'sudo'
cnorea W w !sudo tee % >/dev/null<CR>
" EasyMotion mappings
map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)

" Filetype-specific settings
" Add colorscheme for Kivy files
au BufRead,BufNewFile *.kv set filetype=kivy
au! Syntax kivy source $HOME/.vim/syntax/kivy.vim
autocmd FileType vim,html,htmldjango,xml,javascript,coffee setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType haskell setlocal shiftwidth=4 tabstop=4 softtabstop=4
" Disable help split
autocmd FileType help :autocmd BufEnter * wincmd o

" Colorscheme
set background=dark
colorscheme solarized

highlight! link pythonPreCondit Include
highlight SignColumn ctermfg=12 guifg=Cyan guibg=Grey
highlight ColorColumn ctermbg=lightcyan
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" Automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Set the correct filetype for new TeX files
let g:tex_flavor = 'latex'
" Python location
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
" Keep vim-radon always on
let g:radon_always_on = 1
" Vim-dg options
let g:dg_highlight_builtins = 0
" CtrlP options
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0
set wildignore+=*/tmp/*,*.so,*.sw[op],*.zip,*.pyc
" It needs The Silver Searcher
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore "*.pyc"'
" Syntastic options
let g:syntastic_haskell_checkers=['hlint']
let g:syntastic_python_checkers=['frosted', 'pep8', 'python']
let g:syntastic_c_compiler_options = "-Wall -Wextra -pedantic -std=c99"
" Airline options
set laststatus=2
let g:airline_theme='sol'
" UltiSnips configuration
"let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" EasyMotion options
let g:EasyMotion_startofline = 0 " keep cursor column when using JK motion

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

set history=1000
set undolevels=1000
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set timeoutlen=500
set ttimeoutlen=10
set novisualbell
set noerrorbells
set t_vb=
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>.
set pastetoggle=<F2>
set incsearch
