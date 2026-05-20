-- vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
-- vim.cmd.colorscheme('vague')
vim.pack.add({'https://github.com/ramojus/mellifluous.nvim'})
require("mellifluous").setup({
    mellifluous = {
        neutral = false, 
    },
})
vim.cmd.colorscheme('mellifluous')
