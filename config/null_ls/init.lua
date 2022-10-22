local null_ls = require('null-ls')
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local python = require('config/null_ls/python_config')
-- local move_style_code_action = require('config/null_ls/move_style_code_action')

local sources = {
    null_ls.builtins.formatting.prettier, null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.formatting.black.with({
        extra_args = {"--fast --config ./linters/pyproject.toml"}
    }), null_ls.builtins.formatting.isort.with({
        extra_args = {"--settings-path ./linters/pyproject.toml"}
    }), null_ls.builtins.formatting.lua_format,
    null_ls.builtins.code_actions.eslint_d
}

null_ls.setup({
    debug = true,
    sources = sources,
    on_attach = function(client, bufnr)
        local current_filetype = vim.bo[bufnr].filetype

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    if current_filetype == 'python' then
                        python.format(bufnr)
                    else
                        vim.lsp.buf.formatting_sync()
                    end
                end
            })
        end
    end
})

-- null_ls.register(move_style_code_action)
