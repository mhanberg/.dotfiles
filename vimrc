syntax on
set smartindent
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set termguicolors
set backupdir=~/.tmp
set directory=~/.tmp

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'slashmili/alchemist.vim'
Plug 'kien/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-dispatch'
Plug 'elixir-editors/vim-elixir'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-sensible'
Plug 'janko-m/vim-test'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

colorscheme slate
let g:NERDTreeWinPos = "right"
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let test#strategy = "dispatch"
nmap <leader>n :TestNearest<CR> 
nmap <leader>f :TestFile<CR>
nmap <leader>s :TestSuite<CR>
nmap <leader>l :TestLast<CR>
nmap <leader>g :TestVisit<CR>
let g:vim_markdown_preview_hotkey='<C-m>'
nmap <leader>m :call Vim_Markdown_Preview()<CR>
