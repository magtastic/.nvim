local lsp_config = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local biome = require("efmls-configs.formatters.biome")
local languages = require("efmls-configs.defaults").languages()
languages = vim.tbl_extend("force", languages, {
	-- Custom languages, or override existing ones
	typescript = {
		biome,
	},
	javascript = {
		biome,
	},
	typescriptreact = {
		biome,
	},
	javascriptreact = {
		biome,
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
