return {
  "Shatur/neovim-ayu",
  "kdheepak/lazygit.nvim",
  { "catppuccin/nvim", name = "catppuccin" },
  "ellisonleao/gruvbox.nvim",
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = false,
      hide_fillchars = false,
      borderless_telescope = true,
      terminal_colors = true,
    })
  end,
}
