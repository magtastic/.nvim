local treesitter = require "nvim-treesitter.configs"

treesitter.setup {
    sync_install = false,
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    indent = {enable = true},
    autotag = {enable = true}
    -- textobjects = {
    --     enable = true,
    --     lsp_interop = {enable = true},
    --     keymaps = {["af"] = "@arrow_function", ["if"] = "@arrow_function"},
    --     select = {
    --         enable = true,
    --         keymaps = {
    --             -- You can use the capture groups defined in textobjects.scm
    --             ["af"] = "@arrow_function",
    --             ["if"] = "@arrow_function"
    --         }
    --     }
    -- }
}
-- TODO: add to injections file
vim.treesitter.query.set("python", "injections", [[
(call
  function: (identifier) @_function (#eq? @_function "SQL")

  (argument_list

  (string) @sql))
]])
