-- If set to 1, automatically change the current directory to the path of the Vimwiki file that is being edited.
vim.g.vimwiki_auto_chdir = 1

-- If set to 1, use markdown file extension (.md) instead of the default Vimwiki's (.wiki) for Markdown syntax wikis.
vim.g.vimwiki_markdown_link_ext = 1

-- Define the list of Vimwiki wikis. Each item in this list is a table defining the properties of a single wiki.
vim.g.vimwiki_list = {
  {
    path = "~/.the-knowledge-garden", -- The path where the wiki files will be stored.
    index = "todo-list", -- The name of the index file.
    syntax = "markdown", -- The syntax to be used for the wiki.
    ext = ".md", -- The file extension for the wiki files.
  },
}

-- Map <leader>wq to open a random file in the current directory.
vim.api.nvim_set_keymap(
  "n",
  "<leader>wq",
  [[<Cmd>execute 'edit ' . system('ls | shuf -n 1')<CR>]],
  { noremap = true, silent = true }
)

-- Map <leader>we to open the oldest markdown file in the current directory.
vim.api.nvim_set_keymap(
  "n",
  "<leader>we",
  [[<Cmd>execute 'edit ' . system('ls -tr *.md | head -n 1')<CR>]],
  { noremap = true, silent = true }
)

vim.fn.matchadd("Comment", "- \\[[Xx]\\] .*$")
vim.fn.matchadd("Todo", "- \\[[^Xx]\\] >> .*$")
