local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({automatic_installation = true})

local on_attach = function(_, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Disabled, because not sure what this does
    -- local function buf_set_option(...)
    --   vim.api.nvim_buf_set_option(bufnr, ...)
    -- end
    -- Enable completion triggered by <c-x><c-o>
    -- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",
                   opts)
    buf_set_keymap("n", "<leader>E", "<cmd>lua vim.diagnostic.open_float()<CR>",
                   opts)

    -- not using, maybe add later
    -- buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wa",
    --                "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wr",
    --                "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    -- buf_set_keymap("n", "<leader>wl",
    --                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    --                opts)
    -- buf_set_keymap("n", "<leader>D",
    --                "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
end

-- Lua
lsp_config.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {globals = {"vim", "use"}},
            workspace = {preloadFileSize = 500}
        }
    },
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- disable formatting. Handled by null-ls
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
}

-- Ruby
lsp_config.solargraph.setup {}

-- Python
lsp_config.pyright.setup {
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
    on_attach = on_attach
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
    settings = {},
    filetypes = {
        "typescript", "typescriptreact", "typescript.tsx", "javascript"
    },
    debug = false,
    -- handlers = custom_ts_handler,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
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
