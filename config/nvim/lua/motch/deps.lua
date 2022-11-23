local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[packadd packer.nvim]])

local startup = require("packer").startup

startup {
  function(use, use_rocks)
    use { "wbthomason/packer.nvim", opt = true }

    use("~/src/zk.nvim")
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
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-vsnip")

    -- Lua
    use {
      "narutoxy/silicon.lua",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("silicon").setup {}
      end,
    }

    -- Packer
    use {
      "folke/noice.nvim",
      requires = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
      },
    }

    -- Lua
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end,
    }

    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    }

    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/vim-vsnip")
    use("junegunn/fzf.vim")
    -- use("junegunn/goyo.vim")
    use("williamboman/nvim-lsp-installer")
    use("kristijanhusak/vim-dadbod-completion")
    use("kristijanhusak/vim-dadbod-ui")
    use("neovim/nvim-lspconfig")
    use("norcalli/nvim.lua")
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/telescope.nvim")
    use("onsails/lspkind-nvim")
    use("stsewd/fzf-checkout.vim")
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
    use { "NTBBloodbath/rest.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use {
      "junegunn/fzf",
      run = function()
        vim.fn["fzf#install"]()
      end,
    }
    use { "gfanto/fzf-lsp.nvim" }
    -- use({ "/Users/mitchell/src/fzf-lsp.nvim" })
    use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use { "lukas-reineke/indent-blankline.nvim" }
    use { "mg979/vim-visual-multi", branch = "master" }
    use { "sainnhe/everforest" }
    use { "~/src/thicc_forest", requires = { "rktjmp/lush.nvim" } }
    use { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        vim.cmd([[TSUpdate]])
      end,
    }
    use { "nvim-treesitter/nvim-treesitter-textobjects" }
    use { "nvim-treesitter/nvim-treesitter-context" }
    use { "nvim-treesitter/playground" }

    use("lukas-reineke/cmp-rg")

    use { "kristijanhusak/vim-carbon-now-sh" }
    use { "junegunn/vim-easy-align" }

    use { "simrat39/symbols-outline.nvim" }

    use { "mhanberg/elixir.nvim" }
    use { "mfussenegger/nvim-dap" }

    use("Pocco81/true-zen.nvim")

    use {
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
    }

    use_rocks { "underscore" }
    use_rocks { "ansicolors" }
  end,
  config = { max_jobs = 30 },
}

require("packer.luarocks").setup_paths()