local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- keymaps
local on_attach = function(_, bufnr)
  opts.buffer = bufnr

  opts.desc = "go to definition"
  keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

  opts.desc = "hover function"
  keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

  opts.desc = "workspace symbol"
  keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

  opts.desc = "open float"
  keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

  opts.desc = "go to next diagnostic"
  keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)

  opts.desc = "go to prev diagnostic"
  keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)


  opts.desc = "code action"
  keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

  opts.desc = "references"
  keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

  opts.desc = "rename"
  keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

  opts.desc = "format"
  keymap.set("n", "<leader>p", function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end, opts)

  opts.desc = "signature help"
  keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end


-- enable autocomplete
local capabilities = cmp_nvim_lsp.default_capabilities()

-- diagnostic icons
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure typescript server with plugin
lspconfig["tsserver"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    linter = "eslint_d"
  }
})

lspconfig["eslint"].setup({
  bin = "eslint_d",
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "typescriptreact", "javascriptreact", "svelte", "javascript", "typescript" },
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line",
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "save",
  },
})

-- configure css server
lspconfig["cssls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})


--  rust server
lspconfig["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true
      },
    }
  }
})

lspconfig["tailwindcss"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig["svelte"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "svelte" }
})

lspconfig["emmet_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})


lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  }
})

lspconfig["pyright"].setup({
  filetypes = { "python" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
      formatting = {
        provider = "black",
      },
      linter = "pylint",
    },
  },
})
