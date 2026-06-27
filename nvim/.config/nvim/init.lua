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

  -- --- Utilities ---
  { "junegunn/goyo.vim" },
  { "junegunn/fzf.vim" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "ap/vim-css-color" },

  -- --- Telescope ---
  { "nvim-telescope/telescope.nvim" },

  -- --- Colorschemes ---
  { "ellisonleao/gruvbox.nvim" },
  {
    "vimcolorschemes/olive-crt.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- --- File Tree ---
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 30 },
        renderer = {
          group_empty = true,
          icons = {
            show = { git = true, file = false, folder = false, folder_arrow = true },
            glyphs = {
              folder = { arrow_closed = "⏵", arrow_open = "⏷" },
              git = {
                unstaged = "✗", staged = "✓", unmerged = "⌥",
                renamed = "➜", untracked = "★", deleted = "⊖", ignored = "◌",
              },
            },
          },
        },
        filters = { dotfiles = true },
      })
    end
  },

  -- --- Java LSP ---
  { "mfussenegger/nvim-jdtls" },

  -- --- Mason (installs LSP server binaries) ---
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- --- Snippets ---
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  -- --- Completion ---
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
		completion = {
    	  -- autocomplete = { cmp.TriggerEvent.TextChanged },
          autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
  		},

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-d>"]     = cmp.mapping.scroll_docs(4),
        }),
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = false,
      })

      -- $ pair for Typst math mode
      local Rule = require("nvim-autopairs.rule")
      autopairs.add_rule(Rule("$", "$", "typst"))

      -- cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",          -- only load when opening a .typ file
    version = "1.*",
    opts = {},             -- uses default config; customize here if needed
  },
})

-- Colorschemes
vim.cmd.colorscheme("olive-crt")

-- --- LSP Setup (native nvim 0.11 API, no lspconfig needed) ---
-- attach keybinds whenever any LSP connects to a buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    opts)
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,    opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,         opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   opts)
    vim.keymap.set("n", "<leader>ji", vim.lsp.buf.format,        opts)
  end,
})

-- configure lua_ls directly (no lspconfig wrapper)
vim.lsp.config("lua_ls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable("lua_ls")

vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { "typst.toml", ".git" },
  offset_encoding = "utf-8",  -- required, tinymist needs this
  settings = {
    tinymist = {
      exportPdf = "onType",   -- or "onSave" / "never"
      formatterMode = "typstyle",
    },
  },
})

vim.lsp.enable("tinymist")

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

vim.diagnostic.config({
  signs = { priority = 10 },
})
vim.opt.signcolumn = "yes"

-- --- Keybinds ---
vim.g.mapleader = " "
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>g", builtin.live_grep,  { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>b", builtin.buffers,    { desc = "Telescope buffers" })
vim.keymap.set("n", "<Leader>d", ":Ex<CR>",          { silent = true })
vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { silent = true })

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,            { desc = "Harpoon add file" })
vim.keymap.set("n", "<C-e>",     function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

vim.diagnostic.config({
  virtual_text = true,  -- shows the error message inline at end of the line
  float = {
    border = "rounded",
    source = true,  -- shows which LSP is reporting it
  },
})
