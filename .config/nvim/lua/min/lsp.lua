-- More Servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    severity_sort = true,
    underline = { severity = vim.diagnostic.severity.ERROR, }
  })

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.html.setup{}
lspconfig.cssls.setup{}

lspconfig.tsserver.setup{
    on_attach = on_attach,
    capabilities = capabilities,
} 

lspconfig.eslint.setup{}

lspconfig.purescriptls.setup {
  on_attach = on_attach,
}
