vim.fn.matchadd("Error", "- \\[[^xX]\\] >>> .*$")
vim.fn.matchadd("Todo", "- \\[[^xX]\\] >> .*$")
vim.fn.matchadd("Comment", "- \\[[xX]\\].*$")

vim.fn.matchadd("Conceal", ">>> ")
vim.fn.matchadd("Conceal", ">> ")

-- local checkboxUncheckedID = vim.fn.matchadd('Conceal', '- \\[[^xX]\\]', 10, -1, {conceal = ''})
-- local checkboxCheckedID = vim.fn.matchadd('Conceal', '- \\[[xX]\\]', 10, -1, {conceal = ''})


