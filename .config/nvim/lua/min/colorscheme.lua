-- setup must be called before loading the colorscheme
-- Default options:
-- require("gruvbox").setup({
--   undercurl = true,
--   underline = true,
--   bold = true,
--   italic = true,
--   strikethrough = true,
--   invert_selection = false,
--   invert_signs = false,
--   invert_tabline = false,
--   invert_intend_guides = false,
--   inverse = true, -- invert background for search, diffs, statuslines and errors
--   contrast = "", -- can be "hard", "soft" or empty string
--   palette_overrides = {},
--   overrides = {},
--   dim_inactive = false,
--   transparent_mode = false,
-- })
-- vim.cmd("colorscheme gruvbox")

vim.cmd("colorscheme default")

vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_contrast_light = "soft"
vim.g.gruvbox_improved_warnings = 1
vim.g.gruvbox_sign_column = "bg0"
vim.g.gruvbox_invert_selection = 0

vim.o.background = 'dark'

local colorscheme = "gruvbox"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("COLORSCHEME " .. colorscheme .. " NOT FOUND!")
  return
end

vim.cmd([[highlight IndentBlanklineIndent1 guifg=NONE guibg=NONE gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=NONE guibg=#282828 gui=nocombine]])
