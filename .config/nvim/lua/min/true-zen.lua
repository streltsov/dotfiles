require("true-zen").setup()

-- local trueZen = require("true-zen")
-- vim.keymap.set("n", "<leader>zn", trueZen.toggle)

-- vim.cmd([[
-- augroup AutoZenMode
-- autocmd!
-- autocmd BufEnter * lua EnterZenModeForBuffer()
-- augroup END
-- ]])
-- 
-- function EnterZenModeForBuffer()
--   -- Check if the buffer is associated with a file and not a special buffer like Telescope.
--   if vim.fn.bufname("%"):match("^/") then
--     require("true-zen.ataraxis").toggle()
--   end
-- end
