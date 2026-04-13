local M = {}

local fzf = require('fzf-lua')
local notes_dir = vim.env.NOTES_DIR or (vim.env.HOME .. '/notes')
local daily_dir = notes_dir .. '/daily'

-- Ensure base dirs exist
vim.fn.mkdir(notes_dir, 'p')
vim.fn.mkdir(daily_dir, 'p')

local function slugify(str)
	return str:lower():gsub('[^a-z0-9/]', '-'):gsub('%-+', '-'):gsub('^%-+', ''):gsub('%-+$', '')
end

local function template(title)
	return {
		'---',
		'date: ' .. os.date('%Y-%m-%d'),
		'tags: []',
		'---',
		'',
		'# ' .. title,
		'',
	}
end

-- Resolve a path like "work/ideas/my-note" into:
--   dir  = notes_dir/work/ideas
--   name = my-note
--   title = My note  (prettified from slug)
local function resolve(input)
	local slug = slugify(input)
	if slug == '' then return nil end

	local parts = {}
	for part in slug:gmatch('[^/]+') do
		table.insert(parts, part)
	end

	local name = table.remove(parts)
	local subpath = table.concat(parts, '/')
	local dir = subpath ~= '' and (notes_dir .. '/' .. subpath) or notes_dir
	local path = dir .. '/' .. name .. '.md'
	local title = name:gsub('-', ' '):gsub('^%l', string.upper)

	return { dir = dir, path = path, title = title }
end

-- Create a new note.
-- Prompt accepts plain names ("my note") or subpaths ("work/ideas/my note").
function M.new(prefill)
	vim.ui.input({ prompt = 'New Note: ', default = prefill or '' }, function(input)
		if not input or input == '' then return end

		local r = resolve(input)
		if not r then
			vim.notify('Could not resolve a filename from that input.', vim.log.levels.ERROR)
			return
		end

		vim.fn.mkdir(r.dir, 'p')

		if vim.fn.filereadable(r.path) == 1 then
			vim.notify('Note already exists, opening it.', vim.log.levels.INFO)
		else
			local ok = vim.fn.writefile(template(r.title), r.path)
			if ok ~= 0 then
				vim.notify('Failed to write note to ' .. r.path, vim.log.levels.ERROR)
				return
			end
		end

		vim.cmd('edit ' .. vim.fn.fnameescape(r.path))
		vim.cmd('normal! G')
	end)
end

-- Fuzzy find notes by filename (searches all subdirs)
function M.find()
	fzf.files({
		cwd = notes_dir,
		prompt = 'Notes> ',
	})
end

-- Live grep across all note content
function M.grep()
	fzf.live_grep({
		cwd = notes_dir,
		prompt = 'Notes grep> ',
	})
end

-- Filter notes by tag (reads from frontmatter)
function M.tag()
	vim.ui.input({ prompt = 'Tag: ' }, function(tag)
		if not tag or tag == '' then return end
		fzf.grep({
			search = 'tags:.*' .. tag,
			cwd = notes_dir,
			prompt = 'Notes [' .. tag .. ']> ',
			no_esc = true,
		})
	end)
end

-- Browse all tags found across notes and filter by selected one
function M.tags_browse()
	local results = vim.fn.systemlist(
		string.format("rg --no-filename -o 'tags:\\s*\\[.*\\]' %s", vim.fn.shellescape(notes_dir))
	)
	local tag_set = {}
	for _, line in ipairs(results) do
		for tag in line:gmatch('[%w_-]+') do
			if tag ~= 'tags' then
				tag_set[tag] = true
			end
		end
	end
	local tags = vim.tbl_keys(tag_set)
	table.sort(tags)
	if #tags == 0 then
		vim.notify('No tags found in ' .. notes_dir, vim.log.levels.WARN)
		return
	end
	fzf.fzf_exec(tags, {
		prompt = 'Tags> ',
		actions = {
			['default'] = function(selected)
				if selected and selected[1] then
					fzf.grep({
						search = 'tags:.*' .. selected[1],
						cwd = notes_dir,
						prompt = 'Notes [' .. selected[1] .. ']> ',
						no_esc = true,
					})
				end
			end,
		},
	})
end

-- Open today's daily note (lives in notes_dir/daily/YYYY-MM-DD.md)
function M.today()
	local date = os.date('%Y-%m-%d')
	local path = daily_dir .. '/' .. date .. '.md'
	if vim.fn.filereadable(path) == 0 then
		local ok = vim.fn.writefile(template(date), path)
		if ok ~= 0 then
			vim.notify('Failed to create daily note at ' .. path, vim.log.levels.ERROR)
			return
		end
	end
	vim.cmd('edit ' .. vim.fn.fnameescape(path))
	vim.cmd('normal! G')
end

-- Register all keymaps under <leader>n
function M.setup()
	local map = function(key, fn, desc)
		vim.keymap.set('n', '<leader>n' .. key, fn, { desc = 'Notes: ' .. desc })
	end

	map('n', M.new, 'new note')
	map('f', M.find, 'find by filename')
	map('g', M.grep, 'grep content')
	map('t', M.tag, 'filter by tag')
	map('T', M.tags_browse, 'browse all tags')
	map('d', M.today, "open today's daily note")
end

return M
