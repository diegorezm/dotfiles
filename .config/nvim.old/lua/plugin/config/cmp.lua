-- variables
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- loading vscode snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- cmp stup
cmp.setup({
  completion = {
    completeopt = "menu,menuone,preview,noselect",
  },
  snippet = {
    -- configure how nvim-cmp interacts with snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),             -- previous suggestion
    ["<C-j>"] = cmp.mapping.select_next_item(),             -- next suggestion
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),                -- move backwards on preview window
    ["<C-f>"] = cmp.mapping.scroll_docs(4),                 -- move fowards on preview window
    ["<C-Space>"] = cmp.mapping.complete(),                 -- show completion suggestions
    ["<C-e>"] = cmp.mapping.abort(),                        -- close completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }),     -- confirm on enter
  }),

  -- sources
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),

  -- icons on completion
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },
})
