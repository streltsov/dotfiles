-- https://nvimluau.dev/
-- https://github.com/jose-elias-alvarez/dotfiles/blob/main/config/nvim/lua/lsp/null-ls.lua

-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP =
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
  use("nvim-treesitter/nvim-treesitter")

  use("ellisonleao/gruvbox.nvim") -- Gruvbox lua ported colorscheme

  use("lewis6991/gitsigns.nvim")

  use({ "nvim-telescope/telescope.nvim", requires = { "BurntSushi/ripgrep" } })

  use("jose-elias-alvarez/null-ls.nvim")
  use("folke/trouble.nvim")
  use ("zbirenbaum/copilot.lua")

  use("vimwiki/vimwiki")
  use("mattn/calendar-vim")

  use("lukas-reineke/indent-blankline.nvim")
  use("dcampos/nvim-snippy")
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "dcampos/cmp-snippy",
      "hrsh7th/cmp-path",
    },
  })

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
