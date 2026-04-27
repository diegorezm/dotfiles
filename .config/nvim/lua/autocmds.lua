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


vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.highlight.on_yank() end,
})


vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end
})
