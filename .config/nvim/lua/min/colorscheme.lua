require("gruvbox").setup({
  contrast = "soft",
})

vim.cmd("colorscheme gruvbox")

vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.bg = vim.opt.bg:get() == "light" and "dark" or "light"<CR>')
