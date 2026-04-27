vim.lsp.enable({
	'lua_ls',
	'ts_ls',
	'elixirls',
	'biome',
	'eslint',
	'gopls',
	'emmet_language_server',
})



vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = 'rounded',
		source = 'if_many',
	},
	underline = true,
	virtual_text = {
		spacing = 2,
		source = 'if_many',
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = 'E',
			[vim.diagnostic.severity.WARN] = 'W',
			[vim.diagnostic.severity.INFO] = 'I',
			[vim.diagnostic.severity.HINT] = 'H',
		},
	},
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.o.signcolumn = 'yes:1'
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method('textDocument/completion') then
			vim.o.complete = 'o,.,w,b,u,f'
			vim.o.completeopt = 'menu,menuone,popup,noinsert'
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

			local keymap = vim.keymap.set

			keymap('n', '<leader>dd', vim.diagnostic.open_float, { buffer = args.buf })
			keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Code Rename" })
			keymap("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover Documentation" })
			keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover (alt)" })
			keymap("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
			keymap("i", "<C-space>", vim.lsp.completion.get, { desc = "Trigger completion" })
			keymap('n', ']d', function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, { desc = 'Next diagnostic' })
			keymap('n', '[d', function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, { desc = 'Previous diagnostic' })
			keymap('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Diagnostics to quickfix' })

			keymap('i', '<C-f>', '<C-x><C-f>', { buffer = args.buf, desc = 'Filepath completion' })
		end

		if client:supports_method('textDocument/formatting') then
			vim.keymap.set('n', '<leader>f', function()
				vim.lsp.buf.format({ async = true })
			end, { buffer = args.buf, desc = 'Format buffer' })
		end
	end
})
