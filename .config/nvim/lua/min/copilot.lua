-- Configuration for the 'copilot' plugin
require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    keymap = { accept = "<Tab>" },
  },
  filetypes = { markdown = false, vimwiki = false },
})

-- Reference to the 'suggestion' module of 'copilot'
local suggestion = require("copilot.suggestion")

-- Map <Leader>cp to toggle automatic triggering of suggestions
vim.keymap.set("n", "<Leader>cp", suggestion.toggle_auto_trigger)
