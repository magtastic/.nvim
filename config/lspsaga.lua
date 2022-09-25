local saga = require("lspsaga")
local map = vim.keymap.set
local config = {noremap = true, silent = true}
local NORMAL_MODE = "n"

saga.init_lsp_saga({
    -- Options with default value
    -- "single" | "double" | "rounded" | "bold" | "plus"
    border_style = "rounded",
    -- the range of 0 for fully opaque window (disabled) to 100 for fully
    -- transparent background. Values between 0-30 are typically most useful.
    saga_winblend = 0,
    -- when cursor in saga window you config these to move
    move_in_saga = {prev = '<C-p>', next = '<C-n>'},
    -- Error, Warn, Info, Hint
    -- use emoji like
    -- { "🙀", "😿", "😾", "😺" }
    -- or
    -- { "😡", "😥", "😤", "😐" }
    -- and diagnostic_header can be a function type
    -- must return a string and when diagnostic_header
    -- is function type it will have a param `entry`
    -- entry is a table type has these filed
    -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
    diagnostic_header = {" ", " ", " ", "ﴞ "},
    -- preview lines of lsp_finder and definition preview
    max_preview_lines = 10,
    -- use emoji lightbulb in default
    code_action_icon = "💡",
    -- if true can press number to execute the codeaction in codeaction window
    code_action_num_shortcut = true,
    -- same as nvim-lightbulb but async
    code_action_lightbulb = {
        enable = true,
        enable_in_insert = true,
        cache_code_action = false,
        sign = false,
        update_time = 150,
        sign_priority = 20,
        virtual_text = true
    },
    -- finder icons
    finder_icons = {def = '  ', ref = '諭 ', link = '  '},
    -- finder do lsp request timeout
    -- if your project big enough or your server very slow
    -- you may need to increase this value
    finder_request_timeout = 1500,
    finder_action_keys = {vsplit = "<CR>", quit = "<ESC>"},
    code_action_keys = {quit = "<Esc>", exec = "<CR>"},
    rename_action_quit = "<C-c>",
    rename_in_select = true
})

map(NORMAL_MODE, "gd", "<cmd>Lspsaga peek_definition<CR>", config)
map(NORMAL_MODE, "<leader>o", "<cmd>LSoutlineToggle<CR>", config)
map(NORMAL_MODE, "gr", "<cmd>Lspsaga lsp_finder<CR>", config)
map(NORMAL_MODE, "K", "<cmd>Lspsaga hover_doc<CR>", config)
map(NORMAL_MODE, "<leader>rn", "<cmd>Lspsaga rename<CR>", config)
map(NORMAL_MODE, "<leader>ca", "<cmd>Lspsaga code_action<CR>", config)
map(NORMAL_MODE, "<leader>E", "<cmd>Lspsaga show_line_diagnostics<CR>", config)
map(NORMAL_MODE, "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", config)
map(NORMAL_MODE, "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", config)
