return {
  'dense-analysis/ale',
  config = function()
    local g = vim.g

    g.ale_ruby_rubocop_auto_correct_all = 1
    g.ale_fix_on_save = 1

    g.ale_linters = {
      lua = { 'lua_language_server' },
      javascript = { "eslint", "biome" },
      typescript = { "eslint", "biome" },
      javascriptreact = { "eslint", "biome" },
      typescriptreact = { "eslint", "biome" },
      astro = { "eslint", "biome" },
      svelte = { "eslint", "biome" },
    }
  end
}
