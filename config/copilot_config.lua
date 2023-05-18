vim.defer_fn(function()
    require('copilot').setup({
        panel = {enabled = false},
        suggestion = {enabled = false}
    })
    require("copilot_cmp").setup()
end, 100)
