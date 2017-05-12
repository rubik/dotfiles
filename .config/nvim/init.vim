" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

" My Plugins
Plug 'mattn/emmet-vim'
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'rubik/vim-dg', { 'for': 'dg' }
Plug 'scrooloose/nerdcommenter'
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'myusuf3/numbers.vim'
Plug 'rubik/vim-radon'
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips' | Plug 'rubik/vim-snippets'
Plug 'neomake/neomake'
Plug 'junegunn/goyo.vim'
Plug 'cespare/vim-toml', { 'for': 'toml' }

call plug#end()

filetype on
filetype plugin indent on
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

syntax enable

" {{{ General settings
set encoding=utf-8
scriptencoding utf-8
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

" Ignore a lot of stuff
set wildignore+=*.sw[opa],*.bak,*.pyc,*.o,*.so,*.class,*.beam,*.gch,*.gz
set wildignore+=.git,.hg,.bzr,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.png,*.gif
set wildignore+=build/*,tmp/*,vendor/cache/*
set wildignore+=.sass-cache/*,*node_modules/*

set title
set timeoutlen=500
set ttimeoutlen=10
set novisualbell
set noerrorbells
set t_vb=

set laststatus=2

" We don't need no frickin' mouse
set mouse=c

" In list mode, make whitespace obvious
set list
set listchars=tab:>.
set listchars+=trail:.
set listchars+=nbsp:.
set listchars+=extends:#
set incsearch

" {{{ Colorscheme
" No need for a complete colorscheme because we already set the colors in
" .Xresources
set background=dark
"colorscheme base16-paraiso

" Custom fixes
highlight String ctermfg=02
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" Custom Neomake groups
highlight NeomakeError ctermfg=01 ctermbg=8
highlight NeomakeWarning ctermfg=01 ctermbg=8
highlight NeomakeInfo ctermfg=01 ctermbg=8
highlight NeomakeMessage ctermfg=01 ctermbg=8

" Diff highlighting
highlight DiffAdd ctermfg=02 ctermbg=18
highlight DiffChange ctermfg=08 ctermbg=18
highlight DiffDelete ctermfg=01 ctermbg=18
highlight DiffText ctermfg=04 ctermbg=18
highlight DiffAdded ctermfg=02 ctermbg=00
highlight DiffFile ctermfg=01 ctermbg=00
highlight DiffNewFile ctermfg=02 ctermbg=00
highlight DiffLine ctermfg=04 ctermbg=00
highlight DiffRemoved ctermfg=01 ctermbg=00
" }}}

if executable('rg')
    set grepprg=rg\ --follow\ --no-heading\ --vimgrep\ -u
    set grepformat=%f:%l:%c:%m
endif
" }}}

" {{{ Mappings
" Change the leader key
let g:mapleader = ','

" Toggle PASTE mode with F2
set pastetoggle=<F2>

" Fucking tired of searching for /lkasdjflk to clear highlights
nmap <silent> <leader>7 :nohlsearch<CR>

" Use CtrlP to show available buffers
nnoremap <leader>b :CtrlPBuffer<CR>

" Location bindings
nnoremap [loclist] <nop>
nmap <leader><Space> [loclist]
noremap [loclist]o :lopen<CR>
noremap [loclist]c :lclose<CR>
noremap [loclist], :ll<CR>
noremap [loclist]n :lnext<CR>
noremap [loclist]p :lprev<CR>

" Switch between buffers
map <C-l> :bn<CR>
map <C-h> :bp<CR>

" Copy selected text to clipboard via xclip
vnoremap <F8> :w !xclip -selection c<CR><ESC>

" Expand html tags (emmet-vim)
map <C-y>o i<CR><Up><End><CR>
imap <C-y>o <CR><Up><End><CR>

" Editing a protected file as 'sudo'
cnoreabbrev W w !sudo tee % >/dev/null<CR>

" Cold turkey; no more arrows motions.
nnoremap <silent> <up>    <nop>
nnoremap <silent> <down>  <nop>
nnoremap <silent> <left>  <nop>
nnoremap <silent> <right> <nop>

" EasyMotion mappings
map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)
" }}}

" {{{ Autocommands
" Disable help split
au FileType help :autocmd BufEnter * wincmd o

" CSS/SCSS settings
au FileType scss setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
au FileType css setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

" JS settings
au FileType javascript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

" Use tabs in gitconfig files
au FileType gitconfig setlocal noexpandtab

" Enable Neomake on buffer read/write
au BufWritePost * Neomake
au BufReadPost  * Neomake

" Automatically remove trailing whitespace before writing
au BufWritePre * :%s/\s\+$//e

function! s:goyo_enter()
    " Disable plugins
    :call NumbersEnable()

    " Ensure that Neovim will quit on Goyo
    let b:quitting = 0
    let b:quitting_bang = 0

    au QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
    " Re-enable plugins
    :call NumbersEnable()
    " Quit Neovim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            qa!
        else
            qa
        endif
    endif
endfunction

au! User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave nested call <SID>goyo_leave()
" }}}

" {{{ Plugins options
" Set the correct filetype for new TeX files
let g:tex_flavor = 'latex'

" Python location
let g:python_host_prog = '/usr/bin/python3'
let g:python3_host_prog = '/usr/bin/python3'

" Keep vim-radon always on
let g:radon_always_on = 1

" Vim-dg options
let g:dg_highlight_builtins = 0

" CtrlP options
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 0

if executable('ag')
    " Make it use The Silver Searcher
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore "*.pyc"
    \ --ignore "*.beam" --ignore node_modules --ignore _build --ignore build
    \ --ignore "*.o" --ignore "*.gch" --ignore "*.gz"'
endif

" Airline options
let g:airline_powerline_fonts = 1

" Neomake options
let g:neomake_list_height = 3
let g:neomake_open_list = 0
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_verbose = 1
let g:neomake_c_enabled_makers = ['clang']
let g:neomake_c_clang_maker = {
   \ 'args': ['-Wall', '-Wextra', '-Weverything', '-pedantic'],
   \ }
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
   \ 'exe': 'clang++',
   \ 'args': ['-std=c++11', '-Wall', '-Wextra', '-Weverything', '-pedantic',
   \ '-Wno-c++98-compat-pedantic'],
   \ }
let g:neomake_python_enabled_makers = ['python', 'flake8']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_scss_enabled_makers = ['scsslint']
let g:neomake_sh_enabled_makers = ['shellcheck']
let g:neomake_elixir_enabled_makers = ['mix', 'credo']

" UltiSnips configuration
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Vimtex
let g:latex_view_general_viewer = 'zathura'
let g:vimtex_view_method = 'zathura'

" EasyMotion options
" Keep cursor column when using JK motion
let g:EasyMotion_startofline = 0
" }}}
