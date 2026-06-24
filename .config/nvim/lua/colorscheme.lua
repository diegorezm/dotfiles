-- vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
-- vim.cmd.colorscheme('vague')
-- vim.pack.add({'https://github.com/ramojus/mellifluous.nvim'})
-- require("mellifluous").setup({
--     mellifluous = {
--         neutral = false,
--     },
-- })
-- vim.cmd.colorscheme('mellifluous')


vim.pack.add({ 'https://github.com/tahayvr/matteblack.nvim' })
vim.cmd.colorscheme "matteblack"


-- Transparent bg
vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none"})
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none"})
