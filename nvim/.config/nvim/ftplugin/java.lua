local jdtls = require("jdtls")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local root_dir = vim.fs.dirname(
  vim.fs.find({ "gradlew", "pom.xml", "build.gradle", ".git" }, { upward = true })[1]
)

local workspace = vim.fn.stdpath("data") .. "/jdtls-workspaces/" ..
  vim.fn.fnamemodify(root_dir, ":t")

jdtls.start_or_attach({
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls", "--data", workspace },
  root_dir = root_dir,
  capabilities = capabilities,   -- this is what was missing

  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "<leader>ji", jdtls.organize_imports,  opts)
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable,  opts)
    vim.keymap.set("v", "<leader>jm", jdtls.extract_method,    opts)
  end,
})
