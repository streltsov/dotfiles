-- Set up telescope with custom settings
require("telescope").setup({
  pickers = {
    buffers = {
      -- Show all buffers, not just current tab's buffers
      show_all_buffers = true,
      -- Sort buffers by last used
      sort_lastused = true,
      mappings = {
        -- In insert mode
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
})

-- Create shortcuts for common telescope commands
local telescope = require("telescope.builtin")
-- Find files in current directory
vim.keymap.set("n", "<Leader>f", telescope.find_files)
-- Live grep in current directory
vim.keymap.set("n", "<Leader>g", telescope.live_grep)
-- Uncomment for git files in current directory
-- vim.keymap.set("n", "<Leader>f", telescope.git_files)

vim.keymap.set("n", "<Leader>u", telescope.grep_string)
vim.keymap.set("n", "<Leader>c", telescope.git_commits)
vim.keymap.set("n", "<Leader>cb", telescope.git_bcommits)
vim.keymap.set("n", "<Leader>s", telescope.git_status)
vim.keymap.set("n", "<Leader>rf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>b", telescope.buffers)
vim.keymap.set("n", "<Leader>o", telescope.oldfiles)
-- vim.keymap.set("n", "<Leader>gb", telescope.git_branches)
-- vim.keymap.set("n", "<Leader>gst", telescope.git_stash)

-- LSP diagnostics
-- vim.keymap.set("n", "<Leader>d", telescope.diagnostics)
-- LSP implementations
-- vim.keymap.set("n", "<Leader>i", telescope.lsp_implementations)
-- Uncomment for LSP type definitions
-- vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)

-- Vim related shortcuts
-- Vim commands
-- vim.keymap.set("n", "<Leader>vc", telescope.commands)
-- Vim buffers

-- Vim options
-- vim.keymap.set("n", "<Leader>vo", telescope.vim_options)
-- Vim keymaps
-- vim.keymap.set("n", "<Leader>?", telescope.keymaps)

-- Recently opened files
