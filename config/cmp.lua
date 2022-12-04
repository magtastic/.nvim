local cmp = require 'cmp'
local tabnine = require('cmp_tabnine.config')

tabnine:setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
    ignored_file_types = {
        -- default is not to ignore
        -- lua = true
    },
    show_prediction_strength = true
})

local cmp_kinds = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

local source_map = {
    buffer = "[]",
    nvim_lsp = "[]",
    cmp_tabnine = "[]",
    luasnip = "[]",
    latex_symbols = "[LaTeX]"
}
-- 

cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            require('cmp_tabnine.compare'), cmp.config.compare.offset,
            cmp.config.compare.exact, cmp.config.compare.score,
            cmp.config.compare.recently_used, cmp.config.compare.kind,
            cmp.config.compare.sort_text, cmp.config.compare.length,
            cmp.config.compare.order
        }
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", cmp_kinds[vim_item.kind],
                                          vim_item.kind)
            vim_item.menu = (source_map)[entry.source.name]
            return vim_item
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({select = true})
    }),
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'luasnip'},
        {name = 'nvim_lsp_signature_help'}, {name = 'cmp_tabnine'}
    }, {{name = 'buffer'}})
})

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        {name = 'cmp_git'} -- You can specify the `cmp_git` source if you were installed it.
    }, {{name = 'buffer'}})
})

for _, v in pairs({'/', '?'}) do
    cmp.setup.cmdline(v, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{name = 'buffer'}}
    })
end
