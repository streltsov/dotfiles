vim.cmd([[
augroup neovim_terminal
    autocmd!
    " Enter Terminal-mode (insert) automatically
    autocmd TermOpen * startinsert
    " Disables number lines on terminal buffers
    autocmd TermOpen * :set nonumber norelativenumber
    " allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
augroup END
]])

vim.opt.termguicolors = true
vim.cmd [[au BufEnter * set fo-=c fo-=r fo-=o]] -- don't auto comment new lines
vim.opt.showmode = false                        -- Do not show mode
vim.opt.smartcase = true                        -- Ignores case when the pattern contains lowercase letters only
vim.opt.cursorline = true                       -- Highlight current line
vim.opt.number = true                           -- Set hybrid line number mode
vim.opt.relativenumber = true
vim.opt.shiftwidth=2                            -- To change the number of space characters inserted for indentation
vim.opt.expandtab=true
vim.opt.smartindent = true                      -- Automatically inserts one extra level of indentation in some cases
vim.opt.linebreak = true                        -- Stop Vim wrapping lines in the middle of a word
vim.opt.incsearch = true                        -- Jumps to search word as you type (annoying but excellent)
vim.opt.hidden = true                           -- Opening a new file when the current buffer has unsaved changes causes files to be hidden instead of closed
vim.opt.splitright = true                       -- Make the new window appear on the right.
vim.opt.splitbelow = true                       -- Make the new window appear below the current window.
vim.opt.backup = false                          -- creates a backup file
vim.opt.completeopt = { "menu", "longest" }     -- mostly just for cmp
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 100                        -- faster completion (4000ms default)
vim.opt.laststatus = 3
-- Experimental
vim.opt.showmatch = true
