local cmp = require "cmp"

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                   "^%s*$") == nil
end

cmp.setup({
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({
                    behavior = cmp.SelectBehavior.Select,
                    select = true
                })
            else
                fallback()
            end
        end),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
            select = true
        }),
        ["<CR>"] = cmp.mapping.confirm({
            -- this is the important line
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        })
    }),
    sources = cmp.config.sources({
        {name = "copilot"},
        {name = "nvim_lsp"},
        {name = "luasnip"}
    }, {{name = "buffer"}})
})

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        {name = "cmp_git"} -- You can specify the `cmp_git` source if you were installed it.
    }, {{name = "buffer"}})
})

for _, v in pairs({"/", "?"}) do
    cmp.setup.cmdline(v, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{name = "buffer"}}
    })
end

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})

require"lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {border = "rounded"}
})
