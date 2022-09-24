local utils = require "config.refactor.utils"
local Function = require "config.refactor.function"
local M = {}

M.move_current_function_to_file = function()
  print("a")
  local arrow_function_node = utils.get_next_arrow_function_node()
  if not arrow_function_node then
    print("Not in an arrow function...")
    return
  end
  print("b")
  local last_import_node = utils.get_last_import_node()
  print("c")
  local arrow_function = Function:from_node(arrow_function_node)
  local new = utils.get_node_by_id(arrow_function.node:id())
  print(arrow_function.node)
  print(new)
  print("d")
  -- arrow_function:move_function_to_file(last_import_node)
  print("e")
end

return M
