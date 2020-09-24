(module dotfiles.module.core
  {require {core aniseed.core
            str aniseed.string
            util dotfiles.util
            nvim aniseed.nvim
            fennel aniseed.fennel
            nvim-util aniseed.nvim.util}
   require-macros [:macros]})

(defn set-word-count [file]
 (let [file (util.expand file)
     count (-> (.. "cat " file " | wc -w")
               (util.cmd)
               (str.trim))]
 (set nvim.b.word_count count)))

(defn get-word-count []
 (if nvim.wo.spell
     nvim.b.word_count
     ""))

(nvim-util.fn-bridge "GetWordCount" :dotfiles.module.core :get-word-count {:return true})

(set nvim.o.syntax "true")
(set nvim.o.splitbelow true)
(set nvim.o.termguicolors true)
(set nvim.o.foldmethod "syntax")
(set nvim.o.foldlevelstart 99)
(set nvim.o.smartindent true)
(set nvim.o.tabstop 2)
(set nvim.o.shiftwidth 2)
(set nvim.o.expandtab true)
(set nvim.o.number true)
(set nvim.o.termguicolors true)
(set nvim.o.backupdir (util.expand "~/.tmp/backup"))
(set nvim.o.directory (util.expand "~/.tmp/swp"))
(set nvim.o.splitright true)
(set nvim.o.lazyredraw true)
(set nvim.o.showmode false)
(set nvim.o.incsearch true)
(set nvim.o.ignorecase true)
(set nvim.o.smartcase true)
(set nvim.o.undofile true)
(set nvim.o.undodir (util.expand "~/.tmp"))
(set nvim.o.mouse "a")
(set nvim.o.errorbells false)
(set nvim.o.visualbell true)
(set nvim.o.t_vb "")
(set nvim.o.cursorline true)
(set nvim.o.background "dark")
(nvim.ex.colorscheme "forest-night")

(set nvim.g.lightline
  {
    :colorscheme :forest_night
    :active {
       :left [[:mode :paste] [:readonly :relativepath :modified]]
       :right [[:lineinfo] [:percent] [:fileformat :fileencoding :filetype :wordcount]]
     }
     :component_function {:wordcount "GetWordCount"}
     :component_visible_condition {:wordcount "&spell"}
    })

(set nvim.g.indentLine_fileTypeExclude [:json])
(set nvim.g.indentLine_char "│")

(set nvim.g.markdown_fenced_languages [:html :vim :ruby :elixir :bash=sh :javascript])

(set nvim.g.sexp_filetypes "clojure,scheme,lisp,timl,fennel")

(nvim.ex.command_ "Q q")
(nvim.ex.command_ "Qall qall")
(nvim.ex.command_ "QA qall")
(nvim.ex.command_ "E e")
(nvim.ex.command_ "W w")
(nvim.ex.command_ "Wq wq")

(set nvim.env.FZF_DEFAULT_OPTS "--reverse")
(set nvim.g.fzf_preview_window "")
(set nvim.g.fzf_layout {:window {:width 0.5 :height 0.6 :yoffset 0 :highlight "Normal"}})

