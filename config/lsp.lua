local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

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
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false
    end
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
