---------------
-- Telescope --
---------------
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<Leader>g', telescope.live_grep)
vim.keymap.set('n', '<Leader>f', telescope.find_files)

-- Git pickers
vim.keymap.set('n', '<Leader>gc', telescope.git_commits)
vim.keymap.set('n', '<Leader>gbc', telescope.git_bcommits)
vim.keymap.set('n', '<Leader>gb', telescope.git_branches)
vim.keymap.set('n', '<Leader>gs', telescope.git_status)
vim.keymap.set('n', '<Leader>gst', telescope.git_stash)

--- LSP pickers
vim.keymap.set('n', '<Leader>rf', telescope.lsp_references)
vim.keymap.set('n', '<Leader>d', telescope.diagnostics)
vim.keymap.set('n', '<Leader>i', telescope.lsp_implementations)
vim.keymap.set('n', '<Leader>di', telescope.lsp_implementations)
vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)

-- Vim commands
vim.keymap.set('n', '<Leader>vc', telescope.commands)
vim.keymap.set('n', '<Leader>vb', telescope.buffers)

vim.keymap.set('n', '<Leader>vo', telescope.vim_options)
vim.keymap.set('n', '<Leader>?', telescope.keymaps)

-- vim.keymap.set('n', '<Leader>vof', telescope.oldfiles)

---------
-- LSP --
---------
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
