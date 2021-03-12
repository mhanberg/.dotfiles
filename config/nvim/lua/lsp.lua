local lspconfig = require("lspconfig")
local completion = require("completion")

local nnoremap = require("utils").nnoremap
local imap = require("utils").imap
local smap = require("utils").smap

M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local has_run = {}

M.setup = function(name, opts)
  if not has_run[name] then
    has_run[name] = true
    lspconfig[name].setup(
      vim.tbl_extend(
        "force",
        {
          capabilities = capabilities,
          message_level = vim.lsp.protocol.MessageType.Log,
          log_level = vim.lsp.protocol.MessageType.Log,
          on_attach = function()
            completion.on_attach()

            nnoremap("df", "<cmd>lua vim.lsp.buf.formatting()<cr>")
            nnoremap("gd", "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<cr>")
            nnoremap("dt", "<cmd>lua vim.lsp.buf.definition()<cr>")
            nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
            nnoremap("gD", "<cmd>lua vim.lsp.buf.implementation()<cr>")
            -- nnoremap("<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
            nnoremap("1gD", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
            nnoremap("gr", "<cmd>lua require'telescope.builtin'.lsp_references{}<cr>")
            nnoremap("g0", "<cmd>lua require'telescope.builtin'.lsp_document_symbols{}<cr>")
            nnoremap("gW", "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<cr>")
            imap("<expr> <C-j>", "vsnip#available(1) ? '<Plug>(vsnip-expand)' : '<C-j>'")
            imap("<expr> <C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
            smap("<expr> <C-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'")
            imap("<expr> <Tab>", "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'")
            smap("<expr> <Tab>", "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'")
            imap("<expr> <S-Tab>", "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'")
            smap("<expr> <S-Tab>", "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'")
          end
        },
        opts
      )
    )
  end
end

require("nlua.lsp.nvim").setup(
  require("lspconfig"),
  {
    on_attach = function()
      require("completion").on_attach()
    end,
    globals = {"vim"}
  }
)

require("lspfuzzy").setup {}

vim.lsp.set_log_level(0)

return M
