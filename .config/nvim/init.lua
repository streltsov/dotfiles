-- require("min.options")
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

---------------------------------------------
------------------ VimWiki ------------------
---------------------------------------------

-- If set to 1, automatically change the current directory to the path of the
-- Vimwiki file that is being edited.
vim.g.vimwiki_auto_chdir = 1

-- If set to 1, use markdown file extension (.md) instead of the default
-- Vimwiki's (.wiki) for Markdown syntax wikis.
vim.g.vimwiki_markdown_link_ext = 1

-- Define the list of Vimwiki wikis. Each item in this list is a table defining
-- the properties of a single wiki.
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

-- vim.fn.matchadd("Comment", "- \\[[Xx]\\] .*$")
-- vim.fn.matchadd("Todo", "- \\[[^Xx]\\] >> .*$")

-------------------------------------------------
------------------ Diagnostics ------------------
-------------------------------------------------

-- This block configures diagnostic settings for Vim.
vim.diagnostic.config({
  -- When set to false, diagnostic messages won't be displayed in the virtual text area next to buffer text.
  virtual_text = false,

  -- If true, diagnostics are updated in insert mode. If false, diagnostics update only when you leave insert mode.
  update_in_insert = true,

  -- If true, sorts diagnostics by severity. This means the most severe issues will be shown first.
  severity_sort = true,

  -- This applies underlining to error-level diagnostics only.
  underline = { severity = vim.diagnostic.severity.ERROR },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "neovim/nvim-lspconfig",
  "jose-elias-alvarez/null-ls.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "ellisonleao/gruvbox.nvim",
  "lewis6991/gitsigns.nvim",
  "folke/trouble.nvim",
  "zbirenbaum/copilot.lua",
  "lukas-reineke/indent-blankline.nvim",
  "airblade/vim-rooter",
  "robitx/gp.nvim",
  "vimwiki/vimwiki",
  "akinsho/toggleterm.nvim",
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  { "nvim-telescope/telescope.nvim", dependencies = { "BurntSushi/ripgrep" } },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" } },
  "folke/zen-mode.nvim",
})

-----------------------------------------------
------------------ Telescope ------------------
-----------------------------------------------

-- Set up telescope with custom settings
require("telescope").setup({
  pickers = {
    buffers = {
      -- Show all buffers, not just current tab's buffers
      show_all_buffers = true,
      -- Sort buffers by last used
      sort_lastused = true,
      mappings = {
        -- In insert mode
        i = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
})

-- Create shortcuts for common telescope commands
local telescope = require("telescope.builtin")
-- Find files in current directory
vim.keymap.set("n", "<Leader>f", telescope.find_files)
-- Live grep in current directory
vim.keymap.set("n", "<Leader>g", telescope.live_grep)
-- Uncomment for git files in current directory
-- vim.keymap.set("n", "<Leader>f", telescope.git_files)

vim.keymap.set("n", "<Leader>u", telescope.grep_string)
vim.keymap.set("n", "<Leader>c", telescope.git_commits)
vim.keymap.set("n", "<Leader>cb", telescope.git_bcommits)
vim.keymap.set("n", "<Leader>s", telescope.git_status)
vim.keymap.set("n", "<Leader>rf", telescope.lsp_references)
vim.keymap.set("n", "<Leader>b", telescope.buffers)
vim.keymap.set("n", "<Leader>o", telescope.oldfiles)
-- vim.keymap.set("n", "<Leader>gb", telescope.git_branches)
-- vim.keymap.set("n", "<Leader>gst", telescope.git_stash)

-- LSP diagnostics
-- vim.keymap.set("n", "<Leader>d", telescope.diagnostics)
-- LSP implementations
-- vim.keymap.set("n", "<Leader>i", telescope.lsp_implementations)
-- Uncomment for LSP type definitions
-- vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)

-- Vim related shortcuts
-- Vim commands
-- vim.keymap.set("n", "<Leader>vc", telescope.commands)
-- Vim buffers

-- Vim options
-- vim.keymap.set("n", "<Leader>vo", telescope.vim_options)
-- Vim keymaps
-- vim.keymap.set("n", "<Leader>?", telescope.keymaps)

-- Recently opened files
-- require("min.gitsigns")
require("gitsigns").setup({
  -- Define the signs used in the sign column
  signs = {
    add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" }, -- Sign for added lines
    change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" }, -- Sign for modified lines
    delete = {
      show_count = true,
      hl = "GitSignsDelete",
      text = "-",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    }, -- Sign for deleted lines
    topdelete = {
      show_count = true,
      hl = "GitSignsDelete",
      text = "^",
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    }, -- Sign for the topmost line of a deletion block
    changedelete = {
      show_count = true,
      hl = "GitSignsChange",
      text = "~",
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    }, -- Sign for changed lines that were also deleted
  },

  -- Disable the blame line by default
  current_line_blame = false,
  -- Options for the blame line
  current_line_blame_opts = {
    virt_text = true, -- Use virtual text for the blame line
    virt_text_pos = "eol", -- Show the blame line at the end of the line
    delay = 0, -- No delay for the blame line
    ignore_whitespace = false, -- Don't ignore whitespace changes
  },
  -- Format for the blame line
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

  -- Define a keymapping for toggling the blame line
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Define the <leader>tb mapping for toggling the blame line
    map("n", "<leader>tb", gs.toggle_current_line_blame)
  end,
})

-- require("min.trouble")
require("trouble").setup({
  auto_open = true, -- If true, automatically open the trouble list when diagnostics are present
  auto_close = true, -- If true, automatically close the trouble list when no diagnostics are present
  auto_preview = true, -- If true, automatically preview the location of the diagnostic. Use <esc> to close the preview and return to the last window
  -- settings without a patched font or icons
  icons = false,
  fold_open = "v", -- icon used for open folds
  fold_closed = ">", -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = "Error",
    warning = "Warning",
    hint = "Hint",
    information = "Info",
  },
  use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})
-- require("min.copilot")
-- Configuration for the 'copilot' plugin
require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    keymap = { accept = "<Tab>" },
  },
  filetypes = { markdown = false, vimwiki = false },
})

