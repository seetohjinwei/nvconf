-- Opens the scratch buffer.
--
-- Scratch buffer only exists within a single neovim session.
--
-- If the scratch buffer is created for the first time, it will inherit the filetype from the current buffer.
-- To change the filetype, use `:set ft=markdown`.

local scratch_key = "scratch_key"
local prev_buf = scratch_key .. "prev_buf"
vim.g[prev_buf] = -1

local function toggle_scratch()
    local current_buf = vim.api.nvim_get_current_buf()

    -- Re-use scratch buffer if it already exists
    local existing_buf = vim.fn.bufnr("scratch")
    if existing_buf ~= -1 then
        if current_buf == existing_buf and vim.g[prev_buf] ~= -1 then
            -- Switch to the prev buffer
            vim.api.nvim_set_current_buf(vim.g[prev_buf])
            vim.g[prev_buf] = -1
            return
        end

        -- Switch to the scratch buffer
        vim.api.nvim_set_current_buf(existing_buf)
        vim.g[prev_buf] = current_buf
        return
    end

    -- Create the scratch buffer
    -- true: listed (makes it visible to :ls and :e#)
    -- true: scratch (sets buftype=nofile, bufhidden=hide, noswapfile)
    local buf = vim.api.nvim_create_buf(true, true)

    -- Set the name to "scratch" for jumping to it via :b scratch or :e#
    vim.api.nvim_buf_set_name(buf, "scratch")

    -- Inherit filetype from current buffer
    vim.bo[buf].filetype = vim.bo[current_buf].filetype

    -- Switch to the new buffer
    vim.api.nvim_set_current_buf(buf)
    vim.g[prev_buf] = current_buf
end

vim.api.nvim_create_user_command("ScratchToggle", toggle_scratch, {})


-- TODO: The swap-back doesn't work well when used in the Oil.nvim buffer because that buffer doesn't exist after it's closed
-- The swap-back is also a bit finnicky if it's spammed too much
