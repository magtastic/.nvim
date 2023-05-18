local null_ls = require("null-ls")
local M = {}
M.sources = {null_ls.builtins.formatting.rustfmt}
return M
