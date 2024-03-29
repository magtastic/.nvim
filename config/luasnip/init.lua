local luasnip = require "luasnip"

luasnip.filetype_extend("typescriptreact", {"javascript"})
require("luasnip").filetype_extend("javascriptreact", {"html"})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- local types = require "luasnip.util.types"
--
--
-- -- local s = luasnip.snippet
-- -- local t = luasnip.text_node
-- -- local i = luasnip.insert_node
-- -- local f = luasnip.function_node
--
-- luasnip.config.set_config({
--     history = true,
--     -- Update more often, :h events for more info.
--     updateevents = "TextChanged,TextChangedI",
--     ext_opts = {
--         [types.choiceNode] = {
--             active = {virt_text = {{"choiceNode", "Comment"}}}
--         }
--     },
--     -- treesitter-hl has 100, use something higher (default is 200).
--     ext_base_prio = 300,
--     -- minimal increase in priority.
--     ext_prio_increase = 1,
--     enable_autosnippets = true
-- })
--
-- -- local function copy(args)
-- --   return args[1]
-- -- end
-- --
-- -- local function get_filename()
-- --   local extension = string.format(".%s", vim.fn.expand("%:p:e"))
-- --   local filename = vim.fn.expand("%:p:t")
-- --   return string.gsub(filename, extension, "")
-- -- end
--
-- -- luasnip.snippets = {
-- --   all = {
-- --     s(
-- --       "uS",
-- --       {
-- --         t("const ["),
-- --         i(1, "state"),
-- --         f(
-- --           function(args)
-- --             local variable_name = args[1][1]
-- --             local capitalized = variable_name:sub(1, 1):upper() .. variable_name:sub(2)
-- --             return string.format(", set%s] = useState()", capitalized)
-- --           end,
-- --           1
-- --         )
-- --       }
-- --     )
-- --   }
-- -- }
--
