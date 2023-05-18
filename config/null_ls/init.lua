local null_ls = require("null-ls")
local local_utils = require("config/utils")

local python = require("config/null_ls/python")
local javascript = require("config/null_ls/javascript")
local lua = require("config/null_ls/lua")
local rust = require("config/null_ls/rust")
local sql = require("config/null_ls/sql")

-- local move_style_code_action = require('config/null_ls/move_style_code_action')

require("refactoring").setup({})
local general_sources = {
    -- TODO: This is really coool but not working. fix plz
    -- null_ls.builtins.code_actions.refactoring
}

local sources = local_utils.table.combine({
    rust.sources,
    javascript.sources,
    lua.sources,
    -- python.sources,
    sql.sources,
    general_sources
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    debug = true,
    sources = sources,
    root_dir = require("null-ls.utils").root_pattern("package.json",
                                                     "pyproject.toml",
                                                     ".null-ls-root",
                                                     "Makefile", ".git"),
    on_attach = function(client, bufnr)
        local current_filetype = vim.bo[bufnr].filetype

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    if current_filetype == "python" then
                        python.format(bufnr)
                    else
                        vim.lsp.buf.format()
                    end
                end
            })
        end
    end
})

-- vim.api.nvim_set_keymap("v", "<leader>re",
--                         [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
--                         {noremap = true, silent = true, expr = false})
-- vim.api.nvim_set_keymap("v", "<leader>rf",
--                         [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
--                         {noremap = true, silent = true, expr = false})
-- null_ls.register(move_style_code_action)
