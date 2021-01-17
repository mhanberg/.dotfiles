local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

function RemoveNetrwMap()
  if fn.hasmapto("<Plug>NetrwRefresh") > 0 then
    vim.cmd("unmap <buffer> <C-l>")
  end
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use {'wbthomason/packer.nvim', opt = true}
  use 'tjdevries/nlua.nvim'
  use {"Olical/aniseed", tag = "v3.12.0"}
  use "norcalli/nvim.lua"
  use "guns/vim-sexp"
  use "tpope/vim-sexp-mappings-for-regular-people"
  use "tpope/vim-repeat"
  use "bakpakin/fennel.vim"
  use "sainnhe/vim-color-forest-night"
  use "christoomey/vim-tmux-runner"
  use {"rrethy/vim-hexokinase", run = "make hexokinase" }
  use "alvan/vim-closetag"
  use "itchyny/lightline.vim"
  use "junegunn/goyo.vim"
  use "AndrewRadev/splitjoin.vim"
  use "tpope/vim-vinegar"
  use "tpope/vim-commentary"
  use "tpope/vim-dispatch"
  use "vim-ruby/vim-ruby"
  use "tpope/vim-rsi"
  use "elixir-editors/vim-elixir"
  use "tpope/vim-endwise"
  use "tpope/vim-fugitive"
  use "airblade/vim-gitgutter"
  use "tpope/vim-rails"
  use "tpope/vim-sensible"
  use "vim-test/vim-test"
  use "christoomey/vim-tmux-navigator"
  use "tpope/vim-liquid"
  use "pangloss/vim-javascript"
  use "isRuslan/vim-es6"
  use "mxw/vim-jsx"
  use "jiangmiao/auto-pairs"
  use "tpope/vim-surround"
  use "tpope/vim-eunuch"
  use "tpope/vim-projectionist"
  use "avakhov/vim-yaml"
  use "chr4/nginx.vim"
  use "mattn/emmet-vim"
  use "tpope/vim-markdown"
  use "matze/vim-move"
  use "Yggdroot/indentLine"
  use {"junegunn/fzf",
        run = function()
          vim.fn['fzf#install']()
        end}
  use "junegunn/fzf.vim"
  use "farmergreg/vim-lastplace"
  use {"mg979/vim-visual-multi", branch = "master"}
  use "ekalinin/Dockerfile.vim"
  use "kana/vim-textobj-user"
  use "amiralies/vim-textobj-elixir"
  use "stsewd/fzf-checkout.vim"
  use "reedes/vim-wordy"

  use "neovim/nvim-lspconfig"
  use "nvim-lua/completion-nvim"
  use "hrsh7th/vim-vsnip"
  use "hrsh7th/vim-vsnip-integ"

  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/telescope.nvim"
  use "ttys3/nvim-blamer.lua"
  use "hashivim/vim-terraform"
  use "pwntester/octo.nvim"
  use {
    'ojroques/nvim-lspfuzzy',
    requires = {
      {'junegunn/fzf'},
      {'junegunn/fzf.vim'},  -- to enable preview (optional)
    },
  }
  use {
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end}
end)

nvim = require("nvim")
require('lspfuzzy').setup {}

vim.lsp.set_log_level(0)

get_lua_runtime = function()
    local result = {};
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/";
        if vim.fn.isdirectory(lua_path) then
            result[lua_path] = true
        end
    end

    -- This loads the `lua` files from nvim into the runtime.
    result[vim.fn.expand("$VIMRUNTIME/lua")] = true

    -- TODO: Figure out how to get these to work...
    --  Maybe we need to ship these instead of putting them in `src`?...
    result[vim.fn.expand("~/build/neovim/src/nvim/lua")] = true

    nvim.print(result)
    return result;
    -- this is necessary to use aniseed with packer as of now
end
vim.cmd [[packadd aniseed]]
require('aniseed.env').init({force = true})

vim.cmd [[highlight! link LspDiagnosticsVirtualTextError Red]]
vim.cmd [[highlight! link LspDiagnosticsVirtualTextWarning Yellow]]
vim.cmd [[highlight! link LspDiagnosticsVirtualTextInformation Blue]]
vim.cmd [[highlight! link LspDiagnosticsVirtualTextHint Aqua]]
