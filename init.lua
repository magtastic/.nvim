for k, _ in pairs(package.loaded) do
    if string.match(k, "config/utils") then package.loaded[k] = nil end
end

require "config/basic"
require "config/mappings"

require "config/packer"

require "config/lsp"
require "config/lspsaga"
require "config/null_ls/init"

require "config/lualine"
require "config/telescope"
require "config/cmp"
require "config/treesitter"
require "config/autopairs"
require "config/tree"
require "config/notify"
