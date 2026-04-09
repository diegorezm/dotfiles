local M = {}

-- ─────────────────────────────────────────────────────────────
-- Helpers to read colors from the current colorscheme
-- ─────────────────────────────────────────────────────────────
local function fg_of(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
	if not ok or not hl.fg then
		return nil
	end
	return string.format("#%06x", hl.fg)
end

local function set_highlights()
	vim.api.nvim_set_hl(0, "StGitBranch", {
		fg = fg_of("Identifier"),
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StFileName", {
		fg = fg_of("Normal"),
	})
	vim.api.nvim_set_hl(0, "StModified", {
		fg = fg_of("DiagnosticWarn"),
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StPosition", {
		fg = fg_of("Comment"),
	})
	vim.api.nvim_set_hl(0, "StDiagError", {
		fg = fg_of("DiagnosticError"),
		bold = true,
	})
	vim.api.nvim_set_hl(0, "StDiagWarn", {
		fg = fg_of("DiagnosticWarn"),
	})
	vim.api.nvim_set_hl(0, "StDiagHint", {
		fg = fg_of("DiagnosticHint"),
	})
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_highlights,
})

-- ─────────────────────────────────────────────────────────────
-- Helper to apply highlight inside statusline
-- ─────────────────────────────────────────────────────────────
local function hl(group, text)
	return string.format("%%#%s#%s%%*", group, text)
end

-- ─────────────────────────────────────────────────────────────
-- Git branch cache (per buffer)
-- ─────────────────────────────────────────────────────────────
local git_branch_cache = {}

function M.get_git_branch()
	local bufnr = vim.api.nvim_get_current_buf()
	if git_branch_cache[bufnr] then
		return git_branch_cache[bufnr]
	end
	local handle = io.popen('git branch --show-current 2>/dev/null')
	if handle then
		local branch = handle:read("*l")
		handle:close()
		if branch and branch ~= '' then
			git_branch_cache[bufnr] = '   ' .. branch
			return git_branch_cache[bufnr]
		end
	end
	git_branch_cache[bufnr] = ''
	return ''
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
	callback = function()
		git_branch_cache = {}
	end,
})

-- ─────────────────────────────────────────────────────────────
-- LSP diagnostics with icons
-- ─────────────────────────────────────────────────────────────
local icons = {
	error = "",
	warn  = "",
	hint  = "",
}

local function get_diagnostics()
	local bufnr  = vim.api.nvim_get_current_buf()
	local errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
	local warns  = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
	local hints  = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT })

	local parts  = {}

	if errors > 0 then
		table.insert(parts,
			hl("StDiagError", string.format(" %s %d ", icons.error, errors))
		)
	end

	if warns > 0 then
		table.insert(parts,
			hl("StDiagWarn", string.format(" %s %d ", icons.warn, warns))
		)
	end

	if hints > 0 then
		table.insert(parts,
			hl("StDiagHint", string.format(" %s %d ", icons.hint, hints))
		)
	end

	return table.concat(parts, " ")
end

-- ─────────────────────────────────────────────────────────────
-- Statusline builder
-- ─────────────────────────────────────────────────────────────
function M.statusline()
	local parts = {}

	-- Git branch
	local branch = M.get_git_branch()
	if branch ~= '' then
		table.insert(parts, hl("StGitBranch", branch))
		table.insert(parts, ' ')
	end

	-- Filename
	local filename = vim.fn.expand('%:t')
	if filename == '' then
		filename = '[No Name]'
	end
	table.insert(parts, hl("StFileName", filename))

	-- Modified indicator
	if vim.bo.modified then
		table.insert(parts, hl("StModified", ' ●'))
	end

	-- Diagnostics
	local diags = get_diagnostics()
	if diags ~= '' then
		table.insert(parts, ' ')
		table.insert(parts, diags)
	end

	-- Push right
	table.insert(parts, '%=')

	-- Position info
	local line    = vim.fn.line('.')
	local col     = vim.fn.col('.')
	local percent = math.floor((line / vim.fn.line('$')) * 100)
	local pos     = string.format(' %d:%d  %d%% ', line, col, percent)
	table.insert(parts, hl("StPosition", pos))

	return table.concat(parts, '')
end

-- ─────────────────────────────────────────────────────────────
-- Activate statusline
-- ─────────────────────────────────────────────────────────────
vim.opt.statusline = '%!v:lua.require("statusline").statusline()'

return M
