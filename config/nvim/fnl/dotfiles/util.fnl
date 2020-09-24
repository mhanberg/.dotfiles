(module dotfiles.util
  {require {nvim aniseed.nvim}})

(defn expand [path]
  (nvim.fn.expand path))

(defn glob [path]
  (nvim.fn.glob path true true true))

(defn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(defn lua-file [path]
  (nvim.ex.luafile path))

(def config-path (nvim.fn.stdpath "config"))

(defn cmd [command]
  (nvim.fn.system command))

(defn nvim-version []
  (if
    (= 1 (nvim.fn.has "nvim-0.5.0")) 5
    (= 1 (nvim.fn.has "nvim-0.4.0")) 4))

(defn nnoremap [from to]
  (nvim.set_keymap
    :n
    (.. "<leader>" from)
    (.. ":" to "<cr>")
    {:noremap true}))

(defn augroup [name callback]
  (nvim.command (.. "augroup " name))
  (nvim.command "autocmd!")
  (callback)
  (nvim.command "augroup END"))

(defn autocmd [cmd]
  (nvim.command (.. "autocmd " cmd)))

