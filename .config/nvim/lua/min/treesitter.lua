require('nvim-treesitter.configs').setup( {
  auto_install = true,
  ensure_installed = {
    "vimdoc",
    "lua",
    "vim",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
  },
  autotag = {
    enable = true,
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
      'css', 'lua', 'xml', 'php', 'markdown'
    },
  },
  indent = { enable = true },
})
