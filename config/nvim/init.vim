set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" lua vim.lsp.handlers = vim.lsp.callbacks

source ~/.vimrc

lua vim.lsp.set_log_level(0)
lua require('aniseed.env').init({force = true})

highlight! link LspDiagnosticsVirtualTextError Red
highlight! link LspDiagnosticsVirtualTextWarning Yellow
highlight! link LspDiagnosticsVirtualTextInformation Blue
highlight! link LspDiagnosticsVirtualTextHint Aqua
