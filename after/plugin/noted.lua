local api = vim.api
local cmd = vim.cmd
local uv = vim.loop

local root_dir =  vim.fn.stdpath("config") .. "/noted/"

local function safe_create_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    uv.fs_mkdir(dir, 511, function() end)
  end
end

local function safe_create_file(filepath)
  local normalized_filepath = vim.fs.normalize(filepath)
  if vim.fn.filereadable(normalized_filepath) ~= 0 then
    return
  end
  -- create directory + subdirectories as needed
  local path, file = filepath:match("^(.-)([^\\/]-)$")
  os.execute("mkdir -p " .. path)
end

function noted_global()
  safe_create_dir(root_dir)

  cmd.edit(root_dir .. "global.md")
end

function noted_todo()
  safe_create_dir(root_dir)

  cmd.edit(root_dir .. "todo.md")
end

function noted_project()
  safe_create_dir(root_dir)

  local cwd = vim.fn.getcwd()
  local translated_cwd = cwd:gsub("/", "-")

  cmd.edit(root_dir .. translated_cwd .. ".md")
end

-- Global Notes
api.nvim_create_user_command("NotedGlobal", noted_global, {})
-- Global Todo
api.nvim_create_user_command("NotedTodo", noted_todo, {})
-- Project Notes
api.nvim_create_user_command("NotedProject", noted_project, {})
-- api.nvim_create_user_command("NotedTest", function()
-- end, {})