-- Reference to the 'suggestion' module of 'copilot'
local suggestion = require("copilot.suggestion")

-- Map <Leader>cp to toggle automatic triggering of suggestions
vim.keymap.set("n", "<Leader>cp", suggestion.toggle_auto_trigger)
-- require("min.completion")
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(), -- Open completion menu
    ["<C-n>"] = cmp.mapping.select_next_item(), -- Select next item
    ["<C-p>"] = cmp.mapping.select_prev_item(), -- Select previous item
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
  },
  sources = {
    { name = "nvim_lsp" }, -- Use LSP as the completion source
  },
})
-- require("min.null-ls")
local b = require("null-ls").builtins
require("null-ls").setup({
  sources = {
    b.formatting.prettierd.with({
      filetypes = {

        "svelte",
        "css",
        "html",
        "json",
        "markdown",
        "vimwiki",
        "md",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
      },
    }),
    b.formatting.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte", "javascriptreact", "typescriptreact" },
    }),
    b.diagnostics.eslint_d.with({
      filetypes = { "javascript", "typescript", "svelte", "javascriptreact", "typescriptreact" },
      command = "eslint_d",
    }),
    b.formatting.stylua.with({
      filetypes = { "lua" },
      -- command = "stylua --search-parent-directories",
    }),
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
            bufnr = bufnr,
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
-- require("min.colorscheme")
-- require("gruvbox").setup({
--   --  overrides = {
--   --    SignColumn = { bg = "#ffffff" },
--   --    -- set number columnt to black
--   --    Number = { bg = "#000000" },
--   --    NumberColumn = { bg = "#fff000" },
--   --  },
--
--   contrast = "light",
-- })

vim.cmd("colorscheme gruvbox")
vim.o.bg = "dark"

-- vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.bg = vim.opt.bg:get() == "light" and "dark" or "light"<CR>')
-- require("min.lsp")
local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()), -- Set up capabilities
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

    vim.keymap.set("n", "rf", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

lspconfig.tailwindcss.setup({
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
})
lspconfig.svelte.setup({
  filetypes = { "svelte" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()), -- Set up capabilities
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
-- require("min.ranger")
-- require("ranger-nvim").setup({ replace_netrw = false })
--
-- vim.api.nvim_set_keymap("n", "<leader>x", "", {
--   noremap = true,
--   callback = function()
--     require("ranger-nvim").open(true)
--   end,
-- })
-- require("min.treesitter")
-- require("nvim-treesitter.configs").setup({
--   auto_install = true,
--   ensure_installed = {
--     "vimdoc",
--     "lua",
--     "vim",
--     "html",
--     "css",
--     "javascript",
--     "typescript",
--     "tsx",
--   },
--   autotag = {
--     enable = true,
--     filetypes = {
--       "html",
--       "javascript",
--       "typescript",
--       "javascriptreact",
--       "typescriptreact",
--       "svelte",
--       "vue",
--       "tsx",
--       "jsx",
--       "rescript",
--       "css",
--       "lua",
--       "xml",
--       "php",
--       "markdown",
--     },
--   },
--   indent = { enable = true },
-- })
-- require("min.gp")
require("gp").setup({
  -- required openai api key
  -- openai_api_key = os.getenv("OPENAI_API_KEY"),

  -- api endpoint (you can change this to azure endpoint)
  -- openai_api_endpoint = "https://api.openai.com/v1/chat/completions",

  -- openai_api_endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
  -- prefix for all commands
  -- cmd_prefix = "Gp",

  -- directory for storing chat files
  -- chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
  -- chat model (string with model name or table with model name and parameters)

  -- chat_model = { model = "gpt-3.5-turbo-16k", temperature = 1.1, top_p = 1 },
  chat_model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
  -- chat model system prompt (use this to specify the persona/role of the AI)
  chat_system_prompt = "You are a general AI assistant.",

  -- chat custom instructions (not visible in the chat but prepended to model prompt)
  chat_custom_instructions = "The user provided the additional info about how they would like you to respond:\n\n"
    .. "- If you're unsure don't guess and say you don't know instead.\n"
    .. "- Ask question if you need clarification to provide better answer.\n"
    .. "- Think deeply and carefully from first principles step by step.\n"
    .. "- Zoom out first to see the big picture and then zoom in to details.\n"
    .. "- Use Socratic method to improve your thinking and coding skills.\n"
    .. "- Don't elide any code from your output if the answer requires coding.\n"
    .. "- Take a deep breath; You've got this!\n",
  -- chat user prompt prefix
  chat_user_prefix = "You:",
  -- chat assistant prompt prefix
  chat_assistant_prefix = "AI: ",
  -- chat topic generation prompt
  chat_topic_gen_prompt = "Summarize the topic of our conversation above"
    .. " in two or three words. Respond only with those words.",
  -- chat topic model (string with model name or table with model name and parameters)
  chat_topic_gen_model = "gpt-4",
  -- explicitly confirm deletion of a chat file
  chat_confirm_delete = true,
  -- conceal model parameters in chat
  chat_conceal_model_params = true,
  -- local shortcuts bound to the chat buffer
  -- (be careful to choose something which will work across specified modes)
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>n" },

  -- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
  -- command prompt prefix for asking user for input
  command_prompt_prefix = "🤖 ~ ",
  -- command model (string with model name or table with model name and parameters)
  command_model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
  -- command system prompt
  command_system_prompt = "You are an AI that strictly generates just the formated final code.",

  -- templates
  template_selection = "I have the following code from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
  template_rewrite = "I have the following code from {{filename}}:"
    .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
    .. "\n\nRespond just with the snippet of code that should be inserted.",
  template_command = "{{command}}",

  -- example hook functions (see Extend functionality section in the README)
  hooks = {
    ApplyComments = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Carry out the modifications outlined in the comment(s)"
      gp.Prompt(params, gp.Target.rewrite, nil, gp.config.command_model, template, gp.config.command_system_prompt)
    end,

    --   InspectPlugin = function(plugin, params)
    --     print(string.format("Plugin structure:\n%s", vim.inspect(plugin)))
    --     print(string.format("Command params:\n%s", vim.inspect(params)))
    --   end,

    --   -- GpImplement rewrites the provided selection/range based on comments in the code
    --   Implement = function(gp, params)
    --     local template = "Having following from {{filename}}:\n\n"
    --       .. "```{{filetype}}\n{{selection}}\n```\n\n"
    --       .. "Please rewrite this code according to the comment instructions."
    --       .. "\n\nRespond only with the snippet of finalized code:"

    --     gp.Prompt(
    --       params,
    --       gp.Target.rewrite,
    --       nil, -- command will run directly without any prompting for user input
    --       gp.config.command_model,
    --       template,
    --       gp.config.command_system_prompt
    --     )
    --   end,
  },
})

local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end

vim.keymap.set({ "n", "i" }, "<C-Space><C-n>", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
vim.keymap.set({ "n", "i" }, "<C-Space><C-f>", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

vim.keymap.set({ "n", "i" }, "<C-Space><C-Space>", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Popup Chat"))
vim.keymap.set("v", "<C-Space><C-Space>", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Popup Chat"))

-- Misc
-- Equalize window sizes when resizing
vim.cmd([[autocmd VimResized * wincmd =]])
