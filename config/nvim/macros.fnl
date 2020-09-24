(fn augroup [name ...]
  `(do
     (nvim.command (.. "augroup " ,name))
     (nvim.command "autocmd!")
     (do ,...)
     (nvim.command "augroup END")))

(fn autocmd [cmd]
  `(nvim.command (.. "autocmd " ,cmd)))

(fn setup-lsp [name settings]
  `(let [lsp# (require "nvim_lsp")
        comp# (require "completion")
        diag# (require "diagnostic")]
    ((. lsp# ,name :setup)
      (core.merge
        {:on_attach (fn [] (comp#.on_attach) (diag#.on_attach))}
        ,settings)
       )))

{:augroup augroup
 :autocmd autocmd
 :setup-lsp setup-lsp}
