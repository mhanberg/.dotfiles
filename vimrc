"             _
"     _   __ (_)____ ___   _____ _____
"    | | / // // __ `__ \ / ___// ___/
"  _ | |/ // // / / / / // /   / /__
" (_)|___//_//_/ /_/ /_//_/    \___/
"

function RemoveNetrwMap()
  if hasmapto('<Plug>NetrwRefresh')
    unmap <buffer> <C-l>
  endif
endfunction

if has('gui_macvim')
  set guioptions=
  set guifont=JetBrains\ Mono:h14
  set linespace=1

  set macmeta
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'Olical/aniseed', { 'branch': 'develop' }
Plug 'Olical/conjure', {'tag': 'v4.5.0'}
Plug 'norcalli/nvim.lua'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'bakpakin/fennel.vim'
Plug 'sainnhe/vim-color-forest-night', 
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
Plug 'stsewd/fzf-checkout.vim'
Plug 'reedes/vim-wordy'

if has('nvim-0.5.0')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/telescope.nvim'
  " Plug 'nvim-treesitter/nvim-treesitter'
endif

call plug#end()
