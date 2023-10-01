local b = require("null-ls").builtins
require("null-ls").setup({
  sources = {
    b.formatting.prettierd.with({
      filetypes = { "javascript", "typescript", "svelte", "css", "html", "json", "markdown", "vimwiki" },
    }),
    b.formatting.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte" },
    }),
    b.diagnostics.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte" },
      command = "eslint_d",
    }),
    b.formatting.stylua.with({
      filetypes = { "lua" },
    }),
  },

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
