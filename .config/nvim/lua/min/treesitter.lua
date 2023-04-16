local options = {
  auto_install = true,
  ensure_installed = {
    "help",
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
}

require('nvim-treesitter.configs').setup(options)
