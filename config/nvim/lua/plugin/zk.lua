local nnoremap = require("motch.utils").nnoremap

vim.cmd [[command! -nargs=0 ZkIndex :lua require'lspconfig'.zk.index()]]
vim.cmd [[command! -nargs=? ZkNew :lua require'lspconfig'.zk.new(<args>)]]

vim.cmd [[command! ZkList :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=zk EDITOR=floaterm zk edit -i]]
vim.cmd [[command! ZkTags :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=zk zk list -q -f json | jq -r '. | map(.tags) | flatten | unique | join("\n")' | fzf | EDITOR=floaterm xargs -o -t zk edit -i -t]]

_G.motch = {}
_G.motch.zk_list = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkList]]
end

_G.motch.zk_by_tags = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkTags]]
end
local rooter = require("lspconfig").util.root_pattern(".zk")
local rooted = rooter(vim.api.nvim_buf_get_name(0))
local is_zk = vim.fn.empty(rooted)
if is_zk == 0  then
  nnoremap("<C-p>", ":lua motch.zk_list()<cr>")
  nnoremap("<space>lt", ":lua motch.zk_by_tags()<cr>")
end

require("zk").setup(
  {
    debug = false,
    log = true,
    default_keymaps = true,
    default_notebook_path = vim.env.ZK_NOTEBOOK_DIR or ".",
    fuzzy_finder = "fzf", -- or "telescope"
    link_format = "markdown" -- or "wiki"
  }
)
