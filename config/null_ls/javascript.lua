local null_ls = require('null-ls')
local local_utils = require('config/utils')

local some_exist_in_root = function(files)
    local current_working_dir = vim.fn.getcwd()

    for _, value in pairs(files) do
        local config_file = string.format("%s/%s", current_working_dir, value)
        local config_exists = local_utils.file_system.exists(config_file)

        if config_exists then return config_exists end
    end

    return false
end

local M = {}

local ESLINT_CONFIG_FILES = {
    ".eslintrc.json", ".eslintrc.js", ".eslintrc", ".eslintrc.toml"
}

local PRETTIER_CONFIG_FILES = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yml",
    "prettier.config.js", ".prettierrc.yaml", ".prettierrc.json5",
    ".prettierrc.cjs", "prettier.config.cjs", ".prettierrc.toml"
}

local ROME_CONFIG_FILES = {"rome.json"}

local js_sources = {
    require("typescript.extensions.null-ls.code-actions"),
    null_ls.builtins.formatting.prettier.with({
        runtime_condition = function()
            return some_exist_in_root(PRETTIER_CONFIG_FILES)
        end
    }), null_ls.builtins.diagnostics.eslint_d.with({
        diagnostics_format = "[#{c}] #{m} (#{s})",
        runtime_condition = function()
            return some_exist_in_root(ESLINT_CONFIG_FILES)
        end
    }), null_ls.builtins.code_actions.eslint_d.with({
        runtime_condition = function()
            return some_exist_in_root(ESLINT_CONFIG_FILES)
        end
    }), null_ls.builtins.formatting.rome.with({
        runtime_condition = function()
            return some_exist_in_root(ROME_CONFIG_FILES)
        end
    })
}

M.sources = js_sources

return M
