local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("lspconfig")

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())
-- Lua
lsp_config.sumneko_lua.setup({
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false
    end,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
})

-- SQL
lsp_config.sqlls.setup {
    capabilities = capabilities,
    on_attach = function(client)
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
        "typescript", "typescriptreact", "typescript.tsx", "javascript"
    },
    debug = false,
    -- handlers = custom_ts_handler,
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.server_capabilities.documentFormattingProvider = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup {
            debug = true,
            disable_commands = false,
            enable_import_on_completion = false,
            -- import all
            import_all_timeout = 5000, -- ms
            import_all_priorities = {
                buffers = 4, -- loaded buffer names
                buffer_content = 3, -- loaded buffer content
                local_files = 2, -- git files or files with relative path markers
                same_file = 1 -- add to existing import statement
            },
            import_all_scan_buffers = 100,
            import_all_select_source = false,

            -- ESlint is disabled. We use null ls server for that.
            eslint_enable_diagnostics = false,
            eslint_enable_code_actions = false,

            -- update imports on file move
            update_imports_on_move = true,
            require_confirmation_on_move = false,
            watch_dir = nil,
            -- filter diagnostics
            filter_out_diagnostics_by_severity = {},
            filter_out_diagnostics_by_code = {}
        }

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)
    end
}
