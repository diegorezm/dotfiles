vim.pack.add({
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("nvim-highlight-colors").setup()
require("mini.icons").setup()
require("oil").setup()
require("ibl").setup()
