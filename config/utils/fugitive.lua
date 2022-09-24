local M = {}

M.toggle_diff = function()
    local bufnrs = vim.api.nvim_list_bufs()
    local fugitivebufs = {}

    for _, bufnr in ipairs(bufnrs) do
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local matches = string.match(bufname, "fugitive:///")
        if matches ~= nil then table.insert(fugitivebufs, bufnr) end
    end

    if #fugitivebufs >= 2 then
        for _, fugitivebufnr in ipairs(fugitivebufs) do
            vim.api.nvim_buf_delete(fugitivebufnr, {force = true})
        end
    else
        vim.cmd("Gdiffsplit!")
    end
end

return M
