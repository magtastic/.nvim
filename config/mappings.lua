-- VIM MAPPINGS
local map = vim.keymap.set
local config = { noremap = true, silent = true }

local NORMAL_MODE = "n"
local VISUAL_MODE = "x"
-- local VISUAL_INCLUDING_SELECT_MODE = "v"
-- local OPERATOR_PENDING_MODE = "o"
-- local INSERT_MODE = "i"
-- local CMD_LINE_MODE = "c"
-- local SELECT_MODE = "s"
-- local LANGMAP_OR_LANGUAGE-MAPPING_MODE = "l"
-- local TERMINAL_MODE = "t"
-- local NORMAL_VISUAL_AND_OPERATOR_PENDING_MODE = ""

-- Split buffers
map({ NORMAL_MODE }, "<leader>v", ":vsplit<cr>", config)
map({ NORMAL_MODE }, "<leader>V", ":split<cr>", config)

-- Buffers movements
map({ NORMAL_MODE }, "<leader>h", ":wincmd h<cr>", config)
map({ NORMAL_MODE }, "<leader>j", ":wincmd j<cr>", config)
map({ NORMAL_MODE }, "<leader>k", ":wincmd k<cr>", config)
map({ NORMAL_MODE }, "<leader>l", ":wincmd l<cr>", config)

-- Resize buffers
map({ NORMAL_MODE }, "<C-h>", ":vertical resize -5<cr>", config)
map({ NORMAL_MODE }, "<C-j>", ":resize +5<cr>", config)
map({ NORMAL_MODE }, "<C-k>", ":resize -5<cr>", config)
map({ NORMAL_MODE }, "<C-l>", ":vertical resize +5<cr>", config)

-- Move lines
-- map({NORMAL_MODE}, "m", ":m .+1<CR>==", config)
-- map({NORMAL_MODE}, "M", ":m .-2<CR>==", config)
-- map({VISUAL_MODE}, "m", ":m '>+1<CR>gv=gv", config)
-- map({VISUAL_MODE}, "M", ":m '<-2<CR>gv=gv", config)

-- Swap previous buffer
map({ NORMAL_MODE }, "<leader>e", ":e#<cr>", config)

-- Center when jumping in search
map({ NORMAL_MODE }, "n", "nzz", config)
map({ NORMAL_MODE }, "N", "Nzz", config)

-- Save/Close buggers
map({ NORMAL_MODE }, "<leader>s", ":w<cr>", config)
map({ NORMAL_MODE }, "<leader>x", ":q<cr>", config)

-- Telescope
local telescope_builtin = require("telescope.builtin")
map({ NORMAL_MODE }, "<C-p>", function()
	telescope_builtin.find_files({ hidden = true })
end, config)
map({ NORMAL_MODE }, "<C-o>", function()
	telescope_builtin.live_grep()
end, config)
map({ NORMAL_MODE }, "<C-i>", function()
	telescope_builtin.resume()
end, config)
map({ NORMAL_MODE }, "<C-f>", ":Telescope projects<cr>", config)

map({ NORMAL_MODE }, "<leader>t", function()
	require("config/openai").finish_file()
end, config)

-- Nvim Tree
map({ NORMAL_MODE }, "<C-n>", ":NvimTreeToggle<cr>", config)

-- Remove highlight after search
map({ NORMAL_MODE }, "<leader>/", ":noh<cr>", config)

-- Reload - broken. TODO fix
-- map({NORMAL_MODE}, "<leader>r", ":source $CONFIG_PATH/nvim/init.lua<cr>", config)

map({ NORMAL_MODE }, "<leader><leader>x", function()
	require("config/utils").execute.file()
end, config)

-- Structural search and replace
map({ NORMAL_MODE, VISUAL_MODE }, "<leader>sr", function()
	require("ssr").open()
end, config)

-- Github
map({ NORMAL_MODE }, "<leader>gp", ":Telescope gh pull_request<cr>", config)
map({ NORMAL_MODE }, "<leader>gb", function()
	telescope_builtin.git_branches()
end, config)

-- Fugitive
map({ NORMAL_MODE }, "<leader>gg", ":Git<cr>", config)
map({ NORMAL_MODE }, "<leader>gd", function()
	require("config/utils").fugitive.toggle_diff()
end, config)
map({ NORMAL_MODE }, "<leader>gh", ":diffget //2<cr>", config)
map({ NORMAL_MODE }, "<leader>gl", ":diffget //3<cr>", config)
