-- Weather to change working directory or not
vim.g.vimwiki_auto_chdir = 1
vim.g.vimwiki_list = {
    {
     path = '~/.the-knowledge-garden',
     index = 'chaos-sanctuary',
     syntax = 'markdown',
     ext = '.md',
     diary_rel_path = 'daily-notes/',
     diary_index = 'index',
     }
}
--    \ 'template_path': '~/path/to/your/vimwiki/templates/',
--    \ 'template_default': 'default',


-- Edit random .md file in the current directory
vim.api.nvim_set_keymap('n', '<leader>wq', 
    [[<Cmd>execute 'edit ' . system('ls | shuf -n 1')<CR>]], 
    { noremap = true, silent = true })

-- Edit the .md file with the oldest modification time in the current directory
vim.api.nvim_set_keymap('n', '<leader>we', 
    [[<Cmd>execute 'edit ' . system('ls -tr *.md | head -n 1')<CR>]], 
    { noremap = true, silent = true })
