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
vim.cmd("autocmd BufEnter * set fo-=c fo-=r fo-=o")

-- Equalize window sizes when resizing
vim.api.nvim_create_autocmd("VimResized", {
  pattern = { "*" },
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Disable line numbers for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

function get_height_16_9(width)
  return math.floor(width / 16) * 9
end

-- This block configures diagnostic settings for Vim.
vim.diagnostic.config({
  -- When set to false, diagnostic messages won't be displayed in the virtual
  -- text area next to buffer text.
  virtual_text = false,

  -- If true, diagnostics are updated in insert mode. If false, diagnostics
  -- update only when you leave insert mode.
  update_in_insert = true,

  -- If true, sorts diagnostics by severity. This means the most severe issues
  -- will be shown first.
  severity_sort = true,

  -- This applies underlining to error-level diagnostics only.
  underline = { severity = vim.diagnostic.severity.ERROR },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

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
  {
    -- PluginNameAnchor
    "nvim-lua/plenary.nvim",
  },
  {
    -- PluginNameAnchor
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      capabilities = vim.lsp.protocol.make_client_capabilities()
      -- require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),

      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            command = "EslintFixAll",
            buffer = bufnr,
          })
        end,
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      lspconfig.tailwindcss.setup({})

      lspconfig.svelte.setup({
        capabilities = capabilities,
        filetypes = {
          "svelte",
        },
      })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf })
          -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf })
          vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf })
          vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { buffer = ev.buf })
          vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf })
        end,
      })
    end,
  },
  {
    -- PluginNameAnchor
    "dnlhc/glance.nvim",
    config = function()
      require("glance").setup({
        theme = { -- This feature might not work properly in nvim-0.7.2
          enable = true, -- Will generate colors for the plugin based on your current colorscheme
          mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        },
      })

      vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>")
    end,
  },
  {
    -- PluginNameAnchor
    "nvimtools/none-ls.nvim",
    config = function()
      local b = require("null-ls").builtins

      require("null-ls").setup({
        sources = {
          b.formatting.stylua,
          b.formatting.prettier.with({
            extra_filetypes = {
              "svelte",
              "vimwiki",
            },
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
    end,
  },
  {
    -- PluginNameAnchor
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
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
          "markdown",
        },
        autotag = {
          enable = true,
          filetypes = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "tsx",
            "jsx",
            "rescript",
            "css",
            "lua",
            "xml",
            "php",
            "markdown",
          },
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
  {
    -- PluginNameAnchor
    "vimwiki/vimwiki",
    init = function()
      -- If set to 1, automatically change the current directory to the path of
      -- the Vimwiki file that is being edited.
      vim.g.vimwiki_auto_chdir = 1

      -- If set to 1, use markdown file extension (.md) instead of the default
      -- Vimwiki's (.wiki) for Markdown syntax wikis.
      vim.g.vimwiki_markdown_link_ext = 1

      -- Define the list of Vimwiki wikis. Each item in this list is a table
      -- defining the properties of a single wiki.
      vim.g.vimwiki_list = {
        {
          -- The path where the wiki files will be stored.
          path = "~/.the-knowledge-garden",
          -- The name of the index file.
          index = "todo-list",
          -- The syntax to be used for the wiki.
          syntax = "markdown",
          -- The file extension for the wiki files.
          ext = ".md",
        },
      }

      -- Map <leader>wq to open a random file in the current directory.
      vim.keymap.set(
        "n",
        "<leader>wq",
        [[<Cmd>execute 'edit ' . system('ls | shuf -n 1')<CR>]],
        { noremap = true, silent = true }
      )

      -- Map <leader>we to open the oldest markdown file in the current directory.
      vim.keymap.set(
        "n",
        "<leader>we",
        [[<Cmd>execute 'edit ' . system('ls -tr *.md | head -n 1')<CR>]],
        { noremap = true, silent = true }
      )
    end,
  },
  {
    -- PluginNameAnchor
    "ellisonleao/gruvbox.nvim",
    init = function()
      vim.cmd("colorscheme gruvbox")
      vim.o.bg = "dark"
    end,
  },
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        background = {
          light = "latte",
          dark = "frappe",
        },
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })
    end,
  },
  { "rose-pine/neovim" },
  {
    -- PluginNameAnchor
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- Define the signs used in the sign column
        signs = {
          add = { -- Sign for added lines
            hl = "GitSignsAdd",
            text = "+",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
          },
          change = { -- Sign for modified lines
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = { -- Sign for deleted lines
            show_count = true,
            hl = "GitSignsDelete",
            text = "-",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          topdelete = { -- Sign for the topmost line of a deletion block
            show_count = true,
            hl = "GitSignsDelete",
            text = "^",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = { -- Sign for changed lines that were also deleted
            show_count = true,
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },

        -- Disable the blame line by default
        current_line_blame = false,

        -- Options for the blame line
        current_line_blame_opts = {
          -- Use virtual text for the blame line
          virt_text = true,
          -- Show the blame line at the end of the line
          virt_text_pos = "eol",
          -- No delay for the blame line
          delay = 0,
          -- Don't ignore whitespace changes
          ignore_whitespace = false,
        },

        -- Format for the blame line
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

        -- Define a keymapping for toggling the blame line
        on_attach = function()
          vim.keymap.set("n", "<Leader>tb", package.loaded.gitsigns.toggle_current_line_blame)
        end,
      })
    end,
  },
  {
    -- PluginNameAnchor
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        -- Automatically open the trouble list when diagnostics are present
        auto_open = true,
        -- Automatically close the trouble list when no diagnostics are present
        auto_close = true,
        -- Automatically preview the location of the diagnostic. Use <esc> to
        -- close the preview and return to the last window
        auto_preview = true,
        -- Settings without a patched font or icons
        icons = false,
        -- Icon used for open folds
        fold_open = "v",
        -- Icon used for closed folds
        fold_closed = ">",
        -- Add an indent guide below the fold icons
        indent_lines = false,
        signs = {
          -- Icons/text used for a diagnostic
          error = "Error",
          warning = "Warning",
          hint = "Hint",
          information = "Info",
        },
        -- Enabling this will use the signs defined in your lsp client
        use_diagnostic_signs = true,
      })
    end,
  },
  {
    -- PluginNameAnchor
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
          },
        },
        filetypes = {
          markdown = false,
          vimwiki = false,
        },
      })
    end,
  },
  {
    -- PluginNameAnchor
    "lukas-reineke/indent-blankline.nvim",
  },
  {
    -- PluginNameAnchor
    "airblade/vim-rooter",
  },
  -- {
  --   -- PluginNameAnchor
  --   "robitx/gp.nvim",
  --   config = function()
  --     require("gp").setup({
  --       chat_model = {
  --         model = "gpt-3.5-turbo-16k",
  --         temperature = 1.1,
  --         top_p = 1,
  --       },
  --       chat_system_prompt = "You are a general AI assistant.",
  --       chat_custom_instructions = "The user provided the additional info about how they would like you to respond:\n\n"
  --         .. "- If you're unsure don't guess and say you don't know instead.\n"
  --         .. "- Ask question if you need clarification to provide better answer.\n"
  --         .. "- Think deeply and carefully from first principles step by step.\n"
  --         .. "- Zoom out first to see the big picture and then zoom in to details.\n"
  --         .. "- Use Socratic method to improve your thinking and coding skills.\n"
  --         .. "- Don't elide any code from your output if the answer requires coding.\n"
  --         .. "- Take a deep breath; You've got this!\n",
  --       -- chat user prompt prefix
  --       chat_user_prefix = "You:",
  --       -- chat assistant prompt prefix
  --       chat_assistant_prefix = "AI: ",
  --       -- chat topic generation prompt
  --       chat_topic_gen_prompt = "Summarize the topic of our conversation above"
  --         .. " in two or three words. Respond only with those words.",
  --       -- chat topic model (string with model name or table with model name and parameters)
  --       chat_topic_gen_model = "gpt-3.5-turbo-16k",
  --       -- explicitly confirm deletion of a chat file
  --       chat_confirm_delete = true,
  --       -- conceal model parameters in chat
  --       chat_conceal_model_params = true,
  --       -- local shortcuts bound to the chat buffer
  --       -- (be careful to choose something which will work across specified modes)
  --       chat_shortcut_respond = {
  --         modes = { "n", "i", "v", "x" },
  --         shortcut = "<C-g><C-g>",
  --       },
  --       chat_shortcut_delete = {
  --         modes = { "n", "i", "v", "x" },
  --         shortcut = "<C-g>d",
  --       },
  --       chat_shortcut_new = {
  --         modes = { "n", "i", "v", "x" },
  --         shortcut = "<C-g>n",
  --       },

  --       command_prompt_prefix = "🤖 ~ ",
  --       command_system_prompt = "You are an AI that strictly generates just the formated final code.",

  --       -- templates
  --       template_selection = "I have the following code from {{filename}}:"
  --         .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
  --       template_rewrite = "I have the following code from {{filename}}:"
  --         .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
  --         .. "\n\nRespond just with the snippet of code that should be inserted.",
  --       template_command = "{{command}}",

  --       -- example hook functions (see Extend functionality section in the README)
  --       hooks = {
  --         ApplyComments = function(gp, params)
  --           local template = "I have the following code from {{filename}}:\n\n"
  --             .. "```{{filetype}}\n{{selection}}\n```\n\n"
  --             .. "Carry out the modifications outlined in the comment(s)"
  --           gp.Prompt(
  --             params,
  --             gp.Target.rewrite,
  --             nil,
  --             gp.config.command_model,
  --             template,
  --             gp.config.command_system_prompt
  --           )
  --         end,
  --       },
  --     })

  --     local function keymapOptions(desc)
  --       return {
  --         noremap = true,
  --         silent = true,
  --         nowait = true,
  --         desc = "GPT prompt " .. desc,
  --       }
  --     end

  --     -- Chat commands
  --     vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
  --     vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))
  --   end,
  -- },
  {
    -- PluginNameAnchor
    "sindrets/diffview.nvim",
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        use_icons = false,
      })

      vim.keymap.set("n", "<Leader>D", "<cmd>DiffviewOpen<cr>")
      vim.keymap.set("n", "<Leader>d", "<cmd>DiffviewOpen main<cr>")
      vim.keymap.set("n", "<Leader>H", "<cmd>DiffviewFileHistory<cr>")
      vim.keymap.set("n", "<Leader>h", "<cmd>DiffviewFileHistory %<cr>")
    end,
  },
  {
    -- PluginNameAnchor
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        highlights = {
          -- highlights which map to a highlight group name and a table of it's values
          -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
          NormalFloat = {
            link = "Normal",
          },
          FloatBorder = {
            guifg = "#4a4a59",
            guilbg = "#4a4a59",
          },
        },
      })
    end,
    version = "*",
    config = true,
  },
  {
    -- PluginNameAnchor
    "nvim-telescope/telescope.nvim",
    config = function()
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

      local telescope = require("telescope.builtin")

      vim.keymap.set("n", "<Leader>f", telescope.find_files)
      vim.keymap.set("n", "<Leader>g", telescope.live_grep)
      vim.keymap.set("n", "<Leader>u", telescope.grep_string)
      vim.keymap.set("n", "<Leader>c", telescope.git_commits)
      vim.keymap.set("n", "<Leader>cb", telescope.git_bcommits)
      vim.keymap.set("n", "<Leader>s", telescope.git_status)
      vim.keymap.set("n", "<Leader>rf", telescope.lsp_references)
      vim.keymap.set("n", "<Leader>b", telescope.buffers)

      -- vim.keymap.set("n", "<Leader>o", telescope.oldfiles)
      -- vim.keymap.set("n", "<Leader>f", telescope.git_files)
      -- vim.keymap.set("n", "<Leader>gb", telescope.git_branches)
      -- vim.keymap.set("n", "<Leader>gst", telescope.git_stash)
      -- vim.keymap.set("n", "<Leader>d", telescope.diagnostics)
      -- vim.keymap.set("n", "<Leader>i", telescope.lsp_implementations)
      -- vim.keymap.set('n', '<Leader>td', telescope.lsp_type_definitions)
      -- vim.keymap.set("n", "<Leader>vc", telescope.commands)
      -- vim.keymap.set("n", "<Leader>vo", telescope.vim_options)
      -- vim.keymap.set("n", "<Leader>?", telescope.keymaps)
    end,
    dependencies = {
      "BurntSushi/ripgrep",
    },
  },

  -- {
  --   -- PluginNameAnchor
  --   "hrsh7th/nvim-cmp",
  --   config = function()
  --     local cmp = require("cmp")
  --     cmp.setup({
  --       mapping = {
  --         -- Open completion menu
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         -- Select next item
  --         ["<C-n>"] = cmp.mapping.select_next_item(),
  --         -- Select previous item
  --         ["<C-p>"] = cmp.mapping.select_prev_item(),
  --         -- Confirm selection
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }),
  --       },
  --       sources = {
  --         {
  --           -- Use LSP as the completion source
  --           name = "nvim_lsp",
  --         },
  --       },
  --     })
  --   end,
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-path",
  --   },
  -- },
  {
    -- PluginNameAnchor
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      -- require("lsp_signature").setup(opts)
      require("lsp_signature").setup({
        max_height = 80,
        hint_enable = false,
        handler_opts = {
          border = "none", -- double, rounded, single, shadow, none, or a table of borders
        },
        padding = " ",
      })
    end,
  },
})

