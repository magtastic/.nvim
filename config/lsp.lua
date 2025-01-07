local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({ automatic_installation = true })

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Lua
require("lspconfig").lua_ls.setup({
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

lsp_config.sourcekit.setup({
	on_attach = function(client)
		-- disable formatting. Handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
})

-- SQL
lsp_config.sqlls.setup({
	capabilities = capabilities,
	on_attach = function( --[[ client ]])
		-- disable formatting. Handled by null-ls
		-- client.server_capabilities.documentFormattingProvider = false
	end,
})

-- Python
lsp_config.pyright.setup({
	capabilities = capabilities,
	settings = {
		python = {
			pythonPath = vim.fn.exepath("python"),
		},
	},
	on_attach = function(client)
		-- disable formatting. Handled by null-ls
		client.server_capabilities.documentFormattingProvider = false
	end,
})

-- Tsserver
lsp_config.ts_ls.setup({
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
