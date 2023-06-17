require("ranger-nvim").setup({ replace_netrw = false })

vim.api.nvim_set_keymap("n", "<leader>e", "", {
  noremap = true,
  callback = function()
    require("ranger-nvim").open(true)
  end,
})
