local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- servers i want to install
mason_lspconfig.setup({
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "emmet_ls",
    "pyright",
  },
  -- automatic installs
  automatic_installation = true,
})

-- formaters and linter for python and javascript
mason_tool_installer.setup({
  ensure_installed = {
    "prettier",
    "stylua",
    "isort",
    "black",
    "pylint",
    "eslint_d",
  },
})
local python_path = vim.fn.expand('$HOME') .. '/local/share/nvim/mason/packages/black/venv/bin/black'
vim.g.python3_host_prog = python_path
