local saga = require("lspsaga")

local map = vim.keymap.set
local config = {noremap = true, silent = true}

local kind = {
    [1] = {'File', ' ', 'Tag'},
    [2] = {'Module', ' ', 'Exception'},
    [3] = {'Namespace', ' ', 'Include'},
    [4] = {'Package', ' ', 'Label'},
    [5] = {'Class', ' ', 'Include'},
    [6] = {'Method', ' ', 'Function'},
    [7] = {'Property', ' ', '@property'},
    [8] = {'Field', ' ', '@field'},
    [9] = {'Constructor', ' ', '@constructor'},
    [10] = {'Enum', ' ', '@number'},
    [11] = {'Interface', ' ', 'Type'},
    [12] = {'Function', '󰡱 ', 'Function'},
    [13] = {'Variable', ' ', '@variable'},
    [14] = {'Constant', ' ', 'Constant'},
    [15] = {'String', '󰅳 ', 'String'},
    [16] = {'Number', '󰎠 ', 'Number'},
    [17] = {'Boolean', ' ', 'Boolean'},
    [18] = {'Array', '󰅨 ', 'Type'},
    [19] = {'Object', ' ', 'Type'},
    [20] = {'Key', ' ', 'Constant'},
    [21] = {'Null', '󰟢 ', 'Constant'},
    [22] = {'EnumMember', ' ', 'Number'},
    [23] = {'Struct', ' ', 'Type'},
    [24] = {'Event', ' ', 'Constant'},
    [25] = {'Operator', ' ', 'Operator'},
    [26] = {'TypeParameter', ' ', 'Type'},
    -- ccls
    [252] = {'TypeAlias', ' ', 'Type'},
    [253] = {'Parameter', ' ', '@parameter'},
    [254] = {'StaticMethod', ' ', 'Function'},
    [255] = {'Macro', ' ', 'Macro'},
    -- for completion sb microsoft!!!
    [300] = {'Text', '󰭷 ', 'String'},
    [301] = {'Snippet', ' ', '@variable'},
    [302] = {'Folder', ' ', 'Title'},
    [303] = {'Unit', '󰊱 ', 'Number'},
    [304] = {'Value', ' ', '@variable'}
}

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
        ignore_patterns = {},
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true
    },
    ui = {
        -- This option only works in Neovim 0.9
        title = true,
        -- Border type can be single, double, rounded, solid, shadow.
        border = "single",
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = ' ',
        kind = {}
    }
})

map(NORMAL_MODE, "gD", "<cmd>Lspsaga peek_definition<CR>", config)
map(NORMAL_MODE, "gd", vim.lsp.buf.definition, config)
map(NORMAL_MODE, "gi", vim.lsp.buf.implementation, config)
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
