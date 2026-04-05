local map = vim.keymap.set
local bs = { buffer = true, silent = true }
local brs = { buffer = true, remap = true, silent = true }


-- Initialize treesitter
vim.api.nvim_create_autocmd('FileType', {
	pattern = { '*' },
	callback = function()
		local ok, _ = pcall(vim.treesitter.start)
		if not ok then
			vim.cmd("syntax on")
		end
	end
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

-- Lsp attach
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.o.signcolumn = 'yes:1'
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method('textDocument/completion') then
			vim.o.complete = 'o,.,w,b,u'
			vim.o.completeopt = 'menu,menuone,popup,noinsert'
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

			vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { buffer = args.buf })
		end

		if client:supports_method('textDocument/formatting') then
			vim.keymap.set('n', '<leader>f', function()
				vim.lsp.buf.format({ async = true })
			end, { buffer = args.buf, desc = 'Format buffer' })
		end
	end
})


vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.highlight.on_yank() end,
})
