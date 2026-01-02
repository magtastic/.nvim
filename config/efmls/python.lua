local null_ls = require("null-ls")

local M = {}

M.format = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		vim.lsp.util.make_formatting_params({}),
		function(err, res, ctx)
			if err then
				local err_msg = type(err) == "string" and err or err.message
				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN, { title = "Async Formatter" })
				return
			end

			if vim.api.nvim_buf_get_option(bufnr, "modified") then
				vim.notify(
					"⚠️  Buffer change detected. No formatting applied.",
					vim.log.levels.WARN,
					{ title = "Async Formatter" }
				)
				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) then
				return
			end

			if res then
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

local KNOWN_API_ROOTS = { "api/server", "api/scripts/python" }

local get_linter_path_from_root = function(root)
	for _key, value in pairs(KNOWN_API_ROOTS) do
		if root:endswith(value) then
			return root:replace(value, "api/linters")
		end
	end
	return nil
end

M.sources = {
	null_ls.builtins.formatting.ruff.with({
		prefer_local = ".venv/bin",
		extra_args = function(params)
			local config_file_path = {}
			-- If we are in the server repo for smitten, use linters config
			if
				params.root:endswith("api/server")
				or params.root:endswith("api/shared")
				or params.root:endswith("api/ops")
			then
				config_file_path = {
					"--config",
					params.root:replace("api/server", "api/linters/ruff.toml"),
				}
			end
			return (params.options or {}) and config_file_path
		end,
	}),
	null_ls.builtins.formatting.black.with({
		prefer_local = ".venv/bin",
		extra_args = function(params)
			local config_file_path = {}
			local correct_path = get_linter_path_from_root(params.root)

			-- If we are in the server repo for smitten, use linters config
			if correct_path then
				config_file_path = {
					"--config",
					correct_path .. "/pyproject.toml",
				}
			end
			return params.options and { "--fast" } and config_file_path
		end,
	}),
	null_ls.builtins.diagnostics.ruff.with({
		prefer_local = ".venv/bin",
		extra_args = function(params)
			local config_file_path = {}
			local correct_path = get_linter_path_from_root(params.root)
			-- If we are in the server repo for smitten, use linters config
			if correct_path then
				config_file_path = { "--config", correct_path .. "/ruff.toml" }
			end
			return (params.options or {}) and config_file_path
		end,
	}),
}

return M
