-- dbt navigation: <C-]> on `ref('model_name')` (or "model_name") jumps to the
-- matching model_name.sql file in the git repo. <C-t> returns via the native
-- tag stack. If multiple files match, choose via Telescope.

vim.keymap.set("n", "<C-]>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed

  local model
  local search_from = 1
  while true do
    local s, e, m = line:find([[ref%(['"]([%w_%-]+)['"]%)]], search_from)
    if not s then
      break
    end
    if col >= s and col <= e then
      model = m
      break
    end
    search_from = e + 1
  end

  if not model then
    return
  end

  local jump = require("dots.jump")
  local git_root = jump.git_root()
  if not git_root then
    vim.notify("Not in a git repo", vim.log.levels.WARN)
    return
  end

  local all_sql = vim.fn.systemlist({ "git", "-C", git_root, "ls-files", "*.sql" })
  if vim.v.shell_error ~= 0 then
    all_sql = {}
  end

  local target = vim.pesc(model) .. "%.sql$"
  local matches = {}
  for _, f in ipairs(all_sql) do
    if f:match("/" .. target) or f:match("^" .. target) then
      table.insert(matches, git_root .. "/" .. f)
    end
  end

  jump.pick(matches, model, "dbt model: " .. model)
end, { buffer = true, desc = "Jump to dbt model from ref()" })
