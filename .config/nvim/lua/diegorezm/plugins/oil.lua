return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { {
		"nvim-tree/nvim-web-devicons",
		opts = {},
	} },
	lazy = false,
	config = function()
		require("oil").setup()
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
