-- return {
-- 	"mhartington/formatter.nvim",
-- 	config = function()
-- 		local util = require("formatter.util")
--
-- 		require("formatter").setup({
-- 			logging = true,
-- 			log_level = vim.log.levels.WARN,
-- 			async = true,
-- 			filetype = {
-- 				-- TypeScript, JavaScript, TypeScriptReact
-- 				typescript = { require("formatter.filetypes.typescript").prettier },
-- 				javascript = { require("formatter.filetypes.javascript").prettier },
-- 				typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
-- 				javascriptreact = { require("formatter.filetypes.typescriptreact").prettier },
-- 				astro = { require("formatter.filetypes.astro").prettier },
-- 				css = { require("formatter.filetypes.css").prettier },
-- 				xml = { require("formatter.filetypes.xml").xmlformat },
-- 				java = { require("formatter.filetypes.java").google_java_format },
-- 				go = {
-- 					function()
-- 						return {
-- 							exe = "gofumpt",
-- 							args = { "-w", util.escape_path(util.get_current_buffer_file_path()) },
-- 							stdin = false,
-- 						}
-- 					end,
-- 				},
-- 				rust = {
-- 					function()
-- 						return {
-- 							exe = "rustfmt",
-- 							args = { "--emit=stdout", "--edition", "2021" },
-- 							stdin = true,
-- 						}
-- 					end,
-- 				},
-- 				php = { require("formatter.filetypes.php").php_cs_fixer },
-- 				lua = {
-- 					require("formatter.filetypes.lua").stylua,
-- 					function()
-- 						if util.get_current_buffer_file_name() == "special.lua" then
-- 							return nil
-- 						end
-- 						return {
-- 							exe = "stylua",
-- 							args = {
-- 								"--search-parent-directories",
-- 								"--stdin-filepath",
-- 								util.escape_path(util.get_current_buffer_file_path()),
-- 								"--",
-- 								"-",
-- 							},
-- 							stdin = true,
-- 						}
-- 					end,
-- 				},
-- 				-- ["*"] = {
-- 				-- 	require("formatter.filetypes.any").remove_trailing_whitespace,
-- 				-- },
-- 			},
-- 		})
--
-- 		local augroup = vim.api.nvim_create_augroup
-- 		local autocmd = vim.api.nvim_create_autocmd
-- 		augroup("__formatter__", { clear = true })
-- 		autocmd("BufWritePost", {
-- 			group = "__formatter__",
-- 			command = ":FormatWrite",
-- 		})
-- 	end,
-- }
return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				typescript = { "prettier", "prettierd" },
				javascript = { "prettier", "prettierd" },
				typescriptreact = { "prettier", "prettierd" },
				javascriptreact = { "prettier", "prettierd" },
				astro = { "prettier" },
				css = { "prettierd", "prettier" },
				xml = { "xmlformat" },
				java = { "google-java-format" },
				go = { "gofumpt" },
				rust = { "rustfmt" },
				php = { "php_cs_fixer" },
				lua = { "stylua" },
				-- python = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
		})
	end,
}
