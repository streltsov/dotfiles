require("min.options")
require("min.vimwiki")
require("min.diagnostic")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "ellisonleao/gruvbox.nvim",
  "lewis6991/gitsigns.nvim",
  "folke/trouble.nvim",
  "zbirenbaum/copilot.lua",
  "lukas-reineke/indent-blankline.nvim",
  "kelly-lin/ranger.nvim",
  "airblade/vim-rooter",
  "robitx/gp.nvim",
  "vimwiki/vimwiki",
  "akinsho/toggleterm.nvim",
  -- "serenevoid/kiwi.nvim",
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  { "nvim-telescope/telescope.nvim", dependencies = { "BurntSushi/ripgrep" } },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" } },
})

require("min.telescope")
require("min.gitsigns")
require("min.trouble")
require("min.copilot")
require("min.completion")
require("min.null-ls")
require("min.colorscheme")
require("min.lsp")
require("min.ranger")
require("min.treesitter")
require("min.gp")
