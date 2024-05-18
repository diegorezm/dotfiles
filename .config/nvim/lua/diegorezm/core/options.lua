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
g.mapleader = ' '
g.maplocalleader = ' '

o.swapfile = false

o.splitright = true -- split vertical window to the right
o.splitbelow = true -- split horizontal window to the bottom

o.termguicolors = true
o.background = "dark" -- colorschemes that can be light or dark will be made dark
o.signcolumn = "yes" -- show sign column so that text doesn't shift

o.backspace = "indent,eol,start"
o.clipboard = 'unnamedplus'
