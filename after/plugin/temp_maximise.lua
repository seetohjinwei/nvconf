local api = vim.api

-- Reference:
-- https://vim.fandom.com/wiki/Maximize_window_and_return_to_previous_split_structure
--
-- Notes:
-- Assumes that the user does not use the tabs system (much)!

local temp_maximise_key = "temp_maximise_key_"
local is_maximised = temp_maximise_key .. "is_maximised"

vim.g[is_maximised] = false

local function toggle_maximise()
  if vim.g[is_maximised] then
    local num_of_tabs = vim.fn.tabpagenr()
    if num_of_tabs == 1 then
      -- safety check to ensure that the last tab isn't closed
      -- it will be a no-op, and fix the variable status
      -- assumes that the user doesn't use tabs
      vim.g[is_maximised] = false
      return
    end

    local curpos = vim.fn.getcurpos()
    vim.cmd [[ tabclose ]]
    vim.fn.setpos(".", curpos)
    vim.g[is_maximised] = false
  else
    -- splits current window into a new tab, while maintaining cursor position
    vim.cmd [[ tab sp ]]
    vim.g[is_maximised] = true
  end
end

api.nvim_create_user_command("TempMaximiseToggle", toggle_maximise, {})
