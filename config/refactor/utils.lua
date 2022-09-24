local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

M.create_file = function(name)
  local filetype = vim.bo.filetype
  vim.cmd(":vnew")
  vim.cmd(string.format(":set filetype=%s", filetype))
  vim.cmd(string.format(":w! %s", name))
end

M.get_next_arrow_function_node = function()
  local node = ts_utils.get_node_at_cursor()

  if not node then
    error("No Treesitter parser found")
  end

  while node do
    if node:type() == "arrow_function" then
      break
    end
    node = node:parent()
  end

  if node:parent():type() == "variable_declarator" and node:parent():parent():type() == "lexical_declaration" then
    return node:parent():parent()
  end

  return nil
end

M.get_last_import_node = function()
  local current_node = ts_utils.get_node_at_cursor()
  local root = ts_utils.get_root_for_node(current_node)
  local last_import_node = nil

  for node in root:iter_children() do
    if node:type() == "import_statement" then
      last_import_node = node
    end
  end

  return last_import_node
end

local function find_child_node(current_node, compare_function)
  if not current_node then
    return nil
  end
  if compare_function(current_node) then
    return current_node
  end
  local found_node = nil
  for node in current_node.iter_children() do
    found_node = find_child_node(node, compare_function)
    if found_node then
      return found_node
    end
  end
end

M.get_node_by_id = function(node_id)
  local current_node = ts_utils.get_node_at_cursor()
  local root = ts_utils.get_root_for_node(current_node)
  local function compare(node)
    return node:id() == node_id
  end
  local found_node = find_child_node(root, compare)

  return found_node
end

return M
