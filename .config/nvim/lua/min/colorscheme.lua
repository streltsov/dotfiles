-- require("gruvbox").setup({
--   --  overrides = {
--   --    SignColumn = { bg = "#ffffff" },
--   --    -- set number columnt to black
--   --    Number = { bg = "#000000" },
--   --    NumberColumn = { bg = "#fff000" },
--   --  },
--
--   contrast = "light",
-- })

vim.cmd("colorscheme gruvbox")
vim.o.bg = "dark"

-- vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.bg = vim.opt.bg:get() == "light" and "dark" or "light"<CR>')
