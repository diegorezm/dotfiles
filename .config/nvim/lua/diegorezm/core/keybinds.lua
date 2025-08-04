local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

local opts = { silent = true, noremap = true }

-- copy and paste
map({ "n", "v" }, "<C-c>", [["+y]])
map("n", "<C-c>", [["+Y]])

-- vertical split
map("n", "<C-w>l", "<C-l>", opts)
map("n", "<C-w>k", "<C-k>", opts)
map("n", "<C-w>j", "<C-j>", opts)
map("n", "<C-w>h", "<C-h>", opts)

-- map split
map("n", "<leader>vs", ":vs<CR>")

-- tab nav
map("n", "<leader>h", ":tabr<CR>")
map("n", "<leader>l", ":tabl<CR>")
map("n", "<C-n>", ":tabn<CR>")

vim.api.nvim_set_keymap(
  "n",
  "<leader>o",
  ":!opener " .. vim.fn.expand("%") .. "<CR>",
  { noremap = true, silent = true }
)

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-q>", ":q!<CR>")
