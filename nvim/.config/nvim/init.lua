-- =============================
-- Neovim Configuration (init.lua)
-- using Lazy.nvim
-- =============================

-- --- Bootstrap Lazy.nvim ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- Plugin Setup ---
require("lazy").setup({
  { "junegunn/goyo.vim" },
  { "junegunn/fzf.vim" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "ap/vim-css-color" },
  { "nvim-telescope/telescope.nvim" },
  { "ellisonleao/gruvbox.nvim" },
})

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = true,
})
vim.cmd("colorscheme gruvbox")

-- --- General Settings ---
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.modeline = true
vim.opt.hlsearch = false

vim.opt.termguicolors = true

-- --- Filetype Specific ---
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "org", "outline" },
  command = "setlocal nofoldenable",
})

-- --- Keybinds ---
vim.g.mapleader = " "
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set("n", "<Leader>d", ":Ex<CR>", { silent = true })

