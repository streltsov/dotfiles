-- This block configures diagnostic settings for Vim.
vim.diagnostic.config({
  -- When set to false, diagnostic messages won't be displayed in the virtual text area next to buffer text.
  virtual_text = false,
  
  -- If true, diagnostics are updated in insert mode. If false, diagnostics update only when you leave insert mode.
  update_in_insert = true,
  
  -- If true, sorts diagnostics by severity. This means the most severe issues will be shown first.
  severity_sort = true,
  
  -- This applies underlining to error-level diagnostics only.
  underline = { severity = vim.diagnostic.severity.ERROR },
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