function get_git_branch()
  local raw_branch = vim.fn.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))
  return raw_branch
end

function remove_after_second_slash(inputString)
  local firstSlashIndex = string.find(inputString, "/")
  if firstSlashIndex then
    local secondSlashIndex = string.find(inputString, "/", firstSlashIndex + 1)
    if secondSlashIndex then
      return string.sub(inputString, 1, secondSlashIndex - 1)
    end
  end
  return inputString
end

function replace_slash_with_dashes(inputString)
  return string.gsub(inputString, "/", "-")
end

function format_git_branch_name(inputString)
  return replace_slash_with_dashes(remove_after_second_slash(inputString))
end

function get_file_path()
  local git_branch = get_git_branch()
  return vim.fn.expand("~/shared-2/.branch-notes/" .. format_git_branch_name(git_branch) .. ".md")
end

vim.keymap.set("n", "<Leader><C-m>", "<cmd>ToggleTerm<CR>")

vim.keymap.set("n", "<Leader>1", "<cmd>1ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>2", "<cmd>2ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>3", "<cmd>3ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>4", "<cmd>4ToggleTerm<CR>")

vim.keymap.set("n", "<Leader>5", '<cmd>5TermExec cmd="ncmpcpp --screen=browser && exit"<CR>')
vim.keymap.set("n", "<Leader>6", '<cmd>6TermExec cmd="nvim ' .. get_file_path() .. '"<CR>')
vim.keymap.set("n", "<Leader>7", "<cmd>7ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>8", "<cmd>8ToggleTerm<CR>")
vim.keymap.set("n", "<Leader>9", "<cmd>9ToggleTerm<CR>")

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  -- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  -- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = { "term://*" },
  callback = function()
    set_terminal_keymaps()
  end,
})

