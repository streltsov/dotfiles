local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  vim.notify("Null-ls Error")
  return
end

null_ls.setup {
  debug = false,
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.eslint,
  },
}
