---@type vim.lsp.Config
return {
	cmd = { 'biome', 'lsp-proxy' },
	filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'json', 'jsonc' },
	root_markers = { 'biome.json', 'biome.jsonc' },
	single_file_support = false,
}
