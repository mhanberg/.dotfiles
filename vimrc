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
set noshowmode
set incsearch
set ignorecase
set smartcase
set undofile
set undodir=~/.tmp
set mouse=a
autocmd VimResized * :wincmd =
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

call plug#begin('~/.vim/bundle')
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'mhanberg/night-owl.vim', { 'branch': 'lightline' }
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'mbbill/undotree'
Plug 'alvan/vim-closetag'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rsi'
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
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'ElmCast/elm-vim'
Plug 'tpope/vim-surround'
Plug 'nanotech/jellybeans.vim'
Plug 'tpope/vim-eunuch'
Plug 'ervandew/supertab'
Plug 'avakhov/vim-yaml'
Plug 'chr4/nginx.vim'
Plug 'rhysd/vim-crystal'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-markdown'
Plug 'matze/vim-move'
Plug 'Yggdroot/indentLine'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'terryma/vim-multiple-cursors'
call plug#end()

if has('gui_macvim')
  set guioptions=
  set guifont=Fira\ Code\ Retina:h14

  set macmeta
endif

set cursorline
colorscheme night-owl
let g:lightline = { 'colorscheme': 'nightowl' }

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W w
command! Wq wq
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'elixir', 'bash=sh', 'javascript']
" Disable K looking stuff up

nnoremap <leader><space> :set hls!<cr>

" Indent whole file
nnoremap <leader>i mzgg=G`z

" Spell check for text files
augroup markdown
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

silent! nnoremap <c-p> :Files<cr>
nnoremap gl :BLines<cr>
nnoremap <leader>a :Ag<space>
let g:fzf_layout = { 'up': '~40%' }

" vim-test conf
let test#strategy = 'dispatch'
nmap <leader>n :TestNearest<CR>
nmap <leader>f :TestFile<CR>
nmap <leader>s :TestSuite<CR>
nmap <leader>l :TestLast<CR>
nmap <leader>g :TestVisit<CR>

"ALE conf"
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

augroup elixir
  nnoremap <leader>r :! elixir %<cr>
  autocmd FileType elixir nnoremap <c-]> :ALEGoToDefinition<cr>
augroup END

let g:ale_linters = {}
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']
let g:ale_linters.elixir = ['elixir-ls', 'credo']
let g:ale_linters.ruby = ['rubocop', 'ruby', 'solargraph']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
let g:ale_fixers.elm = ['format']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fixers.elixir = ['mix_format']
let g:ale_fixers.xml = ['xmllint']

let g:ale_sign_column_always = 1

nnoremap dt :ALEGoToDefinition<cr>
nnoremap df :ALEFix<cr>
nnoremap K :ALEHover<cr>

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

" vim-jsx conf
let g:jsx_ext_required = 0
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

"Goyo conf"
nnoremap <leader>gg :Goyo<CR>

let g:markdown_syntax_conceal = 0

nmap <leader>hl :w<cr> :!highlight -s dusk -O rtf % \| pbcopy<cr>

let g:Hexokinase_optInPatterns = [
\     'full_hex',
\     'triple_hex',
\     'rgb',
\     'rgba',
\     'hsl',
\     'hsla'
\ ]
