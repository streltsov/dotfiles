-- Configuration for the 'copilot' plugin
require('copilot').setup({
  suggestion = {
    auto_trigger = true, -- Enables automatic triggering of suggestions as you type
    keymap = {
      accept = "<Tab>", -- Uses the Tab key to accept a suggestion
    },
  },
  filetypes = {
    javascript = true, -- Enable suggestions for JavaScript files
    typescript = true, -- Enable suggestions for TypeScript files
    ["*"] = false, -- Disable suggestions for all other file types
  },
})

-- Reference to the 'suggestion' module of 'copilot'
local suggestion = require("copilot.suggestion")

-- Map <Leader>cp to toggle automatic triggering of suggestions
vim.keymap.set("n", "<Leader>cp", suggestion.toggle_auto_trigger)

