local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path, }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Fix problems before save
vim.cmd [[
  augroup fix_before_save
    autocmd!
    autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  use "wbthomason/packer.nvim"                                   -- Have packer manage itself
 -- use "nvim-lua/plenary.nvim"                                    -- Useful lua functions used ny lots of plugins
  use "neovim/nvim-lspconfig"                                    -- enable LSP
  use "ellisonleao/gruvbox.nvim"                                 -- Gruvbox lua ported colorscheme

  -- use "lewis6991/gitsigns.nvim"                                  -- Git signs
  -- use "lukas-reineke/indent-blankline.nvim"                      -- Indent blankline
  -- use "mattn/emmet-vim"                                          -- Emmet
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

end)

  -- use "jose-elias-alvarez/null-ls.nvim"
  -- use "jose-elias-alvarez/nvim-lsp-ts-utils"
  -- use "nvim-lua/popup.nvim"                                      -- An implementation of the Popup API from vim in Neovim
  -- use "williamboman/nvim-lsp-installer"                          -- Simple to use language server installer
  -- use "mfussenegger/nvim-lint"
  -- require 'lspconfig'.tsserver.setup {}
  -- use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }   -- Treesitter
  -- use "hrsh7th/nvim-cmp"                                         -- Autocompletion plugin
  -- use "hrsh7th/cmp-nvim-lsp"                                     -- LSP source for nvim-cmp
  -- use "jose-elias-alvarez/null-ls.nvim"                          -- Formatting
