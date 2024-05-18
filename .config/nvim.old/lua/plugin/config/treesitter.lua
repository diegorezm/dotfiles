require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "html", "css", "bash", "javascript" },
  sync_install = true,
  auto_install = true,
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
