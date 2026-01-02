local saga = require("lspsaga")

local map = vim.keymap.set
local config = { noremap = true, silent = true }

local NORMAL_MODE = "n"

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
map(NORMAL_MODE, "<leader>o", "<cmd>Lspsaga outline<CR>", config)
--
-- map(NORMAL_MODE, "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", config)
-- map(NORMAL_MODE, "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", config)
