local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

require("go").setup({
    -- other setups
    lsp_cfg = {
        capabilities = capabilities
        -- other setups
    },
    lsp_on_attach = function( --[[ client ]] )
        local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function() require("go.format").goimport() end,
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
lsp_config.pyright.setup {capabilities = capabilities}

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
