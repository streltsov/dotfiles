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

---------------
-- Telescope --
---------------
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<Leader>f", telescope.find_files)
vim.keymap.set("n", "<Leader>g", telescope.live_grep)

-- vim.keymap.set("n", "<Leader>f", telescope.git_files)
vim.keymap.set("n", "<Leader>u", telescope.grep_string)

-- Git pickers
vim.keymap.set("n", "<Leader>c", telescope.git_commits)
vim.keymap.set("n", "<Leader>bc", telescope.git_bcommits)
vim.keymap.set("n", "<Leader>b", telescope.git_branches)
vim.keymap.set("n", "<Leader>s", telescope.git_status)
vim.keymap.set("n", "<Leader>st", telescope.git_stash)

--- LSP pickers
vim.keymap.set("n", "<Leader>rf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>d", telescope.diagnostics)
vim.keymap.set("n", "<Leader>i", telescope.lsp_implementations)
-- vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)

-- Vim commands
vim.keymap.set("n", "<Leader>vc", telescope.commands)
vim.keymap.set("n", "<Leader>vb", telescope.buffers)

vim.keymap.set("n", "<Leader>vo", telescope.vim_options)
vim.keymap.set("n", "<Leader>?", telescope.keymaps)

-- vim.keymap.set('n', '<Leader>vof', telescope.oldfiles)
