vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	{ src = "https://github.com/RRethy/base16-nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag", },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/L3MON4D3/LuaSnip",                  version = "v2.5.0", },
})

require('nvim-treesitter').setup {
	install_dir = vim.fn.stdpath('data') .. '/site',
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
	autotag = {
		enable = true,
	},
	sync_install = false,
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"html",
		"css",
		"markdown",
		"bash",
		"lua",
		"dockerfile",
		"gitignore",
	},
}

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	},
})

require('nvim-ts-autotag').setup({})
require("nvim-highlight-colors").setup {
	render = 'virtual',
	virtual_symbol = '⚫︎',
	virtual_symbol_suffix = '',
}

require('matugen').setup()
require("oil").setup()
require("mini.icons").setup()
