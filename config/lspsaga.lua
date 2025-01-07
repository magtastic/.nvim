local saga = require("lspsaga")

local map = vim.keymap.set
local config = { noremap = true, silent = true }

local NORMAL_MODE = "n"
-- {
--     preview = {lines_above = 0, lines_below = 10},
--     scroll_preview = {scroll_down = "<C-f>", scroll_up = "<C-b>"},
--     request_timeout = 2000,
--     finder = {
--         -- percentage
--         max_height = 0.5,
--         keys = {
--             jump_to = "p",
--             edit = {"o", "<CR>"},
--             vsplit = "s",
--             split = "i",
--             tabe = "t",
--             quit = {"q", "<ESC>"},
--             close_in_preview = "<ESC>"
--         }
--     },
--     definition = {
--         edit = "<C-c>o",
--         vsplit = "<C-c>v",
--         split = "<C-c>i",
--         tabe = "<C-c>t",
--         quit = "q",
--         close = "<Esc>"
--     },
--     rename = {
--         quit = "<C-c>",
--         exec = "<CR>",
--         mark = "x",
--         confirm = "<CR>",
--         in_select = true
--     },
--     outline = {
--         win_position = "right",
--         win_with = "",
--         win_width = 30,
--         show_detail = true,
--         auto_preview = true,
--         auto_refresh = true,
--         auto_close = true,
--         custom_sort = nil,
--         keys = {jump = "<CR>", expand_collapse = "u", quit = "q"}
--     },
--     callhierarchy = {
--         show_detail = false,
--         keys = {
--             edit = "e",
--             vsplit = "s",
--             split = "i",
--             tabe = "t",
--             jump = "o",
--             quit = "q",
--             expand_collapse = "u"
--         }
--     },
--     code_action = {
--         sign = false,
--         num_shortcut = true,
--         show_server_name = true,
--         keys = {
--             -- string | table type
--             quit = "q",
--             exec = "<CR>"
--         }
--     },
--     lightbulb = {
--         enable = true,
--         enable_in_insert = true,
--         sign = true,
--         sign_priority = 40,
--         virtual_text = true
--     },
--     diagnostic = {
--         on_insert = false,
--         on_insert_follow = false,
--         insert_winblend = 0,
--         show_code_action = true,
--         show_source = true,
--         jump_num_shortcut = true,
--         max_width = 0.7,
--         max_height = 0.6,
--         max_show_width = 0.9,
--         max_show_height = 0.6,
--         text_hl_follow = true,
--         border_follow = true,
--         extend_relatedInformation = false,
--         keys = {
--             exec_action = "o",
--             quit = "q",
--             expand_or_jump = "<CR>",
--             quit_in_show = {"q", "<ESC>"}
--         }
--     },
--     symbol_in_winbar = {
--         enable = true,
--         separator = "  ",
--         ignore_patterns = {},
--         hide_keyword = true,
--         show_file = true,
--         folder_level = 2,
--         respect_root = false,
--         color_mode = true
--     },
--     ui = {
--         -- This option only works in Neovim 0.9
--         title = true,
--         -- Border type can be single, double, rounded, solid, shadow.
--         border = "single",
--         winblend = 0,
--         expand = "",
--         collapse = "",
--         code_action = "💡",
--         incoming = " ",
--         outgoing = " ",
--         hover = " ",
--         kind = {}
--     }
-- }
saga.setup({
	ui = {
		code_action = "",
	},
	finder = {
		-- percentage
		max_height = 0.5,
		keys = {
			jump_to = "p",
			edit = { "o", "<CR>" },
			vsplit = "s",
			split = "i",
			tabe = "t",
			quit = { "q", "<ESC>" },
			close_in_preview = "<ESC>",
		},
	},
})

-- map(NORMAL_MODE, "gd", "<cmd>Lspsaga peek_definition<CR>", config)
map(NORMAL_MODE, "gd", vim.lsp.buf.definition, config)
-- map(NORMAL_MODE, "gi", vim.lsp.buf.implementation, config)
map(NORMAL_MODE, "gr", "<cmd>Lspsaga finder<CR>", config)
map(NORMAL_MODE, "K", "<cmd>Lspsaga hover_doc<CR>", config)
map(NORMAL_MODE, "<leader>rn", "<cmd>Lspsaga rename<CR>", config)
-- map(NORMAL_MODE, "<leader>ca", "<cmd>Lspsaga code_action<CR>", config)
map(NORMAL_MODE, "<leader>E", "<cmd>Lspsaga show_line_diagnostics<CR>", config)
--
-- map(NORMAL_MODE, "]E", "<cmd>Lspsaga show_buf_diagnostics<CR>", config)
map(NORMAL_MODE, "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", config)
map(NORMAL_MODE, "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", config)
--
-- map(NORMAL_MODE, "<leader>o", "<cmd>Lspsaga outline<CR>", config)
--
-- map(NORMAL_MODE, "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", config)
-- map(NORMAL_MODE, "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", config)
