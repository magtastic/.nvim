local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())

-- Lua
lsp_config.sumneko_lua.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {globals = {"vim", "use"}},
            workspace = {preloadFileSize = 500}
        }
    },
    on_attach = function(client)
        -- disable formatting. Handled by null-ls
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
}

-- Ruby
lsp_config.solargraph.setup {capabilities = capabilities}

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
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end,
    on_new_config = function(config, root_dir)
        -- Check if poetry env is active. Add that as python path
        local env = vim.trim(vim.fn.system(
                                 'cd "' .. root_dir ..
                                     '"; poetry env info -p 2>/dev/null'))
        if string.len(env) > 0 then
            config.settings.python.pythonPath = env .. '/bin/python'
        end
    end
}

-- WIP to remove the react.d.ts files hehe.
-- local custom_ts_handler = {
--     ["textDocument/definition"] = function(_, result, ctx, config)
--         if result == nil or vim.tbl_isempty(result) then return nil end
--
--         local client = vim.lsp.get_client_by_id(ctx.client_id)
--
--         config = config or {}
--
--         local util = require("vim.lsp.util")
--
--         if vim.tbl_islist(result) then
--             local has_jumped = false
--
--             if #result > 1 then
--                 local result_without_react_types = {}
--                 for _, value in pairs(result) do
--                     if string.match(value.targetUri, "react/index.d.ts") then
--                         break
--                     else
--                         result_without_react_types[#result_without_react_types +
--                             1] = value
--                         if not has_jumped then
--                             has_jumped = true
--                             util.jump_to_location(value, client.offset_encoding,
--                                                   config.reuse_win)
--                         end
--                     end
--                 end
--
--                 if #result_without_react_types > 1 then
--                     util.set_qflist(util.locations_to_items(
--                                         result_without_react_types))
--                     vim.api.nvim_command("copen")
--                     vim.api.nvim_command("wincmd p")
--                 end
--
--             end
--         else
--             util.jump_to_location(result, client.offset_encoding,
--                                   config.reuse_win)
--         end
--     end
-- }

-- Tsserver
lsp_config.tsserver.setup {
    capabilities = capabilities,
    settings = {},
    filetypes = {
        "typescript", "typescriptreact", "typescript.tsx", "javascript"
    },
    debug = false,
    -- handlers = custom_ts_handler,
    on_attach = function(client, _)
        -- disable formatting. Handled by null-ls
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

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

            -- ESlint is disabled. We use efm server for that.
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
