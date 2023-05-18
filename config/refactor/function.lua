local Region = require "config.refactor.region"
local ts_utils = require "nvim-treesitter.ts_utils"
local utils = require "config.refactor.utils"

---@class Function
---@field node any
---@field region Region
---@field bufnr number: the buffer that the region is from
local Function = {}
Function.__index = Function

--- Get a region from a Treesitter Node
---@return Function
function Function:from_node(node, bufnr)
    bufnr = bufnr or vim.fn.bufnr()
    return setmetatable({
        bufnr = vim.fn.bufnr(bufnr),
        node = node,
        region = Region:from_node(node, bufnr)
    }, self)
end

--- Update region
---@return Function
function Function:update_region(new_region)
    return setmetatable({
        bufnr = self.bufnr,
        node = self.node,
        region = new_region
    }, self)
end

--- Get function name
---@return string
function Function:get_function_name()
    local name_node = self.node:child(1):field("name")[1]
    return ts_utils.get_node_text(name_node)[1]
end

--- Get name of extraction file
---@return string
function Function:get_name_of_extraction_file()
    local function_name = self:get_function_name()
    local extension = string.format(".%s", vim.fn.expand("%:p:e"))
    return string.format("%s%s", function_name, extension)
end

--- Get content
---@return string
function Function:move_to_current_position(prefix, postfix)
    local new_region =
        self.region:move_node_to_current_position(prefix, postfix)
    return setmetatable({
        bufnr = vim.fn.bufnr(),
        region = new_region,
        node = self.node
    }, self)
end

--- Move function to file
---@return string
function Function:move_function_to_file(last_import_node)
    local function_name = self:get_function_name()
    local function_file_name = self:get_name_of_extraction_file()

    if last_import_node then
        local import_node_region = Region:from_node(last_import_node)
        local new_region = import_node_region:add_line_below_region(
                               string.format("import %s from './%s'",
                                             function_name, function_file_name))
        self.update_region(new_region)
    end

    utils.create_file(function_file_name)
    local new_region = self:move_to_current_position(nil, string.format(
                                                         "export default %s",
                                                         function_name))
    local new_function = self:update_region(new_region)

    return new_function
end

return Function
