local nvim_tree = require("nvim-tree")

nvim_tree.setup({
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {enable = true, update_root = true},
    git = {ignore = false}
})
