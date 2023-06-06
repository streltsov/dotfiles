local gheight = vim.api.nvim_list_uis()[1].height
local gwidth = vim.api.nvim_list_uis()[1].width
local width = 200
local height = 45

vim.cmd([[
  au BufEnter * set fo-=c fo-=r fo-=o
]]) -- don't auto comment new lines

local open_win_config = {
  relative = "editor",
  width = width,
  height = height,
  row = (gheight - height) * 0.4,
  col = (gwidth - width) * 0.5,
  noautocmd = true,
  style = "minimal",
  border = "single",
}

local open_float_term = function()
  vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, open_win_config)
  vim.api.nvim_command("term")
  vim.api.nvim_command("startinsert")
end

vim.keymap.set("n", "<c-return>", open_float_term)

vim.cmd([[
augroup terminal_settings
  autocmd!

  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert

  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END
]])

-- vim.cmd([[
-- augroup neovim_terminal
--     autocmd!
--     " Enter Terminal-mode (insert) automatically
--     autocmd TermOpen * startinsert
--     " Disables number lines on terminal buffers
--     autocmd TermOpen * :set nonumber norelativenumber
--     " allows you to use Ctrl-c on terminal window
--     autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
-- augroup END
-- ]])

