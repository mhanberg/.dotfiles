; (with-eval-after-load 'eglot
;   (add-to-list 'eglot-server-programs
;                '(elixir-mode . ("/Users/mitchell/src/credo-language-server/bin/credo-language-server" "--stdio"))))

(unless (package-installed-p 'elixir-mode)
  (package-install 'elixir-mode))

(require 'eglot)

(setq eglot-server-programs `((elixir-mode . ("/Users/mitchell/src/credo-language-server/bin/credo-language-server" "--stdio"))))

(add-hook 'elixir-mode-hook 'eglot-ensure)
