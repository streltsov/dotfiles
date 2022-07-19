vim.cmd "colorscheme default"

vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = "soft"
vim.g.gruvbox_contrast_light = "soft"
vim.g.gruvbox_improved_warnings = 1
vim.g.gruvbox_sign_column = 'bg0'
vim.g.gruvbox_invert_selection = 0

local colorscheme = "gruvbox"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

vim.cmd [[highlight IndentBlanklineIndent1 guifg=NONE guibg=NONE gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=NONE guibg=#282828 gui=nocombine]]

-- vim.o.background = "light"
