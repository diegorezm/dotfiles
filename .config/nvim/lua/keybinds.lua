local keymap = vim.keymap.set

vim.g.mapleader = ' '
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open oil" })

vim.keymap.set('i', '<CR>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-y>'
	else
		return '<CR>'
	end
end, { expr = true })

keymap('i', '<C-j>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-n>'
	else
		return '<Tab>'
	end
end, { expr = true })

keymap('i', '<C-k>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-p>'
	else
		return '<S-Tab>'
	end
end, { expr = true })

-- TERMINAL
keymap("t", "<Esc>", "<C-\\><C-N>")

-- FZF
local fzf = require('fzf-lua')

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>bb', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fr', fzf.lsp_references, { desc = 'LSP references' })
vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "Code Actions" })

-- GIT
keymap("n", "<leader>gg", '<cmd>Git<CR>', {})
keymap("n", "<leader>gp", '<cmd>Git push<CR>', {})

-- Navigation
vim.keymap.set('n', '<C-n>', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<C-p>', ':tabprevious<CR>', { silent = true })

-- Management
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-q>', ':wq<CR>', { silent = true })
