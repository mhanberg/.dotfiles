set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" lua vim.lsp.handlers = vim.lsp.callbacks

source ~/.vimrc

lua vim.lsp.set_log_level(0)
lua require('aniseed.env').init({force = true})

highlight! link LspDiagnosticsDefaultError Red
highlight! link LspDiagnosticsDefaultWarning Yellow
highlight! link LspDiagnosticsDefaultInformation Blue
highlight! link LspDiagnosticsDefaultHint Aqua
