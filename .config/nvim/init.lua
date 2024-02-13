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

-- Misc
-- Equalize window sizes when resizing
vim.cmd([[autocmd VimResized * wincmd =]])

-- Disable line numbers for Markdown files
-- vim.cmd([[
--   autocmd FileType markdown setlocal nonumber norelativenumber
-- ]])

-- vim.keymap.set("n", "<Leader><Leader>", "<cmd>:e NOTES.md<cr>")

-------------------------------------------------
------------------ Diagnostics ------------------
-------------------------------------------------

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
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

---------------------- Lazy ----------------------
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
    "MunifTanjim/nui.nvim",
  },
  {
    -- PluginNameAnchor
    "neovim/nvim-lspconfig",
    config = function()
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

          local opts = {
            buffer = ev.buf,
          }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)

          -- vim.keymap.set("n", "<Leader>rf", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })

      lspconfig.tailwindcss.setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "svelte",
        },
      })

      lspconfig.svelte.setup({
        filetypes = {
          "svelte",
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })

      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    end,
  },
  {
    -- PluginNameAnchor
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
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
            filetypes = {
              "javascript",
              "typescript",
              "svelte",
              "javascriptreact",
              "typescriptreact",
            },
          }),
          b.diagnostics.eslint_d.with({
            filetypes = {
              "javascript",
              "typescript",
              "svelte",
              "javascriptreact",
              "typescriptreact",
            },
            command = "eslint_d",
          }),
          b.formatting.stylua.with({
            filetypes = {
              "lua",
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
    "nvim-lua/plenary.nvim",
  },
  {
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
    "morhetz/gruvbox",
    init = function()
      vim.cmd("colorscheme gruvbox")
      vim.o.bg = "dark"
      -- vim.keymap.set("n", "<Leader>bg", '<cmd>lua vim.opt.bg = vim.opt.bg:get() == "light" and "dark" or "light"<CR>')
    end,
  },
  {
    -- PluginNameAnchor
    "lewis6991/gitsigns.nvim",
    config = function()
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
        use_diagnostic_signs = false,
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
  {
    -- PluginNameAnchor
    "robitx/gp.nvim",
    config = function()
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

        chat_model = {
          model = "gpt-3.5-turbo-16k",
          temperature = 1.1,
          top_p = 1,
        },
        -- chat_model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
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
        chat_topic_gen_model = "gpt-3.5-turbo-16k",
        -- explicitly confirm deletion of a chat file
        chat_confirm_delete = true,
        -- conceal model parameters in chat
        chat_conceal_model_params = true,
        -- local shortcuts bound to the chat buffer
        -- (be careful to choose something which will work across specified modes)
        chat_shortcut_respond = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g><C-g>",
        },
        chat_shortcut_delete = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g>d",
        },
        chat_shortcut_new = {
          modes = { "n", "i", "v", "x" },
          shortcut = "<C-g>n",
        },

        -- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
        -- command prompt prefix for asking user for input
        command_prompt_prefix = "🤖 ~ ",
        -- command model (string with model name or table with model name and parameters)
        -- command_model = { model = "gpt-4", temperature = 1.1, top_p = 1 },
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
            gp.Prompt(
              params,
              gp.Target.rewrite,
              nil,
              gp.config.command_model,
              template,
              gp.config.command_system_prompt
            )
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

      -- Chat commands
      vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
      vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
      vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

      -- vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
      -- vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
      -- vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

      -- vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
      -- vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
      -- vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

      -- vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
      -- vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
      -- vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

      -- Prompt commands
      -- vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

      -- vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
      -- vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
      -- vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
      -- vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

      -- vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

      -- vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
      -- vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
      -- vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
      -- vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
      -- vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

      -- vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
      -- vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

      -- vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
      -- vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))

      -- Optional Whisper commands with prefix <C-g>w
      -- vim.keymap.set({ "n", "i" }, "<C-g>ww", "<cmd>GpWhisper<cr>", keymapOptions("Whisper"))
      -- vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptions("Visual Whisper"))

      -- vim.keymap.set({ "n", "i" }, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", keymapOptions("Whisper Inline Rewrite"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", keymapOptions("Whisper Append (after)"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", keymapOptions("Whisper Prepend (before) "))

      -- vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", keymapOptions("Visual Whisper Rewrite"))
      -- vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", keymapOptions("Visual Whisper Append (after)"))
      -- vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", keymapOptions("Visual Whisper Prepend (before)"))

      -- vim.keymap.set({ "n", "i" }, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", keymapOptions("Whisper Popup"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>we", "<cmd>GpWhisperEnew<cr>", keymapOptions("Whisper Enew"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>wn", "<cmd>GpWhisperNew<cr>", keymapOptions("Whisper New"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", keymapOptions("Whisper Vnew"))
      -- vim.keymap.set({ "n", "i" }, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", keymapOptions("Whisper Tabnew"))

      -- vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", keymapOptions("Visual Whisper Popup"))
      -- vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", keymapOptions("Visual Whisper Enew"))
      -- vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", keymapOptions("Visual Whisper New"))
      -- vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", keymapOptions("Visual Whisper Vnew"))
      -- vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", keymapOptions("Visual Whisper Tabnew"))
    end,
  },
  {
    -- PluginNameAnchor
    "sindrets/diffview.nvim",
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        use_icons = false,
        -- Only applies when use_icons is true.
        -- icons = {
        --   folder_closed = "",
        --   folder_open = "",
        -- },
        -- See ':h diffview-config-enhanced_diff_hl'
        -- enhanced_diff_hl = false,
        -- Requires nvim-web-devicons
        -- Show hints for how to open the help panel
        -- show_help_hints = false,
        -- Show diffs for binaries
        -- diff_binaries = false,
        -- The git executable followed by default args.
        -- git_cmd = { "git" },
        -- The hg executable followed by default args.
        -- hg_cmd = { "hg" },
        -- Update views and index buffers when the git index changes.
        -- watch_index = true,
        -- signs = {
        --   fold_closed = "",
        --   fold_open = "",
        --   done = "✓",
        -- },
        view = {
          -- Configure the layout and behavior of different types of views.
          -- Available layouts:
          --  'diff1_plain'
          --    |'diff2_horizontal'
          --    |'diff2_vertical'
          --    |'diff3_horizontal'
          --    |'diff3_vertical'
          --    |'diff3_mixed'
          --    |'diff4_mixed'
          -- For more info, see ':h diffview-config-view.x.layout'.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_horizontal",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
            winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
            winbar_info = false, -- See ':h diffview-config-view.x.winbar_info'
          },
        },
        file_panel = {
          listing_style = "tree", -- One of 'list' or 'tree'
          tree_options = {
            -- Only applies when listing_style is 'tree'
            flatten_dirs = true, -- Flatten dirs that only contain one single dir
            folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
          },
          win_config = {
            -- See ':h diffview-config-win_config'
            position = "left",
            width = 35,
            win_opts = {},
          },
        },
        file_history_panel = {
          log_options = {
            -- See ':h diffview-config-log_options'
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
            hg = {
              single_file = {},
              multi_file = {},
            },
          },
          win_config = {
            -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = { -- See ':h diffview-config-win_config'
            win_opts = {},
          },
        },
        default_args = {
          -- Default args prepended to the arg-list for the listed commands
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {}, -- See ':h diffview-config-hooks'
        keymaps = {
          disable_defaults = false, -- Disable the default keymaps
          view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            {
              "n",
              "gf",
              actions.goto_file_edit,
              { desc = "Open the file in the previous tabpage" },
            },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel." } },
            { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle through available layouts." } },
            {
              "n",
              "[x",
              actions.prev_conflict,
              { desc = "In the merge-tool: jump to the previous conflict" },
            },
            {
              "n",
              "]x",
              actions.next_conflict,
              { desc = "In the merge-tool: jump to the next conflict" },
            },
            {
              "n",
              "<leader>co",
              actions.conflict_choose("ours"),
              { desc = "Choose the OURS version of a conflict" },
            },
            {
              "n",
              "<leader>ct",
              actions.conflict_choose("theirs"),
              { desc = "Choose the THEIRS version of a conflict" },
            },
            {
              "n",
              "<leader>cb",
              actions.conflict_choose("base"),
              { desc = "Choose the BASE version of a conflict" },
            },
            {
              "n",
              "<leader>ca",
              actions.conflict_choose("all"),
              { desc = "Choose all the versions of a conflict" },
            },
            { "n", "dx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
            {
              "n",
              "<leader>cO",
              actions.conflict_choose_all("ours"),
              { desc = "Choose the OURS version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cT",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cB",
              actions.conflict_choose_all("base"),
              { desc = "Choose the BASE version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cA",
              actions.conflict_choose_all("all"),
              { desc = "Choose all the versions of a conflict for the whole file" },
            },
            {
              "n",
              "dX",
              actions.conflict_choose_all("none"),
              { desc = "Delete the conflict region for the whole file" },
            },
          },
          diff1 = {
            -- Mappings in single window diff layouts
            { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            -- Mappings in 2-way diff layouts
            { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            -- Mappings in 3-way diff layouts
            {
              { "n", "x" },
              "2do",
              actions.diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              actions.diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            {
              { "n", "x" },
              "1do",
              actions.diffget("base"),
              { desc = "Obtain the diff hunk from the BASE version of the file" },
            },
            {
              { "n", "x" },
              "2do",
              actions.diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              actions.diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
          },
          file_panel = {
            {
              "n",
              "j",
              actions.next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "<down>",
              actions.next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "k",
              actions.prev_entry,
              { desc = "Bring the cursor to the previous file entry" },
            },
            {
              "n",
              "<up>",
              actions.prev_entry,
              { desc = "Bring the cursor to the previous file entry" },
            },
            {
              "n",
              "<cr>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "o",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "l",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "<2-LeftMouse>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "-",
              actions.toggle_stage_entry,
              { desc = "Stage / unstage the selected entry" },
            },
            {
              "n",
              "s",
              actions.toggle_stage_entry,
              { desc = "Stage / unstage the selected entry" },
            },
            { "n", "S", actions.stage_all, { desc = "Stage all entries" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
            {
              "n",
              "X",
              actions.restore_entry,
              { desc = "Restore entry to the state on the left side" },
            },
            { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
            { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
            { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
            { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            {
              "n",
              "<s-tab>",
              actions.select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
            {
              "n",
              "gf",
              actions.goto_file_edit,
              { desc = "Open the file in the previous tabpage" },
            },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
            {
              "n",
              "i",
              actions.listing_style,
              { desc = "Toggle between 'list' and 'tree' views" },
            },
            {
              "n",
              "f",
              actions.toggle_flatten_dirs,
              { desc = "Flatten empty subdirectories in tree listing style" },
            },
            {
              "n",
              "R",
              actions.refresh_files,
              { desc = "Update stats and entries in the file list" },
            },
            { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
            { "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
            {
              "n",
              "<leader>cO",
              actions.conflict_choose_all("ours"),
              { desc = "Choose the OURS version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cT",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cB",
              actions.conflict_choose_all("base"),
              { desc = "Choose the BASE version of a conflict for the whole file" },
            },
            {
              "n",
              "<leader>cA",
              actions.conflict_choose_all("all"),
              { desc = "Choose all the versions of a conflict for the whole file" },
            },
            {
              "n",
              "dX",
              actions.conflict_choose_all("none"),
              { desc = "Delete the conflict region for the whole file" },
            },
          },
          file_history_panel = {
            { "n", "g!", actions.options, { desc = "Open the option panel" } },
            {
              "n",
              "<C-A-d>",
              actions.open_in_diffview,
              { desc = "Open the entry under the cursor in a diffview" },
            },
            {
              "n",
              "y",
              actions.copy_hash,
              { desc = "Copy the commit hash of the entry under the cursor" },
            },
            { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
            { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
            {
              "n",
              "j",
              actions.next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "<down>",
              actions.next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "k",
              actions.prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<up>",
              actions.prev_entry,
              { desc = "Bring the cursor to the previous file entry." },
            },
            {
              "n",
              "<cr>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "o",
              actions.select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            {
              "n",
              "<2-LeftMouse>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry." },
            },
            { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            {
              "n",
              "<s-tab>",
              actions.select_prev_entry,
              { desc = "Open the diff for the previous file" },
            },
            {
              "n",
              "gf",
              actions.goto_file_edit,
              { desc = "Open the file in the previous tabpage" },
            },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "g?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
          },
          option_panel = {
            { "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
            { "n", "q", actions.close, { desc = "Close the panel" } },
            { "n", "g?", actions.help("option_panel"), { desc = "Open the help panel" } },
          },
          help_panel = {
            { "n", "q", actions.close, { desc = "Close help menu" } },
            { "n", "<esc>", actions.close, { desc = "Close help menu" } },
          },
        },
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
  {
    -- PluginNameAnchor
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          -- Open completion menu
          ["<C-Space>"] = cmp.mapping.complete(),
          -- Select next item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select previous item
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          -- Confirm selection
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          {
            -- Use LSP as the completion source
            name = "nvim_lsp",
          },
        },
      })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
  },

  -- {
  --   -- PluginNameAnchor
  --   "ldelossa/litee-calltree.nvim",
  --   config = function()
  --     require("litee.lib").setup({})
  --     require("litee.calltree").setup({})
  --     vim.lsp.handlers["callHierarchy/incomingCalls"] = vim.lsp.with(require("litee.lsp.handlers").ch_lsp_handler("from"), {})
  --     vim.lsp.handlers["callHierarchy/outgoingCalls"] = vim.lsp.with(require("litee.lsp.handlers").ch_lsp_handler("to"), {})
  --     vim.keymap.set("n", "<Leader>tc", "vim.lsp.buf.incoming_calls()")
  --     vim.keymap.set("n", "<Leader>tt", "vim.lsp.buf.outgoing_calls()")
  --   end,
  --   dependencies = {
  --     "ldelossa/litee.nvim",
  --   },
  -- },

  {
    -- PluginNameAnchor
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    -- PluginNameAnchor
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<Leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  -- {
  --   -- PluginNameAnchor
  --   "ray-x/navigator.lua",
  --   dependencies = {
  --     {
  --       "ray-x/guihua.lua",
  --       build = "cd lua/fzy && make",
  --     },
  --     {
  --       "neovim/nvim-lspconfig",
  --     },
  --   },
  --   config = function()
  --     require("navigator").setup({
  --       debug = false,         -- log output, set to true and log path: ~/.cache/nvim/gh.log
  --       -- slowdownd startup and some actions
  --       width = 0.75,          -- max width ratio (number of cols for the floating window) / (window width)
  --       height = 0.3,          -- max list window height, 0.3 by default
  --       preview_height = 0.35, -- max height of preview windows
  --       border = "none",       -- { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- border style, can be one of 'none', 'single', 'double',
  --       -- 'shadow', or a list of chars which defines the border
  --       on_attach = function(client, bufnr)
  --         -- your hook
  --       end,
  --       -- put a on_attach of your own here, e.g
  --       -- function(client, bufnr)
  --       --   -- the on_attach will be called at end of navigator on_attach
  --       -- end,
  --       -- The attach code will apply to all LSP clients

  --       ts_fold = {
  --         enable = false,
  --         comment_fold = true,                                                          -- fold with comment string
  --         max_lines_scan_comments = 20,                                                 -- only fold when the fold level higher than this value
  --         disable_filetypes = { "help", "guihua", "text" },                             -- list of filetypes which doesn't fold using treesitter
  --       },                                                                              -- modified version of treesitter folding
  --       default_mapping = true,                                                         -- set to false if you will remap every key or if you using old version of nvim-
  --       keymaps = { { key = "gK", func = vim.lsp.declaration, desc = "declaration" } }, -- a list of key maps
  --       -- this kepmap gK will override "gD" mapping function declaration()  in default kepmap
  --       -- please check mapping.lua for all keymaps
  --       -- rule of overriding: if func and mode ('n' by default) is same
  --       -- it can be overrided
  --       treesitter_analysis = true,          -- treesitter variable context
  --       treesitter_navigation = true,        -- bool|table false: use lsp to navigate between symbol ']r/[r', table: a list of
  --       --lang using TS navigation
  --       treesitter_analysis_max_num = 100,   -- how many items to run treesitter analysis
  --       treesitter_analysis_condense = true, -- condense form for treesitter analysis
  --       -- this value prevent slow in large projects, e.g. found 100000 reference in a project
  --       transparency = 0,                    -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil or 100 to disable it

  --       lsp_signature_help = true,           -- if you would like to hook ray-x/lsp_signature plugin in navigator
  --       -- setup here. if it is nil, navigator will not init signature help
  --       signature_help_cfg = nil,            -- if you would like to init ray-x/lsp_signature plugin in navigator, and pass in your own config to signature help
  --       icons = false,
  --       -- icons = {
  --       --   -- refer to lua/navigator.lua for more icons config
  --       --   -- requires nerd fonts or nvim-web-devicons
  --       --   icons = true,
  --       --   -- Code action
  --       --   code_action_icon = "🏏", -- note: need terminal support, for those not support unicode, might crash
  --       --   -- Diagnostics
  --       --   diagnostic_head = "🐛",
  --       --   diagnostic_head_severity_1 = "🈲",
  --       --   fold = {
  --       --     prefix = "⚡",  -- icon to show before the folding need to be 2 spaces in display width
  --       --     separator = "", -- e.g. shows   3 lines 
  --       --   },
  --       -- },
  --       mason = false,   -- set to true if you would like use the lsp installed by williamboman/mason
  --       lsp = {
  --         enable = true, -- skip lsp setup, and only use treesitter in navigator.
  --         -- Use this if you are not using LSP servers, and only want to enable treesitter support.
  --         -- If you only want to prevent navigator from touching your LSP server configs,
  --         -- use `disable_lsp = "all"` instead.
  --         -- If disabled, make sure add require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client}) in your
  --         -- own on_attach
  --         code_action = { enable = false, sign = true, sign_priority = 40, virtual_text = false },
  --         code_lens_action = { enable = false, sign = true, sign_priority = 40, virtual_text = false },
  --         document_highlight = true, -- LSP reference highlight,
  --         -- it might already supported by you setup, e.g. LunarVim
  --         format_on_save = true,     -- {true|false} set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
  --         -- table: {enable = {'lua', 'go'}, disable = {'javascript', 'typescript'}} to enable/disable specific language
  --         -- enable: a whitelist of language that will be formatted on save
  --         -- disable: a blacklist of language that will not be formatted on save
  --         -- function: function(bufnr) return true end to enable/disable lsp format on save
  --         format_options = { async = false },                  -- async: disable by default, the option used in vim.lsp.buf.format({async={true|false}, name = 'xxx'})
  --         disable_format_cap = { "sqlls", "lua_ls", "gopls" }, -- a list of lsp disable format capacity (e.g. if you using efm or vim-codeformat etc), empty {} by default
  --         -- If you using null-ls and want null-ls format your code
  --         -- you should disable all other lsp and allow only null-ls.
  --         -- disable_lsp = {'pylsd', 'sqlls'},  -- prevents navigator from setting up this list of servers.
  --         -- if you use your own LSP setup, and don't want navigator to setup
  --         -- any LSP server for you, use `disable_lsp = "all"`.
  --         -- you may need to add this to your own on_attach hook:
  --         -- require('navigator.lspclient.mapping').setup({bufnr=bufnr, client=client})
  --         -- for e.g. denols and tsserver you may want to enable one lsp server at a time.
  --         -- default value: {}
  --         diagnostic = {
  --           underline = true,
  --           virtual_text = true,      -- show virtual for diagnostic message
  --           update_in_insert = false, -- update diagnostic message in insert mode
  --           float = {
  --             -- setup for floating windows style
  --             focusable = false,
  --             sytle = "minimal",
  --             border = "rounded",
  --             source = "always",
  --             header = "",
  --             prefix = "",
  --           },
  --         },

  --         hover = {
  --           enable = true,
  --           keymap = {
  --             ["<C-k>"] = {
  --               go = function()
  --                 local w = vim.fn.expand("<cWORD>")
  --                 vim.cmd("GoDoc " .. w)
  --               end,
  --               default = function()
  --                 local w = vim.fn.expand("<cWORD>")
  --                 vim.lsp.buf.workspace_symbol(w)
  --               end,
  --             },
  --           },

  --           diagnostic_scrollbar_sign = { "▃", "▆", "█" }, -- experimental:  diagnostic status in scroll bar area; set to false to disable the diagnostic sign,
  --           --                for other style, set to {'╍', 'ﮆ'} or {'-', '='}
  --           diagnostic_virtual_text = true,                -- show virtual for diagnostic message
  --           diagnostic_update_in_insert = false,           -- update diagnostic message in insert mode
  --           display_diagnostic_qf = true,                  -- always show quickfix if there are diagnostic errors, set to false if you want to ignore it
  --           -- set to 'trouble' to show diagnositcs in Trouble
  --           tsserver = {
  --             filetypes = { "typescript" }, -- disable javascript etc,
  --             -- set to {} to disable the lspclient for all filetypes
  --           },
  --           ctags = {
  --             cmd = "ctags",
  --             tagfile = "tags",
  --             options = "-R --exclude=.git --exclude=node_modules --exclude=test --exclude=vendor --excmd=number",
  --           },
  --           gopls = {
  --             -- gopls setting
  --             on_attach = function(client, bufnr) -- on_attach for gopls
  --               -- your special on attach here
  --               -- e.g. disable gopls format because a known issue https://github.com/golang/go/issues/45732
  --               print("i am a hook, I will disable document format")
  --               client.resolved_capabilities.document_formatting = false
  --             end,
  --             settings = {
  --               gopls = { gofumpt = false }, -- disable gofumpt etc,
  --             },
  --           },
  --           -- the lsp setup can be a function, .e.g
  --           gopls = function()
  --             local go = pcall(require, "go")
  --             if go then
  --               local cfg = require("go.lsp").config()
  --               cfg.on_attach = function(client)
  --                 client.server_capabilities.documentFormattingProvider = false -- efm/null-ls
  --               end
  --               return cfg
  --             end
  --           end,

  --           lua_ls = {
  --             sumneko_root_path = vim.fn.expand("$HOME") .. "/github/sumneko/lua-language-server",
  --             sumneko_binary = vim.fn.expand("$HOME")
  --                 .. "/github/sumneko/lua-language-server/bin/macOS/lua-language-server",
  --           },
  --           servers = { "cmake", "ltex" }, -- by default empty, and it should load all LSP clients avalible based on filetype
  --           -- but if you whant navigator load  e.g. `cmake` and `ltex` for you , you
  --           -- can put them in the `servers` list and navigator will auto load them.
  --           -- you could still specify the custom config  like this
  --           -- cmake = {filetypes = {'cmake', 'makefile'}, single_file_support = false},
  --         },
  --       },
  --     })
  --   end,
  -- },
})
-- local Popup = require("nui.popup")

-- Functions --

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
  return "~/shared-2/.branch-notes/" .. format_git_branch_name(git_branch) .. ".md"
end

function open_split(file_path, width)
  vim.cmd("bo 66vsp " .. file_path)
end

function get_buffer_number()
  return vim.fn.bufnr("%")
end

function get_window_id()
  return vim.fn.win_getid()
end

-- local target_buffer_number = your_buffer_number
--
-- -- Iterate over all windows to find the one with the target buffer
-- for _, winid in ipairs(vim.api.nvim_list_wins()) do
--   local win_buffer_number = vim.api.nvim_win_get_buf(winid)
--   if win_buffer_number == target_buffer_number then
--     -- Set the current window to the one with the target buffer
--     vim.api.nvim_set_current_win(winid)
--     break
--   end
-- end

function get_window_id_by_buffer_number(buffer_number)
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local win_buffer_number = vim.api.nvim_win_get_buf(winid)
    if win_buffer_number == buffer_number then
      return winid
    end
  end
  return -1
end

-- // Functions //

function ToggleVerticalSplit()
  local current_buffer_number = get_buffer_number()
  local is_split_open = vim.g.branch_notes_buffer_number ~= nil

  if not is_split_open then
    vim.cmd("bo 66vsp " .. get_file_path())
    vim.g.branch_notes_buffer_number = get_buffer_number()
    return
  end

  local branch_notes_buffer_focused = vim.g.branch_notes_buffer_number == current_buffer_number

  if branch_notes_buffer_focused then
    vim.api.nvim_buf_delete(current_buffer_number, { force = true })
    vim.g.branch_notes_buffer_number = nil
    return
  end

  vim.api.nvim_set_current_win(get_window_id_by_buffer_number(vim.g.branch_notes_buffer_number))

  -- else
  --   if get_window_id_by_buffer_number(vim.g.branch_notes_buffer_number) == -1 then
  --     vim.cmd("bo 66vsp " .. get_file_path())
  --     vim.g.branch_notes_buffer_number = current_buffer_number
  --   else
  --     -- Set the current window to the one with the target buffer
  --     vim.api.nvim_set_current_win(get_window_id_by_buffer_number(vim.g.branch_notes_buffer_number))
  --   end
end

vim.keymap.set("n", "<C-n>", ":lua ToggleVerticalSplit()<CR>", { noremap = true, silent = true })

-- Function to toggle the vertical split
-- function ToggleVerticalSplit()
--   -- Check if the vertical split is open
--   local is_split_open = vim.fn.exists("g:my_vertical_split_open") and vim.g.my_vertical_split_open == 1
--
--   if is_split_open then
--     -- Close the vertical split
--     vim.cmd("vertical close")
--     vim.g.my_vertical_split_open = 0
--   else
--     -- Open the vertical split
--     vim.cmd("vsplit")
--     vim.g.my_vertical_split_open = 1
--   end
-- end

-- Map the function to a key combination (change this to your desired keymap)
-- vim.api.nvim_set_keymap('n', '<Leader>vs', ':lua ToggleVerticalSplit()<CR>', { noremap = true, silent = true })
--
--
-- -- Function to toggle the vertical split based on the target file path
-- function ToggleNamedVerticalSplit()
--   local target_file_path = get_file_path()
--   local current_file_path = vim.fn.expand("%:p")
--
--   -- Check if the current buffer is the target buffer (split is open)
--   if current_file_path == target_file_path then
--     vim.cmd("vertical close")
--   else
--     vim.cmd("vsplit " .. target_file_path)
--   end
-- end
--
-- -- Example: Toggle a vertical split with the file path determined by get_file_path
-- vim.api.nvim_set_keymap("n", "<Leader>vs", ":lua ToggleNamedVerticalSplit()<CR>", { noremap = true, silent = true })

-- local popup = Popup({
--   position = "50%",
--   size = {
--     width = 80,
--     height = 40,
--   },
--   enter = true,
--   focusable = true,
--   zindex = 50,
--   relative = "editor",
--   border = {
--     padding = {
--       top = 2,
--       bottom = 2,
--       left = 3,
--       right = 3,
--     },
--     style = "rounded",
--     text = {
--       top = "Branch notes (" .. get_git_branch() .. ")",
--       top_align = "center",
--       bottom = formatGitBranchName(get_git_branch()),
--       bottom_align = "left",
--     },
--   },
--   buf_options = {
--     modifiable = true,
--     readonly = false,
--   },
--   win_options = {
--     winblend = 10,
--     winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
--   },
-- })
--
-- vim.keymap.set("n", "<C-n>", function()
--   popup:mount()
-- end)
--
-- popup:map("n", "<Esc>", function(bufnr)
--   popup:unmount()
-- end, { noremap = true })
--
-- local event = require("nui.utils.autocmd").event
-- -- unmount component when cursor leaves buffer
-- popup:on(event.BufLeave, function()
--   popup:unmount()
-- end)

-- mount/open the component
-- popup:mount()

-- close on <esc> in normal mode
-- popup:map("n", "<esc>", function()
--   popup:unmount()
-- end, { once = true })

-- local ok = popup:map("n", "<esc>", function(bufnr)
--   print("ESC pressed in Normal mode!")
-- end, { noremap = true })

-- vim.keymap.set("n", "<leader><leader>", function()
--   local filepath = get_file_path()
--
--   vim.api.nvim_command("e " .. filepath)
-- end)
