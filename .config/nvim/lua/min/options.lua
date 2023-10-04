-- Enable true color support, allowing for more than 256 colors
vim.opt.termguicolors = true

-- Disable mode indication in command line. By default, Vim shows
-- "-- INSERT --", "-- VISUAL --", etc.
vim.opt.showmode = false

-- Set search to be case-sensitive only if the search pattern
-- contains uppercase characters
vim.opt.smartcase = true

-- Highlight the line where the cursor is currently positioned
vim.opt.cursorline = true

-- Display line numbers in the gutter
vim.opt.number = true

-- Display line numbers relative to the current line's position in
-- the gutter
vim.opt.relativenumber = true

-- Set the number of spaces used for each indentation level
vim.opt.shiftwidth = 2

-- Convert tabs into spaces
vim.opt.expandtab = true

-- Automatically indent new lines to match the previous line's
-- indentation
vim.opt.smartindent = true

-- Enable line breaking at a convenient point (between words), not
-- exactly at the edge of the window
vim.opt.linebreak = true

-- Highlight matches as they are found when searching
vim.opt.incsearch = true

-- Allow for hidden buffers, meaning you can switch away from a
-- buffer without saving it
vim.opt.hidden = true

-- When splitting, put the new window to the right of the current
-- one
vim.opt.splitright = true

-- When splitting, put the new window below the current one
vim.opt.splitbelow = true

-- Disable the creation of backup files
vim.opt.backup = false

-- Set options for completion, including showing a menu of choices
-- and not selecting a match automatically
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Set search to be case insensitive
vim.opt.ignorecase = true

-- Disable the creation of swap files
vim.opt.swapfile = false

-- Enable the creation of undo files, allowing changes to be
-- undone after exiting and restarting Vim
vim.opt.undofile = true

-- Set the time Vim waits before writing to the swap file to 100
-- milliseconds
vim.opt.updatetime = 100

-- Set the status line to display only for the current Neovim
-- instance. Only one status line is shown at the bottom
-- indicating the status of the current window.
vim.opt.laststatus = 3

-- Set the maximum width for text that is being inserted. A longer
-- line will be broken after white space to get this width.
vim.opt.textwidth = 0

-- Disable the use of the mouse
vim.opt.mouse = ""

-- Show matching brackets when text indicator is over them
vim.opt.showmatch = true

-- Set the leader key to the space bar
vim.g.mapleader = " "

-- Disable automatic formatting options when entering a buffer
vim.cmd("au BufEnter * set fo-=c fo-=r fo-=o")

-- Disable line numbers for Markdown files
vim.cmd([[
  autocmd FileType markdown setlocal nonumber norelativenumber
]])
