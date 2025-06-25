return {
  'echasnovski/mini.nvim',
  version = '*',
  dependencies = {
    "ray-x/go.nvim",
  },
  config = function()
    require("mini.ai").setup()

    require("mini.align").setup()

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

    require("mini.completion").setup()

    require("mini.diff").setup()

    require("mini.fuzzy").setup()

    require("mini.icons").setup()

    require("mini.indentscope").setup()

    require("mini.notify").setup()

    require("mini.pairs").setup()

    require("mini.statusline").setup()
  end
}
