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

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  use "wbthomason/packer.nvim"                                   -- Have packer manage itself
  use "nvim-lua/plenary.nvim"                                    -- Useful lua functions used ny lots of plugins
  use "neovim/nvim-lspconfig"                                    -- enable LSP
  use "ellisonleao/gruvbox.nvim"                                 -- Gruvbox lua ported colorscheme

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
