local saga = require("lspsaga")

local map = vim.keymap.set
local config = {noremap = true, silent = true}

local NORMAL_MODE = "n"

saga.setup({
    preview = {lines_above = 0, lines_below = 10},
    scroll_preview = {scroll_down = "<C-f>", scroll_up = "<C-b>"},
    request_timeout = 2000,
    finder = {
        -- percentage
        max_height = 0.5,
        keys = {
            jump_to = 'p',
            edit = {'o', '<CR>'},
            vsplit = 's',
            split = 'i',
            tabe = 't',
            quit = {'q', '<ESC>'},
            close_in_preview = '<ESC>'
        }
    },

    definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>i",
        tabe = "<C-c>t",
        quit = "q",
        close = "<Esc>"
    },
    rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true
    },
    outline = {
        win_position = "right",
        win_with = "",
        win_width = 30,
        show_detail = true,
        auto_preview = true,
        auto_refresh = true,
        auto_close = true,
        custom_sort = nil,
        keys = {jump = "<CR>", expand_collapse = "u", quit = "q"}
    },
    callhierarchy = {
        show_detail = false,
        keys = {
            edit = "e",
            vsplit = "s",
            split = "i",
            tabe = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u"
        }
    },
    code_action = {
        num_shortcut = true,
        show_server_name = false,
        keys = {
            -- string | table type
            quit = "q",
            exec = "<CR>"
        }
    },
    lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true
    },
    diagnostic = {
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        -- 1 is max
        max_width = 0.7,
        custom_fix = nil,
        custom_msg = nil,
        text_hl_follow = false,
        border_follow = true,
        keys = {exec_action = "o", quit = "q", go_action = "g"}
    },
    symbol_in_winbar = {
        enable = true,
        separator = "  ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true
    }
    --
    -- border_style = "rounded", -- "single" | "double" | "rounded" | "bold" | "plus"
    --
    -- -- the range of 0 for fully opaque window (disabled) to 100 for fully
    -- -- transparent background. Values between 0-30 are typically most useful.
    -- saga_winblend = 0,
    --
    -- move_in_saga = {prev = '<C-p>', next = '<C-n>'}, -- when cursor in saga window you config these to move
    --
    -- diagnostic_header = {"", "", "", "ﴞ"}, -- Error, Warn, Info, Hint
    -- -- preview lines of lsp_finder and definition preview
    -- max_preview_lines = 10,
    -- -- use emoji lightbulb in default
    -- code_action_icon = "ﴞ",
    -- -- if true can press number to execute the codeaction in codeaction window
    -- code_action_num_shortcut = true,
    -- -- same as nvim-lightbulb but async
    -- code_action_lightbulb = {
    --     enable = true,
    --     enable_in_insert = true,
    --     cache_code_action = false,
    --     sign = false,
    --     update_time = 150,
    --     sign_priority = 20,
    --     virtual_text = true
    -- },
    -- -- finder icons
    -- finder_icons = {def = '  ', ref = '諭 ', link = '  '},
    -- -- finder do lsp request timeout
    -- -- if your project big enough or your server very slow
    -- -- you may need to increase this value
    -- finder_request_timeout = 1500,
    -- finder_action_keys = {vsplit = "<CR>", quit = "<ESC>"},
    -- code_action_keys = {quit = "<Esc>", exec = "<CR>"},
})

map(NORMAL_MODE, "gD", "<cmd>Lspsaga peek_definition<CR>", config)
map(NORMAL_MODE, "gd", vim.lsp.buf.definition, config)
map(NORMAL_MODE, "gr", "<cmd>Lspsaga lsp_finder<CR>", config)
map(NORMAL_MODE, "K", "<cmd>Lspsaga hover_doc<CR>", config)
map(NORMAL_MODE, "<leader>rn", "<cmd>Lspsaga rename<CR>", config)
map(NORMAL_MODE, "<leader>ca", "<cmd>Lspsaga code_action<CR>", config)
map(NORMAL_MODE, "<leader>E", "<cmd>Lspsaga show_line_diagnostics<CR>", config)

map(NORMAL_MODE, "]E", "<cmd>Lspsaga show_buf_diagnostics<CR>", config)
map(NORMAL_MODE, "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", config)
map(NORMAL_MODE, "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", config)

map(NORMAL_MODE, "<leader>o", "<cmd>Lspsaga outline<CR>", config)

map(NORMAL_MODE, "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", config)
map(NORMAL_MODE, "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", config)
