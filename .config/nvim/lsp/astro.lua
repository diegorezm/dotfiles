---@type vim.lsp.Config
return {
	cmd = { 'astro-ls', '--stdio' },
	filetypes = { 'astro' },
	root_markers = { 'package.json', 'astro.config.mjs', 'astro.config.cjs', 'astro.config.ts', '.git' },
	init_options = {
		typescript = {},
	},
	on_new_config = function(config, root_dir)
		config.init_options.typescript.tsdk = root_dir .. '/node_modules/typescript/lib'
	end,
}
