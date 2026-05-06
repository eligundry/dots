-- Helpers for jumping to a target file via the native tag stack so that
-- <C-t> returns to the original location.

local M = {}

local function push_tag(tagname)
  local from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 }
  vim.fn.settagstack(vim.fn.win_getid(), {
    items = { { tagname = tagname, from = from } },
  }, "a")
end

function M.open(path, tagname)
  push_tag(tagname or path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

function M.pick(paths, tagname, prompt_title)
  if #paths == 0 then
    vim.notify("No matches for: " .. tagname, vim.log.levels.WARN)
    return
  end
  if #paths == 1 then
    M.open(paths[1], tagname)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = prompt_title or ("Select file for " .. tagname),
      finder = finders.new_table({ results = paths }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            M.open(entry[1], tagname)
          end
        end)
        return true
      end,
    })
    :find()
end

function M.git_root(from_dir)
  local root = vim.fn.systemlist({
    "git",
    "-C",
    from_dir or vim.fn.expand("%:p:h"),
    "rev-parse",
    "--show-toplevel",
  })[1]
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return root
end

return M
