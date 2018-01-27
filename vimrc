syntax on
set smartindent
set softtabstop=4
set shiftwidth=4
set expandtab
set number
set termguicolors

execute pathogen#infect()
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
nmap <leader>m :call Vim_Markdown_Preview()<CR>
