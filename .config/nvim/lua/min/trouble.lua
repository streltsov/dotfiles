require("trouble").setup {
  icons = false, -- Disables usage of devicons for filenames
  auto_open = true, -- If true, automatically open the trouble list when diagnostics are present
  auto_close = true, -- If true, automatically close the trouble list when no diagnostics are present
  auto_preview = true, -- If true, automatically preview the location of the diagnostic. Use <esc> to close the preview and return to the last window
}
