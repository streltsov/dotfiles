-- Set up telescope with custom settings
require("telescope").setup {
  -- Custom settings for the buffers picker
  pickers = {
    buffers = {
      -- Show all buffers, not just current tab's buffers
      show_all_buffers = true,
      -- Sort buffers by last used
      sort_lastused = true,
      -- Custom mappings for the buffer picker
      mappings = {
        -- In insert mode
        i = {
          -- <Ctrl+d> to delete a buffer
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  }
}

-- Create shortcuts for common telescope commands
local telescope = require("telescope.builtin")
-- Find files in current directory
vim.keymap.set("n", "<Leader>f", telescope.find_files)
-- Live grep in current directory
vim.keymap.set("n", "<Leader>g", telescope.live_grep)
-- Uncomment for git files in current directory
-- vim.keymap.set("n", "<Leader>f", telescope.git_files)

-- Grep string under the cursor
vim.keymap.set("n", "<Leader>u", telescope.grep_string)

-- Git related shortcuts
-- Git commits
vim.keymap.set("n", "<Leader>gc", telescope.git_commits)
-- Git buffer commits
vim.keymap.set("n", "<Leader>gbc", telescope.git_bcommits)
-- Git branches
vim.keymap.set("n", "<Leader>gb", telescope.git_branches)
-- Git status
vim.keymap.set("n", "<Leader>gs", telescope.git_status)
-- Git stash
vim.keymap.set("n", "<Leader>gst", telescope.git_stash)

-- LSP related shortcuts
-- LSP references
vim.keymap.set("n", "<Leader>rf", telescope.lsp_references)
-- LSP diagnostics
-- vim.keymap.set("n", "<Leader>d", telescope.diagnostics)
-- LSP implementations
-- vim.keymap.set("n", "<Leader>i", telescope.lsp_implementations)
-- Uncomment for LSP type definitions
-- vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)

-- Vim related shortcuts
-- Vim commands
vim.keymap.set("n", "<Leader>vc", telescope.commands)
-- Vim buffers
vim.keymap.set("n", "<Leader><Leader>f", telescope.buffers)

-- Vim options
vim.keymap.set("n", "<Leader>vo", telescope.vim_options)
-- Vim keymaps
vim.keymap.set("n", "<Leader>?", telescope.keymaps)

-- Recently opened files
vim.keymap.set('n', '<Leader>vof', telescope.oldfiles)
