local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(), -- Open completion menu
    ["<C-n>"] = cmp.mapping.select_next_item(), -- Select next item
    ["<C-p>"] = cmp.mapping.select_prev_item(), -- Select previous item
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
  },
  sources = {
    { name = "nvim_lsp" }, -- Use LSP as the completion source
  },
})
