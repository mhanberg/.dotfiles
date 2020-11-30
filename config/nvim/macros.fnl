(fn augroup [name ...]
  `(do
     (nvim.command (.. "augroup " ,name))
     (nvim.command "autocmd!")
     (do ,...)
     (nvim.command "augroup END")))

(fn autocmd [cmd]
  `(nvim.command (.. "autocmd " ,cmd)))

(fn setup-lsp [name settings]
  `(let [lsp# (require "lspconfig")
        comp# (require "completion")]
    ((. lsp# ,name :setup)
      (core.merge
        {:message_level vim.lsp.protocol.MessageType.Log
         :log_level vim.lsp.protocol.MessageType.Log
         :handlers {:window/logMessage
                    (fn [err# method# params# client_id#]
                      (print "im in my handler")
                      (if (and params# (<= params#.type vim.lsp.protocol.MessageType.Log))
                        (let [filename# (path_join (vim.fn.stdpath :data) :lsp.log)]
                          (with-open [logfile# (io.open filename :w)]
                                     (logfile#:write (vim.inspect params#.message {:newline ""}))
                                     (logfile#:write "this is mitch")
                                     ))))}
         :on_attach
           (fn []
             (print (.. "attaching to " ,name))
             (comp#.on_attach)
             (nvim.set_keymap :n "df" "<cmd>lua vim.lsp.buf.formatting_sync()<cr>" {:noremap true :silent true})

             (nvim.set_keymap :n "gd" "<cmd>lua vim.lsp.buf.declaration()<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "dt" "<cmd>lua vim.lsp.buf.definition()<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "K" "<cmd>lua vim.lsp.buf.hover()<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "gD" "<cmd>lua vim.lsp.buf.implementation()<cr>" {:noremap true :silent true})
             ; (nvim.set_keymap :n "<c-k>" "<cmd>lua vim.lsp.buf.signature_help()<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "1gD" "<cmd>lua vim.lsp.buf.type_definition()<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "gr" "<cmd>lua require'telescope.builtin'.lsp_references{}<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "g0" "<cmd>lua require'telescope.builtin'.lsp_document_symbols{}<cr>" {:noremap true :silent true})
             (nvim.set_keymap :n "gW" "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<cr>" {:noremap true :silent true})
             (nvim.set_keymap :i "<expr> <C-j>" "vsnip#available(1) ? '<Plug>(vsnip-expand)' : '<C-j>'" {})
             (nvim.set_keymap :i "<expr> <C-l>" "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'" {})
             (nvim.set_keymap :s "<expr> <C-l>" "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'" {})
             (nvim.set_keymap :i "<expr> <Tab>" "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'" {})
             (nvim.set_keymap :s "<expr> <Tab>" "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'" {})
             (nvim.set_keymap :i "<expr> <S-Tab>" "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'" {})
             (nvim.set_keymap :s "<expr> <S-Tab>" "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'" {}))}
        ,settings))))

{:augroup augroup
 :autocmd autocmd
 :setup-lsp setup-lsp}
