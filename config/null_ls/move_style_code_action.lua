local null_ls = require("null-ls")

local move_styles_code_action = {
    method = null_ls.methods.CODE_ACTION,
    filetypes = {"javascriptreact", "typescriptreact"},
    generator = {
        fn = function(context)
            local diagnostics = vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.ERR
            })

            for _, item in ipairs(diagnostics) do
                if item['code'] == "react-native/no-inline-styles" and
                    item['row'] == context.range.row then
                    return {
                        {
                            title = "Move style to StyleSheet",
                            action = function()
                                local language_tree =
                                    vim.treesitter.get_parser(item['bufnr'],
                                                              'tsx')
                                local syntax_tree = language_tree:parse()

                                local root = syntax_tree[1]:root()
                                -- TODO: Fix query. getting error but works fine on
                                -- https://tree-sitter.github.io/tree-sitter/playground
                                local query =
                                    vim.treesitter.parse_query('python', [[
                                        (variable_declarator
                                          (call_expression
                                            (member_expression
                                              (identifier) @test
                                              (#match? @test "StyleSheet")
                                            )
                                          )
                                        )
                                      ]])

                                for pattern, match, metadata in
                                    query:iter_matches(root, item['bufnr']) do
                                    -- ('pattern:')
                                    -- (vim.inspect(pattern))
                                    -- ('match:')
                                    -- (vim.inspect(match))
                                    -- ('metadata:')
                                    -- (vim.inspect(metadata))
                                end
                            end

                        }
                    }
                end
            end
        end
    }
}
--
-- -- { {
--     bufnr = 16,
--     code = "react-native/no-inline-styles",
--     col = 19,
--     end_col = 32,
--     end_lnum = 52,
--     end_row = 53,
--     lnum = 52,
--     message = "Inline style: { bottom: 1 }",
--     namespace = 19,
--     row = 53,
--     severity = 1,
--     source = "eslint_d"
--   } }
--   CONTEXT
--   {
--   bufname = "/Users/magtastic/Developer/Smitten/app/app/screens/Main.tsx",
--   bufnr = 23,
--   client_id = 2,
--   col = 1,
--   ft = "typescriptreact",
--   lsp_method = "textDocument/codeAction",
--   method = "NULL_LS_CODE_ACTION",
--   range = {
--     col = 2,
--     end_col = 2,
--     end_row = 2,
--     row = 2
--   },
--   row = 2
-- }

return move_styles_code_action
