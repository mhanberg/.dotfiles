local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[packadd packer.nvim]])

local startup = require("packer").startup

startup({
  function(use, use_rocks)
    use({ "wbthomason/packer.nvim", opt = true })

    use("~/src/zk.nvim")
    use("elixir-editors/vim-elixir")
    use("ruanyl/vim-gh-line")
    use("APZelos/blamer.nvim")
    use("AndrewRadev/splitjoin.vim")
    use("alvan/vim-closetag")
    use("christoomey/vim-tmux-navigator")
    use("christoomey/vim-tmux-runner")
    use("f3fora/cmp-spell")
    use("farmergreg/vim-lastplace")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-vsnip")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/vim-vsnip")
    use("junegunn/fzf.vim")
    use("junegunn/goyo.vim")
    use("williamboman/nvim-lsp-installer")
    use("kristijanhusak/vim-dadbod-completion")
    use("kristijanhusak/vim-dadbod-ui")
    use("neovim/nvim-lspconfig")
    use("norcalli/nvim.lua")
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/telescope.nvim")
    use("onsails/lspkind-nvim")
    use("rcarriga/nvim-notify")
    use("stsewd/fzf-checkout.vim")
    use("tjdevries/nlua.nvim")
    use("tpope/vim-commentary")
    use("tpope/vim-dadbod")
    use("tpope/vim-dispatch")
    use("tpope/vim-eunuch")
    use("tpope/vim-fugitive")
    use("tpope/vim-projectionist")
    use("tpope/vim-repeat")
    use("tpope/vim-rsi")
    use("tpope/vim-surround")
    use("tpope/vim-vinegar")
    use("vim-test/vim-test")
    use({ "NTBBloodbath/rest.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use({
      "junegunn/fzf",
      run = function()
        vim.fn["fzf#install"]()
      end,
    })
    use({ "gfanto/fzf-lsp.nvim" })
    use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "mg979/vim-visual-multi", branch = "master" })
    use({ "mhanberg/thicc_forest", requires = { "rktjmp/lush.nvim" } })
    use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })
    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        vim.cmd([[TSUpdate]])
      end,
    })
    use({ "nvim-treesitter/playground" })
    use({ "rrethy/vim-hexokinase", run = "make hexokinase" })

    use("lukas-reineke/cmp-rg")

    use({ "kristijanhusak/vim-carbon-now-sh" })
    use({ "junegunn/vim-easy-align" })

    use_rocks({ "underscore" })
    use_rocks({ "ansicolors" })
  end,
  config = {
    max_jobs = 30,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
  },
})

require("packer.luarocks").setup_paths()
