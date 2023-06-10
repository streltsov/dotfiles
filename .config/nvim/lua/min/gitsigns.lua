require('gitsigns').setup {
  -- Define the signs used in the sign column
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},  -- Sign for added lines
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},  -- Sign for modified lines
    delete       = {show_count = true, hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},  -- Sign for deleted lines
    topdelete    = {show_count = true, hl = 'GitSignsDelete', text = '^', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},  -- Sign for the topmost line of a deletion block
    changedelete = {show_count = true, hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},  -- Sign for changed lines that were also deleted
  },

  -- Disable the blame line by default
  current_line_blame = false,
  -- Options for the blame line
  current_line_blame_opts = {
    virt_text = true,  -- Use virtual text for the blame line
    virt_text_pos = 'eol',  -- Show the blame line at the end of the line
    delay = 0,  -- No delay for the blame line
    ignore_whitespace = false,  -- Don't ignore whitespace changes
  },
  -- Format for the blame line
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

  -- Define a keymapping for toggling the blame line
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
    -- Define the <leader>tb mapping for toggling the blame line
    map('n', '<leader>tb', gs.toggle_current_line_blame)
  end
}

