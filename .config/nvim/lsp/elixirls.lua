---@type vim.lsp.Config
return {
	cmd = { "elixir-ls" },
	filetypes = { "elixir", "eelixir", "heex", "surface" },
	root_markers = { "mix.exs", ".git" },

	settings = {
		elixirLS = {
			dialyzerEnabled = true,
			dialyzerIncremental = true,
			enableTestLenses = true,
			fetchDeps = true,
			suggestSpecs = true,

			-- builds project automatically when files change
			autoBuild = true,

			-- run formatter from .formatter.exs
			enableFormatter = true,

			-- enables credo diagnostics if credo is in deps
			credoEnabled = true,
		},
	},
}