(defn ripgrep-fzf [query fullscreen]
  (let [command-fmt "rg --glob '!yarn.lock' --glob '!package-lock.json' --column --line-number --no-heading --color=always --smart-case %s || true"
        initial-command (nvim.fn.printf command-fmt (nvim.fn.shellescape query))
        reload-command (nvim.fn.printf command-fmt "{q}")
        spec {:options ["--phony" "--query" query "--bind" (.. "change:reload:" reload-command)]
              :window {:width 0.9
                       :height 0.6
                       :yoffset 0
                       :highlight "Normal"}}]
    (nvim.fn.fzf#vim#grep initial-command 1 (nvim.fn.fzf#vim#with_preview spec) fullscreen)))

(nvim.ex.command_ "-nargs=* -bang RG lua require'dotfiles.module.core'['ripgrep-fzf'](<q-args>, <bang>0)")

(nvim.set_keymap :n "cn" ":cnext<cr>" {:noremap true})
(nvim.set_keymap :n "<leader><space>" ":set hls!<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>ev" ":vsplit ~/.vimrc<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>sv" ":source $MYVIMRC<cr>" {:noremap true})
(nvim.set_keymap :n "<c-p>" ":Files<cr>" {:silent true :noremap true})
(nvim.set_keymap :n "gl" ":BLines<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>a" ":RG<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>gr" ":grep<cr>" {:silent true :noremap true})
(nvim.set_keymap :n "<leader>c" ":botright copen 20<cr>" {:noremap true})

; vim-test conf
(set nvim.g.dispatch_handlers ["job"])
(set nvim.g.test#strategy "dispatch")
(nvim.set_keymap :n "<leader>n" ":TestNearest<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>f " ":TestFile<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>s" ":TestSuite<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>l" ":TestLast<cr>" {:noremap true})

; ctags
(nvim.set_keymap :n "<leader>ct" ":!ctags -R .<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>t" ":Tags<cr>" {:noremap true})
(nvim.set_keymap :n "<leader>r" ":BTags" {:noremap true})

; ale
(set nvim.g.ale_linters {:scss ["stylelint"] :css ["stylelint"]})

(if (= 5 (util.nvim-version))
  (do
    (print "nvim 5")
    (set nvim.g.ale_linters.elixir ["credo"])
    (set nvim.o.completeopt "menuone,noinsert,noselect")
    (set nvim.g.completion_enable_snippet "vim-vsnip")
    (set nvim.g.diagnostic_enable_virtual_text 1)
    (setup-lsp :elixirls
      { :settings {:elixirLS {:dializerEnabled false }}
        :log_level vim.lsp.protocol.MessageType.Log})
    (nvim.set_keymap :n "gd" "<cmd>lua vim.lsp.buf.declaration()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "dt" "<cmd>lua vim.lsp.buf.definition()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "K " "<cmd>lua vim.lsp.buf.hover()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "gD" "<cmd>lua vim.lsp.buf.implementation()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "<c-k>" "<cmd>lua vim.lsp.buf.signature_help()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "1gD" "<cmd>lua vim.lsp.buf.type_definition()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "gr" "<cmd>lua vim.lsp.buf.references()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "g0" "<cmd>lua vim.lsp.buf.document_symbol()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :n "gW" "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>" {:noremap true :silent true})
    (nvim.set_keymap :i "<expr> <C-j>" "vsnip#available(1) ? '<Plug>(vsnip-expand)' : '<C-j>'" {})
    (nvim.set_keymap :i "<expr> <C-l>" "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'" {})
    (nvim.set_keymap :s "<expr> <C-l>" "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'" {})
    (nvim.set_keymap :i "<expr> <Tab>" "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'" {})
    (nvim.set_keymap :s "<expr> <Tab>" "vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'" {})
    (nvim.set_keymap :i "<expr> <S-Tab>" "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'" {})
    (nvim.set_keymap :s "<expr> <S-Tab>" "vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'" {}))
  (do
    (print "nvim 4")
    (set nvim.g.ale_completion_enabled 1)
    (set nvim.o.completeopt "menu,menuone,preview,noselect,noinsert")
    (set nvim.g.ale_linters.elixir ["elixir-ls" "credo"])
    (set nvim.g.ale_elixir_elixir_ls_release (util.expand "~/Development/elixir-ls/rel"))
    (set nvim.g.ale_elixir_elixir_ls_config {:elixirLS {:dialyzerEnabled false}})
    (nvim.set_keymap :n "dt" ":ALEGoToDefinition<cr>" {:noremap true})
    (nvim.set_keymap :n "K" ":ALEHover<cr>" {:noremap true})))


(nvim.set_keymap :n "df" ":ALEFix<cr>" {:noremap true})
(set nvim.g.ale_linters.ruby [:rubocop :ruby :solargraph])
(set nvim.g.ale_fixers
 {:* [:remove_trailing_lines :trim_whitespace]
  :javascript [:eslint :prettier]
  :html [:prettier]
  :scss [:stylelint]
  :css [:stylelint]
  :elm [:format]
  :ruby [:rubocop]
  :elixir [:mix_format]
  :xml [:xmllint]
 })

(set nvim.g.ale_sign_column_always 1)
(set nvim.g.ale_elixir_credo_strict 1)
(set nvim.o.grepprg "ag --vimgrep -Q $*")
(set nvim.o.grepformat "%f:%l:%c:%m")

(set nvim.g.jsx_ext_required 0)
(let [path (util.expand "~/.vimrc.local")]
 (when (util.exists? path) (nvim.ex.source path)))

(nvim.set_keymap :n "<leader>gy" ":Goyo<cr>" {:noremap true})
(set nvim.g.goyo_width 120)
(set nvim.g.goyo_height 100)

(set nvim.g.markdown_syntax_conceal 0)

; (nvim.set_keymap :n "<leader>hl" ":w<cr> :!highlight -s dusk -O rtf % \| pbcopy<cr>" {})

(set nvim.g.Hexokinase_optInPatterns [:full_hex :triple_hex :rgb :rgba :hsl :hsla])

(augroup :random
  (autocmd "VimResized * :wincmd =")
  (autocmd "GUIEnter * set visualbell t_vb=")
  (autocmd "FileType netrw call RemoveNetrwMap()")
  (autocmd "BufRead,BufNewFile *.zsh-theme set filetype=zsh")
  (autocmd "BufRead,BufNewFile *.lexs set filetype=elixir"))

(augroup :clojure
  (autocmd "BufWritePost *.clj :silent Require"))

(augroup :markdown
  (autocmd "BufRead,BufNewFile *.md setlocal spell")
  (autocmd "BufRead,BufNewFile *.md setlocal linebreak")
  (autocmd "BufRead,BufNewFile,BufWritePost *.md lua require'dotfiles.module.core'['set-word-count']('%:p')"))
