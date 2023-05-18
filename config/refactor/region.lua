---@class Region
---@field start_row number
---@field start_col number
---@field end_row number
---@field end_col number
---@field node any
---@field bufnr number: the buffer that the region is from
local Region = {}
Region.__index = Region

--- Get a region from a Treesitter Node
---@return Region
function Region:from_node(node, bufnr)
    bufnr = bufnr or vim.fn.bufnr()
    local start_line, start_col, end_line, end_col = node:range()

    return setmetatable({
        bufnr = vim.fn.bufnr(bufnr),
        node = node,
        start_row = start_line,
        start_col = start_col,
        end_row = end_line,
        end_col = end_col
    }, self)
end

--- Update range
---@return Region
function Region:update_range()
    local start_line, start_col, end_line, end_col = self.node:range()

    return setmetatable({
        bufnr = self.bufnr,
        node = self.node,
        start_row = start_line,
        start_col = start_col,
        end_row = end_line,
        end_col = end_col
    }, self)
end

--- Convert a region to an LSP Range
function Region:to_lsp_range()
    return {
        ["start"] = {line = self.start_row, character = self.start_col},
        ["end"] = {line = self.end_row, character = self.end_col}
    }
end

function Region:next_line_lsp_range()
    return {
        ["start"] = {line = self.end_row, character = 0},
        ["end"] = {line = self.end_row + 1, character = 1000000000000}
    }
end

function Region:to_lsp_text_edit(text)
    return {range = self:to_lsp_range(), newText = text}
end

function Region:change_value(text)
    local changes = self:to_lsp_text_edit(text)
    vim.lsp.util.apply_text_edits({changes}, self.bufnr)
    local updated_node = self:update_range()
    return updated_node
end

function Region:add_line_below_region(text)
    local changes = {range = self:next_line_lsp_range(), newText = text}
    vim.lsp.util.apply_text_edits({changes}, self.bufnr)
    local updated_node = self:update_range()
    return updated_node
end

function Region:move_node_to_current_position(prefix, postfix)
    local content = self:get_text()
    local pos = vim.api.nvim_win_get_cursor(0)

    if prefix then content[1] = string.format("%s %s", prefix, content[1]) end

    if postfix then table.insert(content, postfix) end

    vim.api.nvim_buf_set_lines(0, pos[1], pos[1], false, content)
    local changes = self:to_lsp_text_edit("")
    vim.lsp.util.apply_text_edits({changes}, self.bufnr)
    local updated_node = self:update_range()
    return updated_node
end

function Region:get_text()
    local text = vim.api.nvim_buf_get_lines(self.bufnr, self.start_row,
                                            self.end_row + 2, false)

    local text_length = #text
    local end_col = math.min(#text[text_length], self.end_col)
    local end_idx = vim.str_byteindex(text[text_length], end_col)
    local start_idx = vim.str_byteindex(text[1], self.start_col)

    text[text_length] = text[text_length]:sub(1, end_idx)
    text[1] = text[1]:sub(start_idx)

    return text
end

return Region
