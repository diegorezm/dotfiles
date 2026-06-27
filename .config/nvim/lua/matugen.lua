 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#18120f', -- Default Background
     base01 = '#241e1b', -- Lighter Background (status bars)
     base02 = '#2f2925', -- Selection Background
     base03 = '#9f8d84', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#d7c2b9', -- Dark Foreground (status bars)
     base05 = '#ece0db', -- Default Foreground
     base06 = '#ece0db', -- Light Foreground
     base07 = '#ece0db', -- Lightest Foreground
     -- Accent colors
     base08 = '#ffb4ab', -- Variables, XML Tags, Errors
     base09 = '#cec991', -- Integers, Constants
     base0A = '#e6beab', -- Classes, Search Background
     base0B = '#ffb68f', -- Strings, Diff Inserted
     base0C = '#cec991', -- Regex, Escape Chars
     base0D = '#ffb68f', -- Functions, Methods
     base0E = '#e6beab', -- Keywords, Storage
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
