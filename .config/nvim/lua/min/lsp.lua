vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local lsp = vim.api.nvim_create_augroup("LSP", { clear = true })
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- TypeScript
 vim.api.nvim_create_autocmd("FileType", {
   group = lsp,
   pattern = {
     "javascript",
     "javascriptreact",
     "javascript.jsx",
     "typescript",
     "typescriptreact",
     "typescript.tsx",
   },
   callback = function()
     local path = vim.fs.find({
       ".git",
       "package-lock.json",
       "yarn.lock",
     }, { upward = true })
     vim.lsp.start({
       name = "typescript-language-server",
       cmd = { "typescript-language-server", "--stdio" },
       root_dir = vim.fs.dirname(path[1]),
       capabilities = capabilities,
     })
   end,
 })

-- require'lspconfig'.tsserver.setup{}
require'lspconfig'.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- Lua
-- vim.api.nvim_create_autocmd("FileType", {
--   group = lsp,
--   pattern = "lua",
--   callback = function()
--     local path = vim.fs.find({
--       "init.lua",
--       ".luarc.json",
--       ".luacheckrc",
--       "stylua.toml",
--       ".git",
--     })
--     vim.lsp.start({
--       name = "lua-language-server",
--       cmd = { "lua-language-server" },
--       root_dir = vim.fs.dirname(path[1]),
--       capabilities = capabilities,
--       settings = {
--         Lua = {
--           completion = {
--             enable = true,
--             showWord = "Disable",
--             callSnippet = "Disable",
--             keywordSnippet = "Disable",
--           },
--           telemetry = { enable = false },
--           diagnostics = {
--             globals = { "vim", "packer_bootstrap" },
--           },
--         },
--       },
--     })
--   end,
-- })

local b = require("null-ls").builtins
require("null-ls").setup({
  sources = {
    b.formatting.prettier,
    -- b.formatting.eslint, -- _d,
    -- b.diagnostics.eslint -- .with({ command = "eslint_d" }),
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
            filter = function(client)
              -- apply whatever logic you want (in this example, we'll only use null-ls)
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp,
  callback = function(args)
    -- local bufopts = { noremap=true, silent=true, buffer=bufnr }
    local bufopts = { buffer = args.buf }

    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)

    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
    -- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  end,
})

-- Never request typescript-language-server for formatting
-- vim.lsp.buf.format {
--   filter = function(client) return client.name ~= "tsserver" end
-- }

-- The most used functions are:
-- vim.lsp.buf.hover()
-- vim.lsp.buf.format()
-- vim.lsp.buf.references()
-- vim.lsp.buf.implementation()
-- vim.lsp.buf.code_action()

-- Not all language servers provide the same capabilities. To ensure you only set
-- keymaps if the language server supports a feature, you can guard the keymap
-- calls behind capability checks:
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client.server_capabilities.hoverProvider then
--       vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--   group = lsp,
--   pattern = "tree-sitter-grammar",
--   callback = function()
--     local path = vim.fs.find({ "grammar.js" })
--     if (path[1]) then
--       vim.lsp.start({
--         name = "Grammar.js LSP",
--         cmd = add_tracing("grammarJs", { local_overrides.grammar_js_lsp }),
--         root_dir = vim.fs.dirname(path[1])
--       })
--     end
--   end,
-- })

-- lspconfig.html.setup{}
-- lspconfig.cssls.setup{}

-- lspconfig.tsserver.setup{
--   on_attach = on_attach,
--   -- capabilities = capabilities,
-- }

-- local on_attach = function(client, bufnr)
--   client.resolved_capabilities.document_formatting = false
--
--   vim.diagnostic.config({
--     virtual_text = false,
--     update_in_insert = true,
--     severity_sort = true,
--     underline = { severity = vim.diagnostic.severity.ERROR, }
--   })
--
-- end
