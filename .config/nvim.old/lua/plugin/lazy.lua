local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {

  --- theme
  { "catppuccin/nvim",            name = "catppuccin" },
  { "ellisonleao/gruvbox.nvim" },
  { 'Shatur/neovim-ayu' },
{ 'datsfilipe/min-theme.nvim' },
  { 'norcalli/nvim-colorizer.lua' },

  --git
  { "kdheepak/lazygit.nvim" },

  -- telescope
  {

    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    }
  },

  --cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    }
  },

  --completion
  {
    "williamboman/mason.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    }
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    }
  },
  -- nvim tree
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      pcall(vim.api.nvim_command, 'TSUpdate')
    end,
  },

  -- autopair
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },

  -- comment plugin
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  --markdown

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },


  -- plugin to auto () {} "" etc
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
      })
    end
  }
}


require("lazy").setup(plugins)
