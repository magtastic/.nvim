local M = {}

M.async_format = function(bufnr)
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

return M
