vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("nvim-highlight-colors").setup()
require("mini.icons").setup()
require("oil").setup()
require("ibl").setup()

require("diffview").setup({
    enhanced_diff_hl = true,
    use_icons = false,
    view = {
        default = {
            layout = "diff2_horizontal",
            disable_diagnostics = true,
        },
        merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
        },
        file_history = {
            layout = "diff2_horizontal",
            disable_diagnostics = true,
        },
    },
    file_panel = {
        listing_style = "tree",
        win_config = {
            position = "left",
            width = 35,
        },
    },
})
