-- local null_ls = require("null-ls")
-- 
-- -- Define the sources you want to use
-- local sources = {
--     null_ls.builtins.formatting.prettierd.with({
--         filetypes = { "javascript", "typescript", "svelte", "css", "html", "json" },
--     }),
--     null_ls.builtins.formatting.eslint_d.with({
--         filetypes = { "javascript", "typescript", "svelte" },
--     }),
--     null_ls.builtins.diagnostics.eslint_d.with({
--         filetypes = { "javascript", "typescript", "svelte" },
--         command = "eslint_d",
--     }),
-- }
-- 
-- -- Setup null-ls
-- null_ls.setup({
--     sources = sources,
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             local augroup = "FormatOnSave"
--             vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = augroup,
--                 buffer = bufnr,
--                 callback = function()
--                     vim.lsp.buf.format({
--                         async = false,
--                         bufnr = bufnr,
--                         filter = function(client)
--                             return client.name == "null-ls"
--                         end,
--                     })
--                 end,
--             })
--         end
--     end,
-- })

local b = require("null-ls").builtins
  require("null-ls").setup({
  -- sources = {
  --   b.formatting.prettierd,
  --   b.formatting.eslint_d,
  --   b.diagnostics.eslint.with({ command = "eslint_d" }),
  -- },
  sources = {
    b.formatting.prettierd.with({
      filetypes = { "javascript", "typescript", "svelte", "css", "html", "json" },
    }),
    b.formatting.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte" },
    }),
    b.diagnostics.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte" },
      command = "eslint_d",
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

