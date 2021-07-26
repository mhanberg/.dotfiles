local nnoremap = require("motch.utils").nnoremap

vim.cmd [[command! -nargs=0 ZkIndex :lua require'lspconfig'.zk.index()]]
vim.cmd [[command! -nargs=? ZkNew :lua require'lspconfig'.zk.new(<args>)]]

vim.cmd [[command! ZkList :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=notes EDITOR=floaterm zk edit -i]]
vim.cmd [[command! ZkTags :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=tags zk list -q -f json | jq -r '. | map(.tags) | flatten | unique | join("\n")' | fzf | EDITOR=floaterm xargs -o -t zk edit -i -t]]
vim.cmd [[command! ZkBacklinks :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=backlinks EDITOR=floaterm zk edit -i -l %]]
vim.cmd [[command! ZkLinks :FloatermNew --autoclose=2 --position=top --opener=edit --width=0.9 --title=links EDITOR=floaterm zk edit -i -L %]]

_G.motch = {}
_G.motch.zk_list = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkList]]
end

_G.motch.zk_by_tags = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkTags]]
end
_G.motch.zk_backlinks = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkBacklinks]]
end

_G.motch.zk_links = function()
  vim.cmd [[autocmd User FloatermOpen ++once :tnoremap <buffer> <esc> <C-c>]]
  vim.cmd [[ZkLinks]]
end
local rooter = require("lspconfig").util.root_pattern(".zk")
local rooted = rooter(vim.api.nvim_buf_get_name(0))
local is_zk = vim.fn.empty(rooted)
if is_zk == 0  then
  nnoremap("<C-p>", ":lua motch.zk_list()<cr>")
  nnoremap("<space>zt", ":lua motch.zk_by_tags()<cr>")
  nnoremap("<space>zb", ":lua motch.zk_backlinks()<cr>")
  nnoremap("<space>zl", ":lua motch.zk_links()<cr>")
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
