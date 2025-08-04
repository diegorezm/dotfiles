vim.cmd("let g:netrw_liststyle = 3")
local g = vim.g
local o = vim.o

o.relativenumber = true
o.number = true

-- tabs & indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true
o.wrap = false

-- search settings
o.ignorecase = true
o.smartcase = true

o.cursorline = true

-- leader to space
g.mapleader = " "
g.maplocalleader = " "

o.swapfile = false

o.splitright = true -- split vertical window to the right
o.splitbelow = true -- split horizontal window to the bottom

o.termguicolors = true
o.background = "dark" -- colorschemes that can be light or dark will be made dark
o.signcolumn = "yes"  -- show sign column so that text doesn't shift

o.backspace = "indent,eol,start"
o.clipboard = "unnamedplus"

if vim.fn.executable('win32yank.exe') == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
  vim.notify('win32yank clipboard provider loaded.', vim.log.levels.INFO, { title = 'Neovim Clipboard' })
end

vim.filetype.add({
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
})
