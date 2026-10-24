return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "go", "gomod", "gowork", "gosum", "gotmpl", "json", "comment", "sql", "rust", "gdscript" })

    -- enable highlighting and indentation for any filetype with a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end
}
