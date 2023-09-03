require("gruvbox").setup({
  contrast = "light",
  -- overrides = {
  --       SignColumn = {bg = 'bg'}
  --   }
})

vim.cmd("colorscheme gruvbox")
-- vim.o.background = "light"

-- vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.bg = vim.opt.bg:get() == "light" and "dark" or "light"<CR>')
