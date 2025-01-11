local conform = require("conform")

conform.formatters.ruff_format = {
	prepend_args = function(self, ctx)
		local root_dir = require("conform.util").root_file(".git")(self, ctx)

		-- Check if in smitten project. use linter config there
		if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
			return { "--config", root_dir .. "/linters/ruff.toml" }
		end

		return {}
	end,
}

conform.formatters.ruff_fix = {
	prepend_args = function(self, ctx)
		local root_dir = require("conform.util").root_file(".git")(self, ctx)

		-- Check if in smitten project. use linter config there
		if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
			return { "--config", root_dir .. "/linters/ruff.toml" }
		end

		return {}
	end,
}

conform.formatters.ruff_organize_imports = {
	prepend_args = function(self, ctx)
		local root_dir = require("conform.util").root_file(".git")(self, ctx)

		-- Check if in smitten project. use linter config there
		if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
			return { "--config", root_dir .. "/linters/ruff.toml" }
		end

		return {}
	end,
}

conform.setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
	formatters_by_ft = {
		javascript = { "biome-check" },
		typescript = { "biome-check" },
		javascriptreact = { "biome-check" },
		typescriptreact = { "biome-check" },
		json = { "biome-check" },
		python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },
		lua = { "stylua" },
	},
})
