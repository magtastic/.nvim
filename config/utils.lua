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

Table.string_flatten = function(tbl)
    local result = ""
    for key, value in pairs(tbl) do
        if key == 1 then
            result = value
        else
            result = result .. "\n" .. value
        end
    end
    return result
end

Table.combine = function(tables)
    local combined_table = {}

    for _, argument_table in ipairs(tables) do
        for _, value in ipairs(argument_table) do
            table.insert(combined_table, value)
        end
    end
    return combined_table
end

Table.get_only_item_in_table = function(tbl)
    local item = nil
    for _, value in pairs(tbl) do
        if value ~= nil then
            if item == nil then
                item = value
            else
                return nil
            end
        end
    end
    return item
end

M.table = Table

local Execute = {}

local EXECUTABLE_BY_FILETYPEE = {
    lua = function(filename) return {"lua", filename} end,
    node = function(filename) return {"node", filename} end,
    javascript = function(filename) return {"node", filename} end,
    typescript = function(filename) return {"ts-node", filename} end,
    python = function(filename) return {"python", filename} end
}

Execute.file = function()
    local current_filetype = vim.bo[0].filetype
    local command_generator = EXECUTABLE_BY_FILETYPEE[current_filetype]

    if command_generator == nil then
        vim.notify("Cannot find executable for filetype: " .. current_filetype,
                   vim.log.levels.WARN, {title = "Executer"})
    else
        local current_buffer_name = vim.api.nvim_buf_get_name(0)
        local command = command_generator(current_buffer_name)
        local on_stdout = function(_, output)
            local output_as_string = Table.string_flatten(output)
            vim.notify(output_as_string, vim.log.levels.INFO,
                       {title = "Executer"})
        end
        local on_stderr = function(_, output)
            if output == nil or #output == 1 then return end
            local output_as_string = Table.string_flatten(output)
            vim.notify("Error while executing file." .. output_as_string,
                       vim.log.levels.WARN, {title = "Executer"})
        end
        vim.fn.jobstart(command, {
            stdout_buffered = true,
            on_stdout = on_stdout,
            on_stderr = on_stderr
        })
    end
end

M.execute = Execute

local FileSystem = {}

FileSystem.exists = function(name)
    if type(name) ~= "string" then return false end
    return os.rename(name, name) and true or false
end

M.file_system = FileSystem

return M
