local M = {}

local Fugitive = {}

Fugitive.toggle_diff = function()
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
        local current_buffer_name = vim.api.nvim_buf_get_name(0)
        local has_diff = vim.trim(vim.fn.system(
                                      'git diff --name-only --diff-filter=U ' ..
                                          current_buffer_name))
        if has_diff ~= "" then
            vim.cmd("Gvdiffsplit!")
        else
            vim.notify("No merge conflicts found in file.", vim.log.levels.WARN,
                       {title = "Fugitive"})
        end
    end
end

M.fugitive = Fugitive

local Table = {}

Table.find = function(tbl, f)
    for _, v in ipairs(tbl) do if f(v) then return v end end
    return nil
end

Table.find_all = function(tbl, f)
    local matches = {}
    for _, v in ipairs(tbl) do if f(v) then matches[#matches + 1] = v end end
    return matches
end

Table.map = function(tbl, f)
    local t = {}
    for k, v in pairs(tbl) do t[k] = f(v) end
    return t
end

M.table = Table

return M
