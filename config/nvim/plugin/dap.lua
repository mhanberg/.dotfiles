local dap = require("dap")

dap.adapters.mix_task = {
  type = "executable",
  command = vim.fn.expand("~/.local/share/nvim/lsp_servers/elixir/elixir-ls/rel/debugger.sh"), -- debugger.bat for windows
  args = {},
}

dap.configurations.elixir = {
  {
    type = "mix_task",
    name = "mix test",
    task = "test",
    taskArgs = { "--trace" },
    request = "launch",
    startApps = true, -- for Phoenix projects
    projectDir = "${workspaceFolder}",
    requireFiles = {
      "test/**/test_helper.exs",
      "test/**/*_test.exs",
    },
  },
  {
    type = "mix_task",
    name = "phx.server",
    request = "launch",
    task = "phx.server",
    projectDir = ".",
  },
}

_G.motch.dap = dap

-- nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
-- nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
-- nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
-- nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
-- nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
-- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
