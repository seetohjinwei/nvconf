local api = vim.api

-- Reference:
-- https://vim.fandom.com/wiki/Maximize_window_and_return_to_previous_split_structure
--
-- Notes:
-- Assumes that the user does not use the tabs system (much)!

local temp_focus_key = "temp_focus_key_"
local is_focused = temp_focus_key .. "is_focused"
local showtabline = temp_focus_key .. "showtabline"

vim.g[is_focused] = false
vim.g[showtabline] = 0

local function toggle_focus()
    if vim.g[is_focused] then
        local num_of_tabs = vim.fn.tabpagenr()
        if num_of_tabs == 1 then
            -- safety check to ensure that the last tab isn't closed
            -- it will be a no-op, and fix the variable status
            -- assumes that the user doesn't use tabs
            vim.g[is_focused] = false
            return
        end

        local curpos = vim.fn.getcurpos()
        vim.cmd [[ tabclose ]]
        vim.fn.setpos(".", curpos)
        vim.g[is_focused] = false
        vim.opt.showtabline = vim.g[showtabline] -- Restore the previous value
    else
        -- splits current window into a new tab, while maintaining cursor position
        vim.cmd [[ tab sp ]]
        vim.g[is_focused] = true
        vim.g[showtabline] = vim.opt.showtabline:get() -- Save the previous value
        vim.opt.showtabline = 0
    end
end

api.nvim_create_user_command("FocusPaneToggle", toggle_focus, {})