function get_window_id()
  return vim.fn.win_getid()
end

function focus_window(window_id)
  vim.api.nvim_set_current_win(window_id)
end

function write_and_close_current_window()
  vim.cmd(":wq")
end

function create_vertical_split()
  -- vim.cmd("bo 56vsp " .. get_file_path())
  vim.api.nvim_command("bo 56vsp") -- move to nvim_cmd
  vim.cmd("set winfixwidth") -- Fix the width of the window
  vim.cmd("wincmd =") -- Equalize windows
  vim.cmd("set nonumber")
  vim.cmd("set norelativenumber")
  vim.cmd("e " .. get_file_path())

  return get_window_id()
end

function ToggleVerticalSplit(file_path)
  -- vim.g.right_split_content = file_path
  local there_is_no_split = vim.g.vertical_split_window_id == nil

  if there_is_no_split then
    vim.g.vertical_split_window_id = create_vertical_split()

    vim.api.nvim_create_autocmd({ "WinClosed" }, {
      pattern = { "*" },
      callback = function()
        -- We don't want to exex the callback if it's not the split we opened
        if vim.g.vertical_split_window_id ~= get_window_id() then
          return false
        end
        vim.g.vertical_split_window_id = nil
        return true -- Remove the autocmd
      end,
    })
    return
  end

  -- break the rules: add to garden new way of naming booleans (that is good with if conditionals)
  local split_is_in_focus = vim.g.vertical_split_window_id == get_window_id()

  if split_is_in_focus then
    write_and_close_current_window()
    vim.g.vertical_split_window_id = nil
    return
  end

  focus_window(vim.g.vertical_split_window_id)
end

vim.keymap.set("n", "<C-n>", ":lua ToggleVerticalSplit()<CR>", { noremap = true, silent = true })
