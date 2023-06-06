require('copilot').setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<Tab>",
    },
  },
  filetypes = {
    javascript = true,
    typescript = true,
    ["*"] = false,
  },
})

local suggestion = require("copilot.suggestion")

vim.keymap.set("n", "<Leader>cp", suggestion.toggle_auto_trigger)

