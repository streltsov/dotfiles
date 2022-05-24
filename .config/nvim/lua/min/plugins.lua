-- Telescope extras:
-- -- pacman -S ripgrep
-- -- pacman -S fd

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

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
  use "wbthomason/packer.nvim"                                                      -- Have packer manage itself
  use "nvim-lua/popup.nvim"                                                         -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"                                                       -- Useful lua functions used ny lots of plugins
  use "kyazdani42/nvim-web-devicons"                                                -- Web Icons

  use "mfussenegger/nvim-lint"

  use "neovim/nvim-lspconfig"                                                       -- enable LSP
  use "williamboman/nvim-lsp-installer"                                             -- Simple to use language server installer
  require 'lspconfig'.tsserver.setup {}
  -- use "nvim-telescope/telescope.nvim"                                               -- Telescope
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }                      -- Treesitter
  use "hrsh7th/nvim-cmp"                                                            -- Autocompletion plugin
  use "hrsh7th/cmp-nvim-lsp"                                                        -- LSP source for nvim-cmp
  use "ellisonleao/gruvbox.nvim"                                                    -- Gruvbox lua ported colorscheme
  use "ishan9299/nvim-solarized-lua"                                                -- Solarized lua ported colorscheme

  use "preservim/vim-markdown"

  use "mattn/emmet-vim"                                                             -- Emmet
  use "lukas-reineke/indent-blankline.nvim"                                         -- Indent blankline
  use "lewis6991/gitsigns.nvim"                                                     -- Git signs
  -- use "nvim-lualine/lualine.nvim"                                                   -- Lualine
  use "jose-elias-alvarez/null-ls.nvim"                                             -- Formatting
  use "petertriho/nvim-scrollbar"
  require("scrollbar").setup()

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

end)
