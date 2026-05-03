local fzf      = require('fzf-lua')

local NOTES    = vim.fn.expand("~/docs/notes")
local ZETTEL   = NOTES .. "/notes"
local INBOX    = NOTES .. "/inbox"
local PROJECTS = NOTES .. "/projects"
local DAILY    = NOTES .. "/daily"

-- ── Helpers ────────────────────────────────

local function make_frontmatter(title, extra_tags)
	local tags = extra_tags or {}
	local tag_str = "["
	for i, t in ipairs(tags) do
		tag_str = tag_str .. t .. (i < #tags and ", " or "")
	end
	tag_str = tag_str .. "]"
	return {
		"---",
		'title: "' .. title .. '"',
		"date: " .. os.date("%Y-%m-%d"),
		"id: " .. os.date("%Y%m%d%H%M"),
		"tags: " .. tag_str,
		"---",
		"",
		""
	}
end

local function slug(name)
	return name:gsub("%s+", "-"):lower()
end

local function timestamp()
	return os.date("%Y%m%d%H%M")
end

-- ── Note Creators ──────────────────────────

local function daily_note()
	local today = os.date("%Y-%m-%d")
	local filename = DAILY .. "/" .. today .. ".md"
	vim.cmd("edit " .. filename)
	if vim.fn.filereadable(filename) == 0 then
		local lines = make_frontmatter(today, { "daily" })
		vim.list_extend(lines, {
			"## " .. os.date("%A, %B %d"),
			"",
			"### Tasks",
			"- [ ] ",
			"",
			"### Notes",
			"",
		})
		vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
	end
end

local function new_note()
	local kinds = { "permanent", "inbox", "daily", "project" }

	fzf.fzf_exec(kinds, {
		prompt = "Note type> ",
		actions = {
			["default"] = function(selected)
				if not selected or #selected == 0 then return end
				local kind = selected[1]

				-- Daily: no title prompt needed
				if kind == "daily" then
					daily_note()
					return
				end

				-- Project: pick project first, then title
				if kind == "project" then
					local projects = vim.fn.glob(PROJECTS .. "/*/", false, true)
					if #projects == 0 then
						vim.notify("No projects found. Create one with <leader>np first.",
							vim.log.levels.WARN)
						return
					end

					local names = {}
					local name_to_path = {}
					for _, p in ipairs(projects) do
						local name = p:match(".+/(.+)/$")
						table.insert(names, name)
						name_to_path[name] = p
					end

					vim.schedule(function()
						fzf.fzf_exec(names, {
							prompt = "Project> ",
							actions = {
								["default"] = function(sel)
									if not sel or #sel == 0 then return end
									local project_dir = name_to_path[sel[1]]
									local title = vim.fn.input("Note title: ")
									if title == "" then return end
									local filename = timestamp() ..
									    "-" .. slug(title) .. ".md"
									vim.cmd("edit " .. project_dir .. filename)
									vim.api.nvim_buf_set_lines(0, 0, 0, false,
										make_frontmatter(title,
											{ "project/" .. sel[1] }))
									vim.cmd("normal! G")
								end,
							},
						})
					end)
					return
				end

				-- Permanent and inbox: just need a title
				local title = vim.fn.input("Note title: ")
				if title == "" then return end
				local filename = timestamp() .. "-" .. slug(title) .. ".md"
				local dir = kind == "permanent" and ZETTEL or INBOX
				local tags = kind == "inbox" and { "inbox" } or {}
				vim.cmd("edit " .. dir .. "/" .. filename)
				vim.api.nvim_buf_set_lines(0, 0, 0, false, make_frontmatter(title, tags))
				vim.cmd("normal! G")
			end,
		},
	})
end

local function new_project()
	local name = vim.fn.input("Project name: ")
	if name == "" then return end
	local dir = PROJECTS .. "/" .. slug(name)
	vim.fn.mkdir(dir, "p")
	local index = dir .. "/_index.md"
	vim.cmd("edit " .. index)
	if vim.fn.filereadable(index) == 0 then
		local lines = make_frontmatter(name, { "project" })
		vim.list_extend(lines, {
			"## Overview",
			"",
			"## Index",
			"",
			"## Progress",
			"",
		})
		vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
	end
end

-- ── Keybindings ────────────────────────────

local o = { noremap = true, silent = true }
local function desc(d) return vim.tbl_extend("force", o, { desc = d }) end

-- Create
vim.keymap.set("n", "<leader>nn", new_note, desc("New note"))
vim.keymap.set("n", "<leader>nd", daily_note, desc("Open today's daily note"))
vim.keymap.set("n", "<leader>np", new_project, desc("New / open project"))

-- Search
vim.keymap.set("n", "<leader>nf", function()
	fzf.live_grep({ cwd = NOTES, prompt = "Search Notes> " })
end, desc("Full-text search all notes"))

vim.keymap.set("n", "<leader>nt", function()
	fzf.grep({
		cwd = NOTES,
		search = "",
		rg_opts = "--no-heading -g '*.md' --multiline",
		prompt = "Tags> ",
		query = "tags:",
	})
end, desc("Search by tag"))

vim.keymap.set("n", "<leader>no", function()
	fzf.files({ cwd = ZETTEL, prompt = "Open Note> " })
end, desc("Open permanent note"))

vim.keymap.set("n", "<leader>nP", function()
	fzf.files({ cwd = PROJECTS, prompt = "Projects> " })
end, desc("Browse projects"))

-- LSP (Marksman)
vim.keymap.set("n", "<leader>nb", fzf.lsp_references, desc("Backlinks to current note"))
vim.keymap.set("n", "<leader>nl", fzf.lsp_document_symbols, desc("Links in current note"))
vim.keymap.set("n", "<leader>nm", "<cmd>Markview Toggle<CR>", { desc = "Toggle markdown preview" })
