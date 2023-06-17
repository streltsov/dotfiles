-- Neovim configuration using Lua.
-- For more information, check these references:
-- https://nvimluau.dev/
-- https://github.com/jose-elias-alvarez/dotfiles/blob/main/config/nvim/lua/lsp/null-ls.lua

-- Automatically install Packer plugin manager if it's not already installed
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- Check if the install path is empty (Packer is not installed)
if fn.empty(fn.glob(install_path)) > 0 then
  -- Clone the Packer repository to the install path
  PACKER_BOOTSTRAP = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Installing Packer, please close and reopen Neovim...")
  -- Add packer to runtime path
  vim.cmd([[packadd packer.nvim]])
end

-- Set up an autocommand group for Packer.
-- The Packer config will be reloaded every time the plugins.lua file is saved.
vim.cmd([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Try to require Packer, if it fails (Packer is not installed), then return
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Define the list of plugins and configurations for Packer
return packer.startup(function(use)
  -- Packer manages its own updates
  use("wbthomason/packer.nvim") 
  -- Pre-configured setups for most popular language servers
  use 'neovim/nvim-lspconfig' 
  -- Plenary: a library with various utility functions
  use("nvim-lua/plenary.nvim") 
  -- Treesitter for improved syntax highlighting and code understanding
  use("nvim-treesitter/nvim-treesitter") 
  -- Gruvbox color scheme
  use("ellisonleao/gruvbox.nvim")
  -- Gitsigns for git annotations in the sign column
  use("lewis6991/gitsigns.nvim")
  -- Telescope for fuzzy finding and picking things
  use({ "nvim-telescope/telescope.nvim", requires = { "BurntSushi/ripgrep" } })
  -- Null-ls for using Neovim itself as a language server
  use("jose-elias-alvarez/null-ls.nvim")
  -- Trouble for pretty diagnostics, references, telescope results etc in an easy to navigate sidebar
  use("folke/trouble.nvim")
  -- Github Copilot extension
  use ("zbirenbaum/copilot.lua")
  -- Vimwiki for note taking and todo system
  use("vimwiki/vimwiki")
  -- Calendar plugin for vim
  use("mattn/calendar-vim")
  -- Indent guides for code indentation
  use("lukas-reineke/indent-blankline.nvim")
  -- Snippy for snippet support
  use("dcampos/nvim-snippy")
  use("kelly-lin/ranger.nvim")
  use("airblade/vim-rooter")
  use("Pocco81/true-zen.nvim")

  -- Nvim-cmp for autocompletion with several sources
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",  -- Buffer source for nvim-cmp
      "dcampos/cmp-snippy",  -- Snippy source for nvim-cmp
      "hrsh7th/cmp-path",  -- Filesystem/Path source for nvim-cmp
    },
  })

  -- If Packer was just installed, perform a sync operation to install all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

