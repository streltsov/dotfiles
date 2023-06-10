-- Import the 'cmp' module for autocompletion functionality
local cmp = require'cmp'

-- Set up the global configuration for 'cmp'
cmp.setup({
  snippet = {
    -- Define how snippets are expanded.
    -- Here, we are using the 'snippy' module to expand snippets.
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  window = {
    -- Here you can customize cmp's completion window (left empty in your case)
  },
  mapping = cmp.mapping.preset.insert({
    -- Set up custom key mappings for cmp functionality within Insert mode
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll docs upwards
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll docs downwards
    -- ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion (commented out)
    ['<C-e>'] = cmp.mapping.abort(),          -- Abort completion
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept completion
  }),
  -- Set up the completion sources for cmp
  sources = cmp.config.sources({
    { name = 'buffer' }, -- Use words from the current buffer as source
    { name = 'nvim_lsp' }, -- Use Language Server Protocol as source
    { name = 'snippy' }, -- Use 'snippy' module as source
  }, {
  })
})

-- Set up filetype-specific configuration for 'cmp'
-- This configuration applies when editing Git commit messages
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- Use Git related words as source
  }, {
    { name = 'buffer' }, -- Use words from the current buffer as source
  })
})

-- Set up cmdline-specific configuration for 'cmp'
-- This configuration applies when using the '/' and '?' commands
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(), -- Use default cmdline mappings
  sources = {
    { name = 'buffer' } -- Use words from the current buffer as source
  }
})

-- Set up cmdline-specific configuration for 'cmp'
-- This configuration applies when using the ':' command
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(), -- Use default cmdline mappings
  sources = cmp.config.sources({
    { name = 'path' } -- Use file paths as source
  }, {
    { name = 'cmdline' } -- Use words from the command line history as source
  })
})

