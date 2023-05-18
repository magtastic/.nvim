local null_ls = require('null-ls')
local M = {}
M.sources = {
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.diagnostics.luacheck
}
return M
