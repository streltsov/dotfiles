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
