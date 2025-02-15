local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  auto_install = true,
	sync_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },
	autotag = { enable = true },
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
})
