-- Neovim Theme: Ember Light
-- A light theme generated from updated Xresources colors.

vim.o.termguicolors = true
vim.cmd('highlight clear')
vim.cmd('syntax reset')

local M = {}

M.colors = {
  -- Special from Xresources
  foreground = '#433b32',
  background = '#dbd6d1',
  cursorColor = '#433b32',

  -- Black from Xresources
  color0 = '#16130f',   -- This is the darkest color available in your palette
  color8 = '#5a5047',

  -- Red from Xresources
  color1 = '#826d57',
  color9 = '#826d57',

  -- Green from Xresources
  color2 = '#57826d',
  color10 = '#57826d',

  -- Yellow from Xresources
  color3 = '#6d8257',
  color11 = '#6d8257',

  -- Blue from Xresources
  color4 = '#6d5782',
  color12 = '#6d5782',

  -- Magenta from Xresources
  color5 = '#82576d',
  color13 = '#82576d',

  -- Cyan from Xresources
  color6 = '#576d82',
  color14 = '#576d82',

  -- White from Xresources
  color7 = '#a39a90',
  color15 = '#dbd6d1',

  -- Additional defined colors
  bg_defined = '#dbd6d1',
  fg_defined = '#16130f',   -- CHANGED: Making the default foreground the darkest color (#16130f)
  primary_defined = '#6d5782',
  secondary_defined = '#82576d',
  subtext_defined = '#a39a90',
}

-- Helper function to apply highlight groups
local function hi(group, fg, bg, style)
  local cmd = 'highlight ' .. group
  if fg then cmd = cmd .. ' guifg=' .. fg end
  if bg then cmd = cmd .. ' guibg=' .. bg end
  if style then cmd = cmd .. ' gui=' .. style end
  vim.cmd(cmd)
end

-- Set the base colors using the new definitions
hi('Normal', M.colors.fg_defined, M.colors.bg_defined)            -- Normal text (including most variables) will now be the darkest
hi('Cursor', M.colors.bg_defined, M.colors.cursorColor)           -- Cursor color is inverted for visibility
hi('CursorLine', nil, M.colors.color15, 'none')                   -- Using color15 (white) as a subtle line highlight
hi('CursorLineNr', M.colors.fg_defined, M.colors.color15, 'bold') -- Current line number
hi('LineNr', M.colors.subtext_defined, M.colors.bg_defined)       -- Line numbers

-- Visual mode
hi('Visual', nil, M.colors.color7, 'none') -- Selected text, using a lighter neutral color

-- Search highlights
hi('Search', M.colors.bg_defined, M.colors.color11, 'none')    -- Highlighted search results (yellow)
hi('IncSearch', M.colors.bg_defined, M.colors.color10, 'bold') -- Incremental search (green)

-- Status line and tab line
hi('StatusLine', M.colors.fg_defined, M.colors.color7, 'none')          -- Foreground, subtle background
hi('StatusLineNC', M.colors.subtext_defined, M.colors.color15, 'none')  -- Inactive status line
hi('TabLine', M.colors.fg_defined, M.colors.color15, 'none')
hi('TabLineSel', M.colors.primary_defined, M.colors.bg_defined, 'bold') -- Selected tab
hi('TabLineFill', M.colors.fg_defined, M.colors.color15, 'none')

-- UI elements
hi('Folded', M.colors.subtext_defined, M.colors.color15, 'italic')
hi('SignColumn', M.colors.subtext_defined, M.colors.bg_defined)
hi('NonText', M.colors.subtext_defined, nil)
hi('SpecialKey', M.colors.subtext_defined, nil)
hi('Title', M.colors.primary_defined, nil, 'bold')
hi('Directory', M.colors.primary_defined, nil, 'bold')
hi('Underlined', M.colors.color6, nil, 'underline')
hi('Bold', nil, nil, 'bold')
hi('Italic', nil, nil, 'italic')

-- Messages
hi('ErrorMsg', M.colors.color1, M.colors.bg_defined, 'bold')
hi('WarningMsg', M.colors.color3, M.colors.bg_defined, 'bold')
hi('InfoMsg', M.colors.color6, M.colors.bg_defined, 'none')
hi('ModeMsg', M.colors.color2, M.colors.bg_defined, 'bold')
hi('Question', M.colors.color10, nil, 'bold')
hi('MoreMsg', M.colors.color10, nil, 'bold')

-- Syntax highlighting
hi('Comment', M.colors.subtext_defined, nil, 'italic')   -- Comments
hi('String', M.colors.color2, nil)                       -- String literals (green)
hi('Character', M.colors.color2, nil)                    -- Character literals (green)
hi('Number', M.colors.color3, nil)                       -- Numbers (yellow)
hi('Boolean', M.colors.color3, nil)                      -- Booleans (yellow)
hi('Float', M.colors.color3, nil)                        -- Floating point numbers (yellow)

hi('Function', M.colors.primary_defined, nil)            -- Function names (primary blue)
hi('Identifier', M.colors.fg_defined, nil)               -- Variable names (now explicitly set to the darkest fg_defined)
hi('Statement', M.colors.secondary_defined, nil, 'bold') -- Control flow statements (magenta)
hi('Keyword', M.colors.secondary_defined, nil, 'bold')   -- Keywords (magenta)
hi('Type', M.colors.color6, nil)                         -- Type definitions (cyan)
hi('Structure', M.colors.color6, nil)                    -- Structs, classes (cyan)
hi('Constant', M.colors.color3, nil)                     -- Constants (yellow)
hi('PreProc', M.colors.color10, nil)                     -- Preprocessor directives (bright green)
hi('Define', M.colors.color10, nil)
hi('Macro', M.colors.color10, nil)
hi('Operator', M.colors.fg_defined, nil)  -- Operators
hi('Special', M.colors.color14, nil)      -- Special characters (bright cyan)
hi('Delimiter', M.colors.fg_defined, nil) -- Delimiters
hi('Conditional', M.colors.secondary_defined, nil, 'bold')
hi('Repeat', M.colors.secondary_defined, nil, 'bold')
hi('Exception', M.colors.color1, nil, 'bold') -- Red
hi('Label', M.colors.color14, nil)
hi('StorageClass', M.colors.color6, nil)

-- Diff highlighting
hi('DiffAdd', M.colors.color2, M.colors.color15, 'none')
hi('DiffChange', M.colors.color3, M.colors.color15, 'none')
hi('DiffDelete', M.colors.color1, M.colors.color15, 'none')
hi('DiffText', M.colors.primary_defined, M.colors.color15, 'bold')

-- Popup menu
hi('Pmenu', M.colors.fg_defined, M.colors.color15, 'none')
hi('PmenuSel', M.colors.bg_defined, M.colors.primary_defined, 'none')
hi('PmenuSbar', nil, M.colors.color7, 'none')
hi('PmenuThumb', M.colors.fg_defined, M.colors.fg_defined, 'none')

-- Spelling errors
hi('SpellBad', M.colors.color1, nil, 'undercurl')
hi('SpellCap', M.colors.primary_defined, nil, 'undercurl')
hi('SpellRare', M.colors.secondary_defined, nil, 'undercurl')
hi('SpellLocal', M.colors.color6, nil, 'undercurl')

-- MatchParen (matching parentheses)
hi('MatchParen', M.colors.bg_defined, M.colors.color14, 'bold')
