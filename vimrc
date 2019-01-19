syntax on
set foldmethod=syntax
set foldlevelstart=99
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set termguicolors
set backupdir=~/.tmp
set directory=~/.tmp
set splitbelow " Open new split panes to right and bottom, which feels more natural
set splitright
set lazyredraw

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'junegunn/goyo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'mhanberg/vim-elixir'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-sensible'
Plug 'janko-m/vim-test'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-liquid'
Plug 'pangloss/vim-javascript'
Plug 'isRuslan/vim-es6'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'mileszs/ack.vim'
Plug 'ElmCast/elm-vim'
Plug 'tpope/vim-surround'
Plug 'nanotech/jellybeans.vim'
Plug 'tpope/vim-eunuch'
Plug 'ervandew/supertab'
Plug 'avakhov/vim-yaml'
Plug 'chr4/nginx.vim'
Plug 'mrtazz/simplenote.vim'
Plug 'Yggdroot/indentLine'
Plug 'rhysd/vim-crystal'
call plug#end()

if (glob('~/.simplenotrc'))
  source ~/.simplenoterc
  let g:SimplenoteVertical = 1
  let g:SimplenoteListSize = 30
  let g:SimplenoteFiletype = 'markdown'
  let g:SimplenoteSingleWindow = 1
endif

if has('gui_macvim')
  set guioptions=
  set guifont=Fira\ Code\ Retina:h14

  set cursorline
endif

colorscheme jellybeans

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W w
command! Wq wq
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'elixir', 'bash=sh', 'javascript']
" Disable K looking stuff up
map K <Nop>

nnoremap <leader><space> :set hls!<cr>
nnoremap <leader>a :Ack!<space>
nnoremap <leader>e :Explore<cr>

" Indent whole file
nnoremap <leader>i mzgg=G`z

" Spell check for text files
autocmd BufRead,BufNewFile *.md setlocal spell

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" Ctrlp conf
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden --ignore=".git" -g  "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  " use ag for ack.vim
  let g:ackprg = 'ag --vimgrep'
endif

" vim-test conf
let test#strategy = 'dispatch'
nmap <leader>n :TestNearest<CR> 
nmap <leader>f :TestFile<CR>
nmap <leader>s :TestSuite<CR>
nmap <leader>l :TestLast<CR>
nmap <leader>g :TestVisit<CR>

set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1
autocmd FileType elixir nnoremap <c-]> :ALEGoToDefinition<cr>
let g:ale_linters = {}
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_linters.elixir = ['elixir-ls', 'credo']
let g:ale_linters.ruby = ['rubocop', 'ruby']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.javascript = ['eslint']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
let g:ale_fixers.elm = ['format']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fixers.elixir = ['mix_format']

let g:ale_elixir_elixir_ls_release = '/Users/mitchell/Development/elixir-ls/rel'

nnoremap df :ALEFix<cr>

" vim-jsx conf
let g:jsx_ext_required = 0
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

