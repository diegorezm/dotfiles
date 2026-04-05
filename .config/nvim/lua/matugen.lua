local M = {}

function M.setup()
	require('base16-colorscheme').setup {
		-- Background tones
		base00 = '#181211',     -- Default Background
		base01 = '#251e1d', -- Lighter Background (status bars)
		base02 = '#2f2827', -- Selection Background
		base03 = '#a08c88',     -- Comments, Invisibles
		-- Foreground tones
		base04 = '#d8c2bd', -- Dark Foreground (status bars)
		base05 = '#ede0dd',  -- Default Foreground
		base06 = '#ede0dd',  -- Light Foreground
		base07 = '#ede0dd', -- Lightest Foreground
		-- Accent colors
		base08 = '#ffb4ab',       -- Variables, XML Tags, Errors
		base09 = '#dac58c',    -- Integers, Constants
		base0A = '#e7bdb3',   -- Classes, Search Background
		base0B = '#ffb4a2',     -- Strings, Diff Inserted
		base0C = '#dac58c', -- Regex, Escape Chars
		base0D = '#ffb4a2', -- Functions, Methods
		base0E = '#e7bdb3', -- Keywords, Storage
		base0F = '#93000a', -- Deprecated, Embedded Tags
	}
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
	'sigusr1',
	vim.schedule_wrap(function()
		package.loaded['matugen'] = nil
		require('matugen').setup()
	end)
)

return M
