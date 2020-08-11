"             _
"     _   __ (_)____ ___   _____ _____
"    | | / // // __ `__ \ / ___// ___/
"  _ | |/ // // / / / / // /   / /__
" (_)|___//_//_/ /_/ /_//_/    \___/
"

syntax on
set foldmethod=syntax
set foldlevelstart=99
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set termguicolors
set backupdir=~/.tmp/backup
set directory=~/.tmp/swp
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
set noerrorbells visualbell t_vb=

augroup random
  autocmd!

  autocmd VimResized * :wincmd =
  autocmd GUIEnter * set visualbell t_vb=
  autocmd FileType netrw call s:RemoveNetrwMap()
  autocmd BufRead,BufNewFile *.zsh-theme set filetype=zsh
  autocmd BufRead,BufNewFile *.lexs set filetype=elixir
augroup END

function s:RemoveNetrwMap()
  if hasmapto('<Plug>NetrwRefresh')
    unmap <buffer> <C-l>
  endif
endfunction

augroup clojure
  autocmd!

  au BufWritePost *.clj :silent Require
augroup END

augroup markdown
  autocmd BufRead,BufNewFile *.md setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal linebreak
  autocmd BufRead,BufNewFile,BufWritePost *.md let b:word_count = WordCount(expand("%:p"))
augroup END

function! WordCount(file)
  return trim(system('cat ' . a:file . ' | wc -w'))
endfunction

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'sainnhe/vim-color-forest-night'
Plug 'christoomey/vim-tmux-runner'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'alvan/vim-closetag'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/goyo.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rsi'
Plug 'elixir-editors/vim-elixir'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-sensible'
Plug 'vim-test/vim-test'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-liquid'
Plug 'pangloss/vim-javascript'
Plug 'isRuslan/vim-es6'
Plug 'mxw/vim-jsx'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-projectionist'
Plug 'avakhov/vim-yaml'
Plug 'chr4/nginx.vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-markdown'
Plug 'matze/vim-move'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'ekalinin/Dockerfile.vim'
Plug 'kana/vim-textobj-user'
Plug 'amiralies/vim-textobj-elixir'

if has('nvim-0.5.0')
echom 'nvim 5!'
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
endif

call plug#end()

if has('gui_macvim')
  set guioptions=
  set guifont=JetBrains\ Mono:h14
  set linespace=1

  set macmeta
endif

set cursorline
set background=dark
let g:forest_night_enable_italic = 1

colorscheme forest-night
let g:lightline = {
  \ 'colorscheme': 'forest_night',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \           [ 'readonly', 'relativepath', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \            [ 'percent' ],
  \            [ 'fileformat', 'fileencoding', 'filetype', 'wordcount' ] ] },
  \ 'component_function': {
  \   'wordcount': 'GetWordCount' },
  \ 'component_visible_condition': {
  \   'wordcount': '&spell' }
  \ }

function! GetWordCount()
  if &spell ==? '1'
    return b:word_count
  else
    return ''
  end
endfunction

let g:sneak#label = 1
let g:indentLine_fileTypeExclude = ['json']
let g:indentLine_char = '│'

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! W w
command! Wq wq
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'elixir', 'bash=sh', 'javascript']
" Disable K looking stuff up

nnoremap cn :cnext<cr>
nnoremap <leader><space> :set hls!<cr>
nnoremap <leader>ev :vsplit ~/.vimrc<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --glob ''!yarn.lock'' --glob ''!package-lock.json'' --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command], 'window': { 'width': 0.9, 'height': 0.6 }}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:fzf_preview_window = ''
call setenv('FZF_DEFAULT_OPTS', '--reverse')
silent! nnoremap <c-p> :Files<cr>
nnoremap gl :BLines<cr>
nnoremap <leader>a :RG<cr>
silent! nnoremap <leader>gr :grep<space>
nnoremap <leader>c :botright copen 20<cr>

let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.6 } }

" vim-test conf
let g:dispatch_handlers = ['job']
let test#strategy = 'dispatch'
nmap <leader>n :TestNearest<CR>
nmap <leader>f :TestFile<CR>
nmap <leader>s :TestSuite<CR>
nmap <leader>l :TestLast<CR>

" ctags
nnoremap <leader>ct :!ctags -R .<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>r :BTags<cr>

let g:ale_linters = {}
let g:ale_linters.scss = ['stylelint']
let g:ale_linters.css = ['stylelint']

if has('nvim-0.5.0')
let g:ale_linters.elixir = ['credo']
set completeopt=menuone,noinsert,noselect

let g:completion_enable_snippet = 'vim-vsnip'
let g:diagnostic_enable_virtual_text = 1

lua << elixirLS
local on_attach_vim = function()
  require'completion'.on_attach()
  require'diagnostic'.on_attach()
end
require'nvim_lsp'.elixirls.setup{
  on_attach = on_attach_vim;
  settings = {
    elixirLS = {
      dialyzerEnabled = false;
    };
  };
}
elixirLS

nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> dt <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

imap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-expand)' : '<C-j>'
imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab> vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

else
let g:ale_completion_enabled = 1
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_linters.elixir = ['elixir-ls', 'credo']

let g:ale_elixir_elixir_ls_release = expand('~/Development/elixir-ls/rel')
let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}

nnoremap dt :ALEGoToDefinition<cr>
nnoremap K :ALEHover<cr>
endif

nnoremap df :ALEFix<cr>
let g:ale_linters.ruby = ['rubocop', 'ruby', 'solargraph']

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.html = ['prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
let g:ale_fixers.elm = ['format']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fixers.elixir = ['mix_format']
let g:ale_fixers.xml = ['xmllint']

let g:ale_sign_column_always = 1
let g:ale_elixir_credo_strict = 1


set grepprg=ag\ --vimgrep\ -Q\ $*
set grepformat=%f:%l:%c:%m

" vim-jsx conf
let g:jsx_ext_required = 0
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

"Goyo conf"
nnoremap <leader>gy :Goyo<CR>
let g:goyo_width = 120
let g:goyo_height = 100

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
