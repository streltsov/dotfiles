  require("telescope").setup {
  pickers = {
    buffers = {
      show_all_buffers = true,
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        }
      }
    }
  }
}

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

vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.background = vim.opt.background:get() == "light" and "dark" or "light"<CR>')

