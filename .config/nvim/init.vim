"       vim-plug
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

"	general conf 
set splitbelow splitright 
set nowrap 
set undodir=~/.config/nvim/undo
set mouse=a
set noswapfile 
set confirm
set autoindent
set smartindent 
set nocindent
set smartcase
set autoread 
set inccommand=split
filetype plugin indent on
set wildmenu
set smarttab 
set expandtab
set notermguicolors
syntax on
set nu!
set relativenumber
set laststatus=2
set cursorline
set encoding=UTF-8
set complete+=kspell
set completeopt=menuone
set path+=**
set colorcolumn=100

"	plugin
call plug#begin('~/.config/nvim/plugged')
"       Goyo        
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
"       themes
Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'altercation/vim-colors-solarized'
        "       code
Plug 'maralla/completor.vim'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'lilydjwg/colorizer'
Plug 'tpope/vim-commentary'
Plug 'voldikss/vim-floaterm'
call plug#end()

"	colors
colorscheme gruvbox
set background=dark
let base16colorspace=256
"	keys
let mapleader="\<space>"

"       copy and paste
vnoremap <C-c> "+y
vnoremap <C-p> "+p

"       vertical split
noremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <leader>p :setlocal spell spelllang=pt_br \| let g:completor_auto_trigger = 0 <CR>
map <leader>pd :set nospell \| let g:completor_auto_trigger = 1 <CR>
" map <leader>s :FloatermToggle<CR>
let g:floaterm_keymap_toggle = '<space>s'
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1
map <leader>b :Vexplore<CR>
map <F5> :w! \| !compiler <c-r>%<CR>
map <leader>vs :vs 
map <leader>f :FZF<CR>
map <leader>g :Goyo<CR>
map <leader>cc :Comment<CR>
map <C-s> :w<CR>

"       Source
source  ~/.config/nvim/config/plugin.vim
source  ~/.config/nvim/config/statusline.vim 
