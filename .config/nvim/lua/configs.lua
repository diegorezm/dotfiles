local opt = vim.opt
local cmd = vim.cmd

opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.smartcase = true
opt.colorcolumn = '80'
opt.textwidth = 80
opt.completeopt = 'menu,menuone,fuzzy,noinsert'
opt.swapfile = false
opt.confirm = false
opt.linebreak = true
opt.termguicolors = true
opt.wildoptions:append { 'fuzzy' }
opt.path:append { '**' }
opt.smoothscroll = true
opt.grepprg = 'rg --vimgrep --no-messages --smart-case'
opt.statusline = ' %f%m %= %l:%c  %p%% '
opt.winborder = "rounded"
opt.inccommand = "nosplit"
opt.ignorecase = true
opt.autoindent = true
-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
vim.o.clipboard = "unnamedplus"

opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
opt.undofile = true

cmd('syntax off')
cmd.filetype("plugin indent on")


vim.g.copilot_no_tab_map = true
vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"


local ok_ui2, ui2 = pcall(require, "vim._core.ui2")
if ok_ui2 and type(ui2.enable) == "function" then
	ui2.enable({
		enable = true,
		msg = {
			targets = "cmd",
			timeout = 4000,
		},
	})
end
