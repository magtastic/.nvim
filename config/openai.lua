local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local popup = Popup({
    enter = true,
    focusable = true,
    border = {style = "rounded"},
    position = "50%",
    size = {width = "80%", height = "60%"}
})

local M = {}

local function mysplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

local function set_output_to_popup(output)
    -- vim.notify(output, vim.log.levels.INFO, {title = "TEST"})
    -- -- mount/open the component
    -- popup:mount()
    -- --
    -- -- unmount component when cursor leaves buffer
    -- popup:on(event.BufLeave, function() popup:unmount() end)
    --
    -- local lines = mysplit(output, "\n")
    -- print(vim.inspect(lines))
    --
    -- -- set content
    -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
end

local function get_ai_suggestion(filename)
    local command = [[
    curl https://api.openai.com/v1/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer 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" \
      -d '{
      "model": "text-davinci-003",
      "prompt": "$(cat ]] .. filename .. [[)",
      "temperature": 0.7,
      "max_tokens": 0521,
      "top_p": 1,
      "best_of": 3,
      "frequency_penalty": 0,
      "presence_penalty": 0
    }' | jq '.choices[0].text'
    ]]
    print(vim.inspect(command))
    local on_stdout = function(_, output)
        print('success')
        print(vim.inspect(output))
    end
    local on_stderr = function(_, output)
        if output == nil or #output == 1 then return end
        vim.notify("Error while executing file." .. output, vim.log.levels.WARN,
                   {title = "TEST error"})
    end
    vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = on_stdout,
        on_stderr = on_stderr
    })
end

M.finish_file = function()
    local file_path = vim.api.nvim_buf_get_name(0)
    local sugg = get_ai_suggestion(file_path)
end

return M

-- /* Write a neovim lua function that implements openai complete rest api in an async manner. it takes no arguments and uses the current buffer content as the prompt */
--
-- -- Connect to OpenAI
-- local resty_http = require "resty.http"
-- local http = resty_http.new()
--
-- local function openai_complete()
--   -- Get the prompt from the current buffer
--   local prompt = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--   prompt = table.concat(prompt, '\n')
--   local request_url = "https://api.openai.com/v1/engines/davinci/completions"
--
--   local req_body = {
--     prompt = prompt,
--     max_tokens = 100
--   }
--
--   local headers = {
--     ["Content-Type"] = "application/json"
--   }
--
--   local res = http:request_uri( request_url, {
--     ssl_verify = false,
--     body = req_body,
--     method = "POST",
--     headers = headers
--   } )
--
--   if (res.status ~= 200) then
--     print("OpenAI request failed, status: " .. res.status)
--     return
--   end
--
--   local response_body = res:read_body()
--   local response = json.decode(response_body)
--   local matches = response['choices']
--   for _, match in pairs(matches) do
--     print(match['text'])
--   end
-- end
--
-- -- Expose the lua function to neovim
-- vim.cmd([[
--   command! OpenAIComplete lua openai_complete()
-- ]])
