-- Neovim Theme: Ember
-- A dark theme generated from Xresources colors.

-- Disable background clear to allow terminal background to show,
-- or set to true if you want Neovim to control the background entirely.
vim.o.termguicolors = true
vim.cmd('highlight clear')
vim.cmd('syntax reset')

-- Define the colors from your Xresources file
local M = {}

M.colors = {
  -- Special
  foreground = '#a39a90',
  background = '#16130f',
  cursorColor = '#a39a90',

  -- Black
  color0 = '#16130f', -- Dark background
  color8 = '#5a5047', -- Bright black (dark grey)

  -- Red
  color1 = '#826d57', -- Dark red
  color9 = '#826d57', -- Bright red (same as dark red for consistency)

  -- Green
  color2 = '#57826d',  -- Dark green
  color10 = '#57826d', -- Bright green (same as dark green)

  -- Yellow
  color3 = '#6d8257',  -- Dark yellow
  color11 = '#6d8257', -- Bright yellow (same as dark yellow)

  -- Blue
  color4 = '#6d5782',  -- Dark blue
  color12 = '#6d5782', -- Bright blue (same as dark blue)

  -- Magenta
  color5 = '#82576d',  -- Dark magenta
  color13 = '#82576d', -- Bright magenta (same as dark magenta)

  -- Cyan
  color6 = '#576d82',  -- Dark cyan
  color14 = '#576d82', -- Bright cyan (same as dark cyan)

  -- White
  color7 = '#a39a90',  -- Light foreground
  color15 = '#dbd6d1', -- Bright white (lighter foreground/text)
}

-- Helper function to apply highlight groups
local function hi(group, fg, bg, style)
  local cmd = 'highlight ' .. group
  if fg then cmd = cmd .. ' guifg=' .. fg end
  if bg then cmd = cmd .. ' guibg=' .. bg end
  if style then cmd = cmd .. ' gui=' .. style end
  vim.cmd(cmd)
end

-- Set the base colors
hi('Normal', M.colors.foreground, M.colors.background)
hi('Cursor', M.colors.background, M.colors.cursorColor)       -- Cursor color is inverted for visibility
hi('CursorLine', nil, M.colors.color0, 'none')                -- Highlight the current line with a subtle background
hi('CursorLineNr', M.colors.color15, M.colors.color0, 'bold') -- Current line number
hi('LineNr', M.colors.color8, M.colors.background)            -- Line numbers

-- Visual mode
hi('Visual', nil, M.colors.color8, 'none') -- Selected text

-- Search highlights
hi('Search', M.colors.background, M.colors.color11, 'none')    -- Highlighted search results
hi('IncSearch', M.colors.background, M.colors.color10, 'bold') -- Incremental search

-- Status line and tab line
hi('StatusLine', M.colors.foreground, M.colors.color8, 'none')
hi('StatusLineNC', M.colors.color8, M.colors.color0, 'none')
hi('TabLine', M.colors.foreground, M.colors.color0, 'none')
hi('TabLineSel', M.colors.color15, M.colors.color4, 'bold')
hi('TabLineFill', M.colors.foreground, M.colors.color0, 'none')

-- UI elements
hi('Folded', M.colors.color8, M.colors.color0, 'italic')
hi('SignColumn', M.colors.color8, M.colors.background)
hi('NonText', M.colors.color8, nil)    -- Characters that don't belong to the text (e.g., '~' at end of buffer)
hi('SpecialKey', M.colors.color8, nil) -- Special characters (e.g., tabs, trailing spaces)
hi('Title', M.colors.color15, nil, 'bold')
hi('Directory', M.colors.color4, nil, 'bold')
hi('Underlined', M.colors.color6, nil, 'underline')
hi('Bold', nil, nil, 'bold')
hi('Italic', nil, nil, 'italic')

-- Messages
hi('ErrorMsg', M.colors.color1, M.colors.background, 'bold')
hi('WarningMsg', M.colors.color3, M.colors.background, 'bold')
hi('InfoMsg', M.colors.color6, M.colors.background, 'none')
hi('ModeMsg', M.colors.color2, M.colors.background, 'bold')
hi('Question', M.colors.color10, nil, 'bold')
hi('MoreMsg', M.colors.color10, nil, 'bold')

-- Syntax highlighting
hi('Comment', M.colors.color8, nil, 'italic') -- Comments
hi('String', M.colors.color2, nil)            -- String literals
hi('Character', M.colors.color2, nil)         -- Character literals
hi('Number', M.colors.color3, nil)            -- Numbers
hi('Boolean', M.colors.color3, nil)           -- Booleans
hi('Float', M.colors.color3, nil)             -- Floating point numbers

hi('Function', M.colors.color4, nil)          -- Function names
hi('Identifier', M.colors.color15, nil)       -- Variable names
hi('Statement', M.colors.color5, nil, 'bold') -- Control flow statements (if, for, while)
hi('Keyword', M.colors.color5, nil, 'bold')   -- Keywords (e.g., `local`, `function`)
hi('Type', M.colors.color6, nil)              -- Type definitions (e.g., `int`, `string`)
hi('Structure', M.colors.color6, nil)         -- Structs, classes
hi('Constant', M.colors.color3, nil)          -- Constants (e.g., `true`, `false`, `nil`)
hi('PreProc', M.colors.color10, nil)          -- Preprocessor directives (#include, #define)
hi('Define', M.colors.color10, nil)
hi('Macro', M.colors.color10, nil)
hi('Operator', M.colors.color15, nil)  -- Operators (+, -, *, /)
hi('Special', M.colors.color14, nil)   -- Special characters (e.g., escape sequences)
hi('Delimiter', M.colors.color15, nil) -- Delimiters (parentheses, brackets, braces)
hi('Conditional', M.colors.color5, nil, 'bold')
hi('Repeat', M.colors.color5, nil, 'bold')
hi('Exception', M.colors.color1, nil, 'bold')
hi('Label', M.colors.color14, nil)
hi('StorageClass', M.colors.color6, nil)

-- Diff highlighting
hi('DiffAdd', M.colors.color2, M.colors.color0, 'none')
hi('DiffChange', M.colors.color3, M.colors.color0, 'none')
hi('DiffDelete', M.colors.color1, M.colors.color0, 'none')
hi('DiffText', M.colors.color4, M.colors.color0, 'bold')

-- Popup menu
hi('Pmenu', M.colors.foreground, M.colors.color0, 'none')
hi('PmenuSel', M.colors.background, M.colors.color4, 'none')
hi('PmenuSbar', nil, M.colors.color8, 'none')
hi('PmenuThumb', M.colors.color15, M.colors.color15, 'none')

-- Spelling errors
hi('SpellBad', M.colors.color1, nil, 'undercurl')
hi('SpellCap', M.colors.color4, nil, 'undercurl')
hi('SpellRare', M.colors.color5, nil, 'undercurl')
hi('SpellLocal', M.colors.color6, nil, 'undercurl')

-- MatchParen (matching parentheses)
hi('MatchParen', M.colors.background, M.colors.color14, 'bold')
