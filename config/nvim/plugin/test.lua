local nnoremap = require("motch.utils").nnoremap

nnoremap("<leader>n", ":TestNearest<cr>")
nnoremap("<leader>f", ":TestFile<cr>")
nnoremap("<leader>s", ":TestSuite<cr>")
nnoremap("<leader>l", ":TestLast<cr>")

vim.cmd([[
function! MotchStrategy(cmd) abort
  autocmd User FloatermOpen ++once execute "normal G" | wincmd p

  execute 'FloatermNew --autoclose=1 --wintype=split --height=0.3 --autoinsert=0 '.a:cmd
endfunction

let g:test#custom_strategies = {'motch': function('MotchStrategy')}
let g:test#strategy = 'motch'
]])

vim.g["test#neovim#start_normal"] = 1

vim.g["test#javascript#jest#executable"] = "bin/test"

vim.g["test#strategy"] = "dispatch"
