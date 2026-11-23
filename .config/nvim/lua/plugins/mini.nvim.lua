return {
  'nvim-mini/mini.nvim',
  version = '*',
  config = function()
    require("mini.ai").setup()

    require("mini.align").setup()

    local is_not_single_window = function(win_id)
      local tabpage_id = vim.api.nvim_win_get_tabpage(win_id)
      return #vim.api.nvim_tabpage_list_wins(tabpage_id) > 1
    end
    local animate = require("mini.animate")
    animate.setup({
      open = {
        -- Animate with wiping from nearest edge instead of default static one
        -- and only if it is not a single window in tabpage
        winconfig = animate.gen_winconfig.wipe({
          predicate = is_not_single_window,
          direction = 'from_edge',
        }),
      },
      close = {
        -- Animate with wiping to nearest edge instead of default static one
        -- and only if it is not a single window in tabpage
        winconfig = animate.gen_winconfig.wipe({
          predicate = is_not_single_window,
          direction = 'to_edge',
        }),
      },
    })

    require("mini.basics").setup()

    -- Show next-key hints after pressing a trigger key
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
      },
      clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
    })

    require("mini.fuzzy").setup()

    -- Replaces nvim-web-devicons for plugins that only support it
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()

    -- A snippet whose only tabstop is empty, like gopls's `Name(${1:})`, just
    -- needs the cursor placed there; skip the snippet session and its markers
    local is_single_empty_tabstop = function(snippet)
      local tabstops = vim.tbl_filter(function(node)
        return node.tabstop ~= nil and node.tabstop ~= "0"
      end, MiniSnippets.parse(snippet))
      if #tabstops ~= 1 then return false end
      local placeholder = tabstops[1].placeholder or {}
      return #placeholder == 0 or (#placeholder == 1 and placeholder[1].text == "")
    end

    -- Fuzzy-match LSP completion items, keeping mini.completion's kind sorting
    -- and highlighting
    require("mini.completion").setup({
      lsp_completion = {
        process_items = function(items, base)
          return MiniCompletion.default_process_items(items, base, {
            filtersort = MiniFuzzy.process_lsp_items,
          })
        end,
        snippet_insert = function(snippet)
          MiniCompletion.default_snippet_insert(snippet)
          if is_single_empty_tabstop(snippet) then MiniSnippets.session.stop() end
        end,
      },
    })

    require("mini.diff").setup()

    require("mini.git").setup()

    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    })

    require("mini.indentscope").setup()

    -- Tab/Shift+Tab cycle completion items, Enter accepts the selected one
    local map_multistep = require("mini.keymap").map_multistep
    map_multistep("i", "<Tab>", { "pmenu_next" })
    -- Shift+Tab inserts a literal tab when the completion menu is not visible
    local literal_tab = {
      condition = function() return true end,
      action = function() return "<C-V><Tab>" end,
    }
    map_multistep("i", "<S-Tab>", { "pmenu_prev", literal_tab })
    map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })

    require("mini.notify").setup()

    -- Only auto-close brackets when nothing but whitespace or a closing bracket
    -- follows the cursor, so typing an opening bracket before existing text
    -- wraps it instead of inserting an empty pair
    local open_neigh = "^[^\\][%s%)%]%}]"
    require("mini.pairs").setup({
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = open_neigh },
        ["["] = { action = "open", pair = "[]", neigh_pattern = open_neigh },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = open_neigh },
      },
    })

    require("mini.snippets").setup()
    -- End snippet sessions when leaving Insert mode, so tabstop markers (like
    -- the final "∎") don't linger
    local stop_snippet_sessions = function()
      while MiniSnippets.session.get() do MiniSnippets.session.stop() end
    end
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniSnippetsSessionStart",
      callback = function()
        vim.api.nvim_create_autocmd("ModeChanged", { pattern = "*:n", once = true, callback = stop_snippet_sessions })
      end,
    })

    require("mini.splitjoin").setup()

    require("mini.statusline").setup()

    require("mini.surround").setup()

    require("mini.trailspace").setup()
    vim.api.nvim_create_user_command("TrimWhitespace", function()
      MiniTrailspace.trim()
      MiniTrailspace.trim_last_lines()
    end, { desc = "Trim trailing whitespace and blank lines at end of file" })
  end
}
