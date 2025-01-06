-- for k, _ in pairs(package.loaded) do
--     if string.match(k, "config/") then package.loaded[k] = nil end
-- end

require("config.basic")

require("config.lazy")

require("config.mappings")

