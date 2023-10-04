-- General settings
local term_width = 200
local term_height = 45

-- Function to open floating terminal window
local open_float_term = function()
  -- Get current UI dimensions
  local gheight = vim.api.nvim_list_uis()[1].height
  local gwidth = vim.api.nvim_list_uis()[1].width

  -- Floating window configuration
  local win_config = {
    relative = "editor",
    width = term_width,
    height = term_height,
    row = (gheight - term_height) * 0.4,
    col = (gwidth - term_width) * 0.5,
    noautocmd = true,
    style = "minimal",
    border = "single",
  }

  -- Create new buffer and open window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, win_config)
  vim.cmd("term")
  vim.cmd("startinsert")
end

-- Autocommands for terminal
vim.cmd([[
augroup terminal_settings
  autocmd!
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END
]])

-- Map CTRL + Enter to open floating terminal
vim.keymap.set("n", "<C-Space>", open_float_term)
-- vim.api.nvim_set_keymap('n', '<Leader>a', 'open_float_term', {noremap = true})
