---@type vim.lsp.Config
return {
	cmd = { 'vscode-eslint-language-server', '--stdio' },
	filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
	root_markers = {
		'.eslintrc',
		'.eslintrc.js',
		'.eslintrc.cjs',
		'.eslintrc.yaml',
		'.eslintrc.yml',
		'.eslintrc.json',
		'eslint.config.js',
		'package.json',
	},

	settings = {
		validate = 'on',
		packageManager = nil,
		useESLintClass = false,
		codeActionOnSave = {
			enable = false,
			mode = 'all',
		},
		format = false,
		quiet = false,
		onIgnoredFiles = 'off',
	},

	on_attach = function(client, bufnr)
		-- Disable formatting - use Biome or ts_ls instead
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
