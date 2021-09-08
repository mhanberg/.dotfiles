local lspconfig = require("lspconfig")
-- vim.notify = require("notify")

local configs = require("lspconfig/configs")

require("lspinstall").setup()

configs.zk = {
  default_config = {
    cmd = { "zk", "lsp" },
    filetypes = { "markdown", "liquid" },
    root_dir = lspconfig.util.root_pattern(".zk"),
    settings = {},
  },
}

configs.zk.index = function()
  vim.lsp.buf.execute_command({
    command = "zk.index",
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

configs.zk.new = function(...)
  vim.lsp.buf_request(0, "workspace/executeCommand", {
    command = "zk.new",
    arguments = {
      vim.api.nvim_buf_get_name(0),
      ...,
    },
  }, function(_, _, result)
    if not (result and result.path) then
      return
    end
    vim.cmd("edit " .. result.path)
  end)
end

M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_run = {}

M.on_attach = function(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = { noremap = true, silent = true }

  map("n", "df", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<cr>", map_opts)
  map("n", "gd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", map_opts)
  map("n", "dt", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
  map("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<cr>", map_opts)
  -- map("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", map_opts)
  map("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", map_opts)
  map("n", "gr", "<cmd>lua require'telescope.builtin'.lsp_references{}<cr>", map_opts)
  map("n", "g0", "<cmd>lua require'telescope.builtin'.lsp_document_symbols{}<cr>", map_opts)
  map("n", "gW", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<cr>", map_opts)

  vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
  vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

  vim.cmd([[imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']])
  vim.cmd([[smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']])
  vim.cmd([[imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']])
  vim.cmd([[smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']])

  vim.cmd([[inoremap <silent><expr> <C-Space> compe#complete()]])
  vim.cmd([[inoremap <silent><expr> <CR> compe#confirm('<CR>')]])
  vim.cmd([[inoremap <silent><expr> <C-e> compe#close('<C-e>')]])
  vim.cmd([[inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })]])
  vim.cmd([[inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })]])
end

vim.lsp.handlers["window/logMessage"] = function(_, _, log)
  if log.type == 4 then
    -- vim.notify(log.message, "info", {icon = ""})
    print(log.message)
  end
end

require("compe").setup({
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "disabled",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    calc = true,
    vsnip = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    treesitter = true,
    vim_dadbod_completion = true,
  },
})

M.setup = function(name, opts)
  if not has_run[name] then
    has_run[name] = true
    lspconfig[name].setup(vim.tbl_extend("force", {
      log_level = vim.lsp.protocol.MessageType.Log,
      message_level = vim.lsp.protocol.MessageType.Log,
      capabilities = capabilities,
      on_attach = M.on_attach,
    }, opts))
  end
end

if
  vim.fn.executable(vim.fn.expand("~/.cache/nvim/nlua/sumneko_lua/lua-language-server/bin/OSX/lua-language-server")) > 0
then
  require("nlua.lsp.nvim").setup(require("lspconfig"), {
    on_attach = M.on_attach,
    globals = { "vim" },
  })
end

-- require("lspfuzzy").setup {}
vim.lsp.set_log_level(0)

return M
