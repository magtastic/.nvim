local map = vim.api.nvim_set_keymap
local config = {noremap = true, silent = true}
local NORMAL_MODE = "n"

-- Split buffers
map(NORMAL_MODE, "<leader>v", ":vsplit<cr>", config)
map(NORMAL_MODE, "<leader>V", ":split<cr>", config)

-- Buffers movements
map(NORMAL_MODE, "<leader>h", ":wincmd h<cr>", config)
map(NORMAL_MODE, "<leader>j", ":wincmd j<cr>", config)
map(NORMAL_MODE, "<leader>k", ":wincmd k<cr>", config)
map(NORMAL_MODE, "<leader>l", ":wincmd l<cr>", config)

-- Resize buffers
map(NORMAL_MODE, "<C-h>", ":vertical resize -5<cr>", config)
map(NORMAL_MODE, "<C-j>", ":resize +5<cr>", config)
map(NORMAL_MODE, "<C-k>", ":resize -5<cr>", config)
map(NORMAL_MODE, "<C-l>", ":vertical resize +5<cr>", config)

-- Swap previous buffer
map(NORMAL_MODE, "<leader>e", ":e#<cr>", config)

-- Save/Close buggers
map(NORMAL_MODE, "<leader>s", ":w<cr>", config)
map(NORMAL_MODE, "<leader>x", ":q<cr>", config)

-- Telescope
map(NORMAL_MODE, "<C-p>", ":Telescope find_files hidden=true<cr>", config)
map(NORMAL_MODE, "<C-f>", ":Telescope projects<cr>", config)
map(NORMAL_MODE, "<C-o>", ":Telescope live_grep<cr>", config)

-- Nvim Tree
map(NORMAL_MODE, "<C-n>", ":NvimTreeToggle<cr>", config)

-- Remove highlight after search
map(NORMAL_MODE, "<leader>/", ":noh<cr>", config)

-- Reload
map(NORMAL_MODE, "<leader>r", ":source $CONFIG_PATH/nvim/init.lua<cr>", config)

-- Github
map(NORMAL_MODE, "<leader>gp", ":Telescope gh pull_request<cr>", config)

-- Fugitive
map(NORMAL_MODE, "<leader>gg", ":Git<cr>", config)
map(NORMAL_MODE, "<leader>gd",
    ":lua require('config/utils').fugitive.toggle_diff()<cr>", config)
map(NORMAL_MODE, "<leader>gh", ":diffget //2<cr>", config)
map(NORMAL_MODE, "<leader>gl", ":diffget //3<cr>", config)
