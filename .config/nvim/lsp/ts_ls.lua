---@type vim.lsp.Config
return {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
	root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },

	init_options = {
		preferences = {
			importModuleSpecifierPreference = 'non-relative',
			importModuleSpecifierEnding = 'minimal',
		},
	},

	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = 'all',
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = 'all',
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
}
