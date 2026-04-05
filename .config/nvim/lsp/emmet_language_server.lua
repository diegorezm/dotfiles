---@type vim.lsp.Config
return {
	cmd = { 'emmet-language-server', '--stdio' },
	filetypes = {
		'html',
		'css',
		'scss',
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
	},
	root_markers = { '.git', 'package.json' },
	init_options = {
		showExpandedAbbreviation = 'always',
		showSuggestionsAsSnippets = true,
	},
}
