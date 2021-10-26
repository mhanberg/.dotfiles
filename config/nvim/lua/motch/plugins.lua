local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[packadd packer.nvim]])

local startup = require("packer").startup

startup(function(use, use_rocks)
  use({ "wbthomason/packer.nvim", opt = true })
  use("tjdevries/nlua.nvim")
  use("norcalli/nvim.lua")
  use("tpope/vim-repeat")
  use("christoomey/vim-tmux-runner")
  use({ "rrethy/vim-hexokinase", run = "make hexokinase" })
  use("alvan/vim-closetag")
  use("junegunn/goyo.vim")
  use("AndrewRadev/splitjoin.vim")
  use("tpope/vim-vinegar")
  use("tpope/vim-commentary")
  use("tpope/vim-dispatch")
  use("vim-ruby/vim-ruby")
  use("tpope/vim-rsi")
  use("elixir-editors/vim-elixir")
  use("tpope/vim-fugitive")
  use("junegunn/gv.vim")
  use("airblade/vim-gitgutter")
  use("tpope/vim-sensible")
  use("vim-test/vim-test")
  use("christoomey/vim-tmux-navigator")
  use("tpope/vim-liquid")
  use("pangloss/vim-javascript")
  use("isRuslan/vim-es6")
  use("tpope/vim-surround")
  use("tpope/vim-eunuch")
  use("tpope/vim-projectionist")
  use("avakhov/vim-yaml")
  use("mattn/emmet-vim")
  use("tpope/vim-markdown")
  use({ "lukas-reineke/indent-blankline.nvim" })
  use({
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
  })
  use("junegunn/fzf.vim")
  use("farmergreg/vim-lastplace")
  use({ "mg979/vim-visual-multi", branch = "master" })
  use("ekalinin/Dockerfile.vim")
  use("stsewd/fzf-checkout.vim")
  use("reedes/vim-wordy")

  use("neovim/nvim-lspconfig")
  use("hrsh7th/nvim-cmp")

  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/vim-vsnip")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-emoji")
  use("hrsh7th/cmp-nvim-lua")
  use("f3fora/cmp-spell")

  use("onsails/lspkind-nvim")

  use("kabouzeid/nvim-lspinstall")

  use("nvim-lua/plenary.nvim")
  use("nvim-lua/telescope.nvim")
  use("APZelos/blamer.nvim")

  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      vim.cmd([[TSUpdate]])
    end,
  })

  use("tpope/vim-dadbod")
  use("kristijanhusak/vim-dadbod-ui")
  use("kristijanhusak/vim-dadbod-completion")

  use({ "nvim-treesitter/playground" })

  use("voldikss/vim-floaterm")

  use("rcarriga/nvim-notify")


  use("rktjmp/lush.nvim")



  use({ "ojroques/nvim-hardline" })

  use({ "tjdevries/astronauta.nvim" })


  use({
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("rest-nvim").setup()
    end,
  })

  use("hkupty/nvimux")

  use_rocks({ "underscore" })
  use_rocks({ "ansicolors" })
end)

require("packer.luarocks").setup_paths()

_ = require("underscore")
