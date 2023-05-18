local null_ls = require("null-ls")
local M = {}
M.sources = {
    null_ls.builtins.formatting.sqlfluff.with({
        extra_args = {"--dialect", "postgres"}
    })
    -- TODO enable
    -- null_ls.builtins.diagnostics.sqlfluff.with({ 
    --       extra_args = {"--dialect", "postgres"} -- change to your dialect
    --   })
}

return M
