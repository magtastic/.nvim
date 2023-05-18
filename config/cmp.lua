local cmp = require "cmp"

local kind_icons = {
    Text = {"", "#666666"},
    File = {" ", "#AF87D7"},
    Module = {" ", "#666666"},
    Package = {" ", "#666666"},
    Class = {" ", "#BBE73D"},
    Method = {" ", "#C53B82"},
    Property = {" ", "#666666"},
    Field = {" ", "#666666"},
    Constructor = {" ", "#666666"},
    Enum = {" ", "#666666"},
    Interface = {" ", "#666666"},
    Function = {" ", "#C53B82"},
    Variable = {" ", "#BBE73D"},
    Constant = {" ", "#666666"},
    String = {" ", "#444444"},
    Number = {" ", "#AFC460"},
    Boolean = {" ", "#C53B82"},
    Array = {" ", "#614F97"},
    Object = {" ", "#666666"},
    Key = {" ", "#666666"},
    Null = {" ", "#C53B82"},
    EnumMember = {" ", "#666666"},
    Event = {" ", "#666666"},
    Operator = {" ", "#666666"},
    TypeParameter = {" ", "#666666"},
    TypeAlias = {" ", "#666666"},
    Parameter = {" ", "#8567A3"},
    Macro = {" ", "#666666"}
}

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                   "^%s*$") == nil
end

local lspkind = require("lspkind")

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "..." -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        })
    },
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

local signs = {Error = " ", Warn = " ", Info = " ", Hint = " "}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

vim.diagnostic.config({
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {prefix = ""}
})
