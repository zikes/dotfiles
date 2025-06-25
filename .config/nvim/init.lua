vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
local cmd = vim.api.nvim_command

opt.termguicolors = true

-- disable the mouse
opt.mouse = ""

-- highlight the 80th column
opt.colorcolumn = "80"

-- use system clipboard
opt.clipboard = "unnamedplus"

-- case insensitive and smart case matching
opt.ignorecase = true
opt.smartcase = true

-- incremental search without highlights
opt.incsearch = true
opt.hlsearch = false

-- auto indent and convert tabs to spaces
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

-- 2 spaces for tabs
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- keep 5 lines of padding above and below and 5 characters to each side
opt.scrolloff = 5
opt.sidescrolloff = 5

opt.list = true
opt.listchars = "tab:→\\ ,trail:~,extends:>,precedes:<"

-- When in Insert mode, Shift+Tab to insert literal tab
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-V><Tab>", { noremap = true, silent = true})

require("config.lazy")
