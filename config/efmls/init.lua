local lsp_config = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Got an LSP for this, Biome formatting emojis incorrectly for some reason
local biome = require("efmls-configs.formatters.biome")
local eslint_d = require("efmls-configs.linters.eslint_d")
-- local eslint_d_formatter = require("efmls-configs.formatters.eslint_d")

local languages = require("efmls-configs.defaults").languages()

languages = vim.tbl_extend("force", languages, {
	-- Custom languages, or override existing ones
	typescript = {
		biome,
		eslint_d,
		-- eslint_d_formatter,
	},
	javascript = {
		biome,
		eslint_d,
		-- eslint_d_formatter,
	},
	typescriptreact = {
		biome,
		eslint_d,
		-- eslint_d_formatter,
	},
	javascriptreact = {
		biome,
		eslint_d,
		-- eslint_d_formatter,
	},
})

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { ".git/" },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
	},
}

lsp_config.efm.setup(vim.tbl_extend("force", efmls_config, {
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = true
	end,
	capabilities = capabilities,
}))

-- Format On Save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = lsp_fmt_group,
	callback = function()
		local efm = vim.lsp.get_active_clients({ name = "efm" })

		if vim.tbl_isempty(efm) then
			return
		end

		vim.lsp.buf.format({ name = "efm" })
	end,
})
