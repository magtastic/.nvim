local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

require('go').setup({
    -- other setups
    lsp_cfg = {
        capabilities = capabilities
        -- other setups
    },
    lsp_on_attach = function( --[[ client ]] )
        local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function() require('go.format').goimport() end,
            group = format_sync_grp
        })
    end
})

-- Lua
lsp_config.lua_ls.setup({
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false
    end
})

-- SQL
lsp_config.sqlls.setup {
    capabilities = capabilities,
    on_attach = function( --[[ client ]] )
        -- disable formatting. Handled by null-ls
        -- client.server_capabilities.documentFormattingProvider = false
    end
}

-- Ruby
lsp_config.solargraph.setup {
    capabilities = capabilities,
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false
    end
}

-- Python
lsp_config.pyright.setup {
    capabilities = capabilities,
    settings = {
        settings = {
            python = {
                analysis = {
                    -- search subdirectories like src; defaults to true
                    autoSearchPaths = true,
                    -- make completion a lot faster, especially when large libaries are imported; auto-import suffers though generally good improvement as completion is not cached like as opposed to vscode defaults to true
                    useLibraryCodeForTypes = false
                }
            }
        }
    },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
    end
    -- on_new_config = function(config, root_dir)
    --     -- Check if poetry env is active. Add that as python path
    --     local env = vim.trim(vim.fn.system(
    --                              'cd "' .. root_dir ..
    --                                  '"; poetry env info -p 2>/dev/null'))
    --     if string.len(env) > 0 then
    --         config.settings.python.pythonPath = env .. '/bin/python'
    --     end
    -- end
}

-- Tsserver
lsp_config.tsserver.setup {
    capabilities = capabilities,
    settings = {},
    filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript"
    },
    debug = false,
    -- handlers = custom_ts_handler,
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false
    end
}
