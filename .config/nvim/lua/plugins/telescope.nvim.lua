return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = "close",
          },
          n = {
            ["<C-f>"] = "close",
          },
        },
        preview = {
          mime_hook = function(filepath, bufnr, opts)
            local is_image = function(filepath)
              local image_extensions = {'png','jpg'}   -- Supported image formats
              local split_path = vim.split(filepath:lower(), '.', {plain=true})
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _ )
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d..'\r\n')
                end
              end
              vim.fn.jobstart(
                {
                  'catimg', filepath  -- Terminal image viewer command
                }, 
                {on_stdout=send_output, stdout_buffered=true, pty=true})
            else
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
          end
        },
      },
    })
    vim.keymap.set("n", "<C-f>", builtin.find_files, {})
  end
}
