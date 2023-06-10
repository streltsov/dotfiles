require("gruvbox").setup({
  contrast = "soft",
})

vim.cmd("colorscheme gruvbox")

vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.background = vim.opt.background:get() == "light" and "dark" or "light"<CR>')
