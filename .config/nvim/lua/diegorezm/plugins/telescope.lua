return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"kelly-lin/telescope-ag",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local telescope_ag = require("telescope-ag")

		telescope_ag.setup({
			cmd = telescope_ag.cmds.rg,
		})

		telescope.setup({
			pickers = {
				find_files = {
					theme = "dropdown",
				},
			},
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
				},
			},
		})

		local keymap = vim.keymap
		telescope.load_extension("fzf")
		telescope.load_extension("ag")
		keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ag", "<cmd>Ag .<cr>", { desc = "Use silver searcher" })
	end,
}
