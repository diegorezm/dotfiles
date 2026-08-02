 local M = {}

 function M.setup()
   require('base16-colorscheme').setup {
     -- Background tones
     base00 = '#1c110e', -- Default Background
     base01 = '#291d1a', -- Lighter Background (status bars)
     base02 = '#352622', -- Selection Background
     base03 = '#795b52', -- Comments, Invisibles
     -- Foreground tones
     base04 = '#dfc0b8', -- Dark Foreground (status bars)
     base05 = '#f4ded9', -- Default Foreground
     base06 = '#f4ded9', -- Light Foreground
     base07 = '#f4ded9', -- Lightest Foreground
     -- Accent colors
     base08 = '#ffb4ab', -- Variables, XML Tags, Errors
     base09 = '#e9c258', -- Integers, Constants
     base0A = '#ffb4a3', -- Classes, Search Background
     base0B = '#ffb4a3', -- Strings, Diff Inserted
     base0C = '#f0d68e', -- Regex, Escape Chars
     base0D = '#ff9780', -- Functions, Methods
     base0E = '#ff9780', -- Keywords, Storage
     base0F = '#f71b00', -- Deprecated, Embedded Tags
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
