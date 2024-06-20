return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")

		local mason_lspconfig = require("mason-lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				opts.desc = "go to definition"
				keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)

				opts.desc = "hover function"
				keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)

				opts.desc = "workspace symbol"
				keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)

				opts.desc = "open float"
				keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)

				opts.desc = "go to next diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)

				opts.desc = "go to prev diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)

				opts.desc = "code action"
				keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)

				opts.desc = "references"
				keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, opts)

				opts.desc = "rename"
				keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)

				opts.desc = "format"
				keymap.set("n", "<leader>p", function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, opts)

				opts.desc = "signature help"
				keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["svelte"] = function()
				lspconfig["svelte"].setup({
					capabilities = capabilities,
					on_attach = function(client, _)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								-- Here use ctx.match instead of ctx.file
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
