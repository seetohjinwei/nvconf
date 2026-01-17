vim.cmd([[
  highlight StatusNormal  guibg=#89b4fa guifg=#11111b gui=bold
  highlight StatusInsert  guibg=#a6e3a1 guifg=#11111b gui=bold
  highlight StatusVisual  guibg=#f9e2af guifg=#11111b gui=bold
  highlight StatusReplace guibg=#f38ba8 guifg=#11111b gui=bold
  highlight StatusCmd     guibg=#cba6f7 guifg=#11111b gui=bold
  highlight StatusTerm    guibg=#94e2d5 guifg=#11111b gui=bold
]])

local mode_map = {
    ['n']     = 'NORMAL',
    ['no']    = 'O-PENDING',
    ['nov']   = 'O-PENDING',
    ['noV']   = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI']   = 'NORMAL',
    ['niR']   = 'NORMAL',
    ['niV']   = 'NORMAL',
    ['v']     = 'VISUAL',
    ['vs']    = 'VISUAL',
    ['V']     = 'V-LINE',
    ['Vs']    = 'V-LINE',
    ['\22']   = 'V-BLOCK',
    ['\22s']  = 'V-BLOCK',
    ['s']     = 'SELECT',
    ['S']     = 'S-LINE',
    ['\19']   = 'S-BLOCK',
    ['i']     = 'INSERT',
    ['ic']    = 'INSERT',
    ['ix']    = 'INSERT',
    ['R']     = 'REPLACE',
    ['Rc']    = 'REPLACE',
    ['Rx']    = 'REPLACE',
    ['Rv']    = 'V-REPLACE',
    ['Rvc']   = 'V-REPLACE',
    ['Rvx']   = 'V-REPLACE',
    ['c']     = 'COMMAND',
    ['cv']    = 'EX',
    ['ce']    = 'EX',
    ['r']     = 'REPLACE',
    ['rm']    = 'MORE',
    ['r?']    = 'CONFIRM',
    ['!']     = 'SHELL',
    ['t']     = 'TERMINAL',
}

local mode_hl_map = {
    ['n']   = '%#StatusNormal#',
    ['i']   = '%#StatusInsert#',
    ['v']   = '%#StatusVisual#',
    ['V']   = '%#StatusVisual#',
    ['\22'] = '%#StatusVisual#',
    ['R']   = '%#StatusReplace#',
    ['c']   = '%#StatusCmd#',
    ['t']   = '%#StatusTerm#',
}

local function get_mode()
    local m = vim.api.nvim_get_mode().mode
    local label = mode_map[m] or m

    -- Get the highlight group, defaulting to Normal if not found
    local hl = mode_hl_map[m] or mode_hl_map[m:sub(1, 1)] or '%#StatusNormal#'

    -- %* resets the highlight to the standard statusline color for the rest of the line
    return string.format("%s %s %%*", hl, label)
end

vim.cmd([[
  highlight StatusGitBranch guifg=#cba6f7 gui=bold
  highlight StatusGitAdd    guifg=#a6e3a1
  highlight StatusGitMod    guifg=#f9e2af
  highlight StatusGitDel    guifg=#f38ba8
]])

local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then
        return ""
    end

    -- Branch name with icon
    local parts = {
        "%#StatusGitBranch#  ", git_info.head, " "
    }

    -- Add stats only if they are greater than 0
    if (git_info.added or 0) > 0 then
        table.insert(parts, "%#StatusGitAdd#+" .. git_info.added .. " ")
    end
    if (git_info.changed or 0) > 0 then
        table.insert(parts, "%#StatusGitMod#~" .. git_info.changed .. " ")
    end
    if (git_info.removed or 0) > 0 then
        table.insert(parts, "%#StatusGitDel#-" .. git_info.removed .. " ")
    end

    -- Reset highlight at the end
    table.insert(parts, "%*")

    return table.concat(parts)
end

-- Diagnostics
vim.cmd([[
  highlight StatusErr guifg=#f38ba8 gui=bold
  highlight StatusWarn guifg=#f9e2af
  highlight StatusInfo guifg=#89b4fa
  highlight StatusHint guifg=#94e2d5
]])

-- Right Side (Filetype & Stats)
vim.cmd([[
  highlight StatusRightMain guibg=#313244 guifg=#cdd6f4
  highlight StatusRightDim  guibg=#313244 guifg=#7f849c
  highlight StatusPos       guibg=#45475a guifg=#cdd6f4
]])

local function diagnostics()
    local count = vim.diagnostic.count(0) -- Efficiently get counts for current buffer
    local parts = {}

    local signs = {
        { count[vim.diagnostic.severity.ERROR] or 0, "%#StatusErr# ", " " },
        { count[vim.diagnostic.severity.WARN] or 0, "%#StatusWarn# ", " " },
        { count[vim.diagnostic.severity.INFO] or 0, "%#StatusInfo# ", " " },
        { count[vim.diagnostic.severity.HINT] or 0, "%#StatusHint#󰌵 ", "" },
    }

    for _, sign in ipairs(signs) do
        if sign[1] > 0 then
            table.insert(parts, sign[2] .. sign[1] .. sign[3])
        end
    end

    return #parts > 0 and table.concat(parts) .. "%*" or ""
end

Statusline = {}

function Statusline.active()
    return table.concat {
        get_mode(),
        " ",
        git(),                     -- Git Info
        diagnostics(),             -- LSP Diagnostics
        " %f ",                     -- Filename
        "%=",                      -- Spacer
        -- Right Side Starts Here
        "%#StatusRightMain# %y ",  -- Filetype (e.g. LUA)
        "%#StatusRightDim# %p%% ", -- Percentage with a thin separator
        "%#StatusRightMain#",      -- Powerline transition
        "%#StatusNormal# %l:%c ",  -- Line:Col (reusing Normal mode color)
        "%*"
    }
end

function Statusline.inactive()
    return " %t"
end

local group = vim.api.nvim_create_augroup("Statusline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    desc = "Activate statusline on focus",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    desc = "Deactivate statusline when unfocused",
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end,
})
