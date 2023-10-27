require("trouble").setup({
  auto_open = true, -- If true, automatically open the trouble list when diagnostics are present
  auto_close = true, -- If true, automatically close the trouble list when no diagnostics are present
  auto_preview = true, -- If true, automatically preview the location of the diagnostic. Use <esc> to close the preview and return to the last window
  -- settings without a patched font or icons
  icons = false,
  fold_open = "v", -- icon used for open folds
  fold_closed = ">", -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = "Error",
    warning = "Warning",
    hint = "Hint",
    information = "Info",
  },
  use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})
