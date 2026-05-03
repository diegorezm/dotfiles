---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
	-- init_options: DO NOT set manually, auto-populated from settings

	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				buildScripts = { enable = true },
			},

			check = {
				command = "clippy",
			},

			procMacro = {
				enable = true,
			},

			inlayHints = {
				bindingModeHints = { enable = true },
				chainingHints = { enable = true },
				closingBraceHints = { enable = true, minLines = 25 },
				closureReturnTypeHints = { enable = "always" },
				lifetimeElisionHints = { enable = "always", useParameterNames = true },
				maxLength = 25,
				parameterHints = { enable = true },
				reborrowHints = { enable = "always" },
				renderColons = true,
				typeHints = { enable = true, hideClosureInitialization = false },
			},

			completion = {
				postfix = { enable = true },
				privateEditable = { enable = true },
			},

			diagnostics = {
				enable = true,
				experimental = { enable = true },
			},

			hover = {
				actions = { enable = true },
			},
		},
	},
}
