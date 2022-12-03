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
    symbol_in_winbar = {in_custom = true},
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
    rename_in_select = true,
    show_outline = {
        win_position = 'right',
        auto_enter = true,
        auto_preview = true,
        virt_text = '┃',
        jump_key = '<cr>',
        -- auto refresh when change buffer
        auto_refresh = true
    }
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

-- Example:
local function get_file_name(include_path)
    local file_name = require('lspsaga.symbolwinbar').get_file_name()
    if vim.fn.bufname '%' == '' then return '' end
    if include_path == false then return file_name end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''),
                                sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
        file_path =
            (cur == '.' or cur == '~') and '' or file_path .. cur .. ' ' ..
                '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
end

local function config_winbar_or_statusline()
    local exclude = {
        ['terminal'] = true,
        ['toggleterm'] = true,
        ['prompt'] = true,
        ['NvimTree'] = true,
        ['help'] = true
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        vim.wo.winbar = ''
    else
        local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
        local sym
        if ok then sym = lspsaga.get_symbol_node() end
        local win_val = ''
        win_val = get_file_name(true) -- set to true to include path
        if sym ~= nil then win_val = win_val .. sym end
        vim.wo.winbar = win_val
        -- if work in statusline
        vim.wo.stl = win_val
    end
end

local events = {'BufEnter', 'BufWinEnter', 'CursorMoved'}

vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function() config_winbar_or_statusline() end
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end
})
