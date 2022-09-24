local null_ls = require('null-ls')
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local get_whitespace_count = function(input)
    local whitespace_count = 0
    local fixed = input:gsub('^\n', '')

    for i = 1, #fixed do
        if (string.sub(fixed, i, i) == " ") then
            whitespace_count = whitespace_count + 1
        else
            return whitespace_count
        end
    end

    return whitespace_count
end

local potential_sql_beginning = {"SELECT", "UPDATE", "INSERT", "DELETE"}

local format_sql = function(bufnr)
    local edits = {}
    local language_tree = vim.treesitter.get_parser(bufnr, 'python')
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()
    local query = vim.treesitter.parse_query('python', [[
          (
           (string) @sql
          )
        ]])
    for _, captures, _ in query:iter_matches(root, bufnr) do
        local node = captures[1]
        local start_row, _, end_row, _ = node:range()
        if start_row == end_row then goto continue end

        local text = vim.treesitter.get_node_text(node, bufnr)
        local untrimmed_content = text:gsub('"', '')
        local indentation_level = get_whitespace_count(untrimmed_content)
        local indentation_string = string.rep(" ", indentation_level)
        local content = untrimmed_content:gsub("^%s*", "")
        local match = nil

        for _, beginning in ipairs(potential_sql_beginning) do
            match = string.find(content, '^' .. beginning)
            if match ~= nil then break end
        end

        if match == 1 then
            local cmd = string.format(
                            'echo "%s" | sql-formatter -c /Users/magtastic/Developer/Smitten/api/test.json',
                            content)
            local pipe = io.popen(cmd)
            if pipe ~= nil then
                local formatted_sql = pipe:read("*a"):gsub("\n$", "")
                local a = indentation_string ..
                              formatted_sql:gsub('\n',
                                                 '\n' .. indentation_string)
                local edit = {
                    range = {
                        ["start"] = {line = start_row + 1, character = 0},
                        ["end"] = {line = end_row - 1, character = 1000}
                    },
                    newText = a
                }
                table.insert(edits, edit)
                pipe:close()
            end
        end
        ::continue::
    end
    return edits
end

local async_formatting = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(bufnr, "textDocument/formatting",
                        vim.lsp.util.make_formatting_params({}),
                        function(err, res, ctx)
        if err then
            local err_msg = type(err) == "string" and err or err.message
            -- you can modify the log message / level (or ignore it completely)
            vim.notify("formatting: " .. err_msg, vim.log.levels.WARN,
                       {title = "Async Formatter"})
            return
        end

        -- local sql_edits = format_sql(bufnr)
        -- local edits = {table.unpack(res), table.unpack(sql_edits)}

        if vim.api.nvim_buf_get_option(bufnr, "modified") then
            vim.notify("⚠️  Buffer change detected. No formatting applied.",
                       vim.log.levels.WARN, {title = "Async Formatter"})
            return
        end

        -- don't apply results if buffer is unloaded or has been modified
        if not vim.api.nvim_buf_is_loaded(bufnr) then return end

        if res then
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            vim.lsp.util.apply_text_edits(res, bufnr, client and
                                              client.offset_encoding or "utf-16")
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("silent noautocmd update")
            end)
        end
    end)
end

local sources = {
    null_ls.builtins.formatting.prettier, null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.black.with({extra_args = {"--fast"}}),
    null_ls.builtins.formatting.lua_format
}

null_ls.setup({
    debug = false,
    sources = sources,
    on_attach = function(client, bufnr)
        local current_filetype = vim.bo[bufnr].filetype

        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    if current_filetype == 'python' then
                        async_formatting(bufnr)
                    else
                        vim.lsp.buf.formatting_sync()
                    end
                end
            })
        end
    end
})
