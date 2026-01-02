local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({ automatic_installation = true })

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Lua
vim.lsp.config('lua_ls', {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable('lua_ls')

vim.lsp.config('sourcekit', {
	on_attach = function(client)
		-- disable formatting. Handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
})
vim.lsp.enable('sourcekit')

-- SQL
-- lsp_config.sqls.setup({
-- 	capabilities = capabilities,
-- 	settings = {
-- 		sqls = {
-- 			connections = {
-- 				{
-- 					driver = "postgresql",
-- 					dataSourceName = "host=127.0.0.1 port=2345 user=smitten password=smitten dbname=smitten sslmode=disable",
-- 				},
-- 			},
-- 		},
-- 	},
-- 	on_attach = function( --[[ client ]])
-- 		-- disable formatting. Handled by null-ls
-- 		-- client.server_capabilities.documentFormattingProvider = false
-- 	end,
-- })

-- Python
vim.lsp.config('pyright', {
	root_markers = { ".git", "pyproject.toml" },
	capabilities = capabilities,
	on_attach = function(client)
		-- disable formatting. Handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
})
vim.lsp.enable('pyright')

-- Tsserver
vim.lsp.config('ts_ls', {
	capabilities = capabilities,
	settings = {
		codeAction = {
			enable = false,
		},
	},
	filetypes = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"javascript",
	},
	debug = false,
	-- handlers = custom_ts_handler,
	on_attach = function(client)
		-- disable formatting. Handled by EFM
		client.server_capabilities.documentFormattingProvider = false
	end,
})
vim.lsp.enable('ts_ls')

vim.lsp.config('biome', {
	filetypes = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"javascript",
	},
})
vim.lsp.enable('biome')

vim.lsp.config('eslint', {
	on_attach = function(_client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
})
vim.lsp.enable('eslint')

vim.lsp.config('terraformls', {
	on_attach = function(client)
		-- disable formatting. Handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
})
vim.lsp.enable('terraformls')
