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
  -- {
  --   -- PluginNameAnchor
  --   "nvim-treesitter/nvim-treesitter",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       auto_install = true,
  --       ensure_installed = {
  --         "vimdoc",
  --         "lua",
  --         "vim",
  --         "html",
  --         "css",
  --         "javascript",
  --         "typescript",
  --         "tsx",
  --       },
  --       autotag = {
  --         enable = true,
  --         filetypes = {
  --           "html",
  --           "javascript",
  --           "typescript",
  --           "javascriptreact",
  --           "typescriptreact",
  --           "svelte",
  --           "vue",
  --           "tsx",
  --           "jsx",
  --           "rescript",
  --           "css",
  --           "lua",
  --           "xml",
  --           "php",
  --           "markdown",
  --         },
  --       },
  --       indent = {
  --         enable = true,
  --       },
  --     })
  --   end,
  -- },
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
        chat_model = {
          model = "gpt-3.5-turbo-16k",
          temperature = 1.1,
          top_p = 1,
        },
        chat_system_prompt = "You are a general AI assistant.",
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

        command_prompt_prefix = "🤖 ~ ",
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
    end,
  },
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
})

-- Custom

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

function get_height_16_9(width)
  -- 16:9 aspect ratio
  return math.floor(width / 16) * 9
end

function mergeTables(t1, t2)
  local result = {}

  -- Copy key-value pairs from t1
  for k, v in pairs(t1) do
    result[k] = v
  end

  -- Copy key-value pairs from t2, overwriting existing keys
  for k, v in pairs(t2) do
    result[k] = v
  end

  return result
end

local general_popup_options = {
  position = "50%",
  enter = true,
  focusable = true,
  zindex = 50,
  relative = "editor",
  border = {
    padding = {
      top = 2,
      bottom = 2,
      left = 3,
      right = 3,
    },
    style = "single",
  },
  buf_options = {
    modifiable = true,
    readonly = false,
  },
  win_options = {
    winblend = 10,
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
  },
  text = {
    top_align = "center",
    bottom_align = "left",
  },
  -- You can pass bufnr of an existing buffer to display it on the popup.
  -- bufnr = vim.api.nvim_get_current_buf(),
}

-- text = {
-- top = "Branch notes", -- (" .. get_git_branch() .. ")",
--   top_align = "center",
-- bottom = formatGitBranchName(get_git_branch()),
--   bottom_align = "left",
-- }

local Popup = require("nui.popup")
function open_popup(command, popup_options)
  local neovim_width = (vim.api.nvim_get_option_value("columns", {}))
  local popup_width = math.floor(neovim_width * 0.8)
  local popup_height = math.floor(get_height_16_9(popup_width) / 2.5) -- looks like columns and lines values are not equal

  size = {
    width = popup_width,
    height = popup_height,
  }

  local popup_options = mergeTables(general_popup_options, {
    size = size,
  })

  local popup = Popup(popup_options)

  popup:mount()

  if command then
    vim.cmd(command)
    if string.sub(command, 1, 3) == "ter" then
      -- vim.api.nvim_open_term
      vim.api.nvim_feedkeys("a", "n", true)
    end
  else
    vim.cmd('terminal echo "No command provided. Terminal opened."')
  end

  -- Events

  -- local ok = popup:map("n", "<esc>", function(bufnr)
  --   print("ESC pressed in Normal mode!")
  -- end, { noremap = true })

  local event = require("nui.utils.autocmd").event
  -- popup:on({ event.BufLeave }, function()
  --   popup:unmount()
  -- end, { once = true })

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  -- vim.api.nvim_create_autocmd({ "WinClosed" }, {
  --   pattern = { "*" },
  --   callback = function()
  --     popup:unmount()
  --     return true -- Remove the autocmd
  --   end,
  -- })
end

-- General terminal
vim.keymap.set("n", "<Leader><Leader>", function()
  open_popup("terminal")
end)

-- Pomodoro (ncmpcpp)
vim.keymap.set("n", "<Leader>p", function()
  open_popup("terminal ncmpcpp -s browser")
end)

-- Global notes
vim.keymap.set("n", "<Leader>m", function()
  open_popup("e ~/shared-2/.branch-notes/.global-notes.md")
end)

-- Branch notes
vim.keymap.set("n", "<Leader>n", function()
  open_popup("e " .. get_file_path())
end)
