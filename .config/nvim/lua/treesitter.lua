vim.pack.add({
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
    },
    { src = "https://github.com/windwp/nvim-ts-autotag", },
    { src = "https://github.com/windwp/nvim-autopairs" },
})

require('nvim-ts-autotag').setup({})

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

local npairs = require('nvim-autopairs')
npairs.setup({ map_cr = true })
