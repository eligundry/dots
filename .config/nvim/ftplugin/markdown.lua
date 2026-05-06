vim.opt_local.formatoptions = "oqn1" -- Check out 'fo-table' to see what this does.
vim.opt_local.spell = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

vim.keymap.set("i", "@@", function()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- @@ is intercepted by the mapping and never inserted into the buffer,
  -- so just capture the current cursor position for later insertion.
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local insert_col = cursor[2]
  local selected = false

  local function insert_text_and_resume(text)
    local lnum = row - 1
    vim.api.nvim_buf_set_text(0, lnum, insert_col, lnum, insert_col, { text })
    local new_col = insert_col + #text
    if new_col >= #vim.api.nvim_get_current_line() then
      vim.cmd("startinsert!")
    else
      vim.api.nvim_win_set_cursor(0, { row, new_col })
      vim.cmd("startinsert")
    end
  end

  local function restore_and_insert()
    vim.schedule(function()
      if not selected then
        insert_text_and_resume("@@")
      end
    end)
  end

  builtin.find_files({
    prompt_title = "Insert @file reference",
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry then
          selected = true
          local path = entry[1]
          insert_text_and_resume("@" .. path)
        end
      end)

      actions.close:enhance({
        post = restore_and_insert,
      })

      return true
    end,
  })
end, { buffer = true, desc = "Insert @file reference via Telescope" })

vim.keymap.set("n", "<C-]>", function()
  local function backtick_content_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed
    local search_from = 1
    while true do
      local s, e, content = line:find("`([^`]+)`", search_from)
      if not s then
        return nil
      end
      if col >= s and col <= e then
        return content
      end
      search_from = e + 1
    end
  end

  local path
  local word = vim.fn.expand("<cWORD>")
  local at_match = word:match("^@(.+)")
  if at_match then
    path = at_match:gsub("[%.,;:%)%]>]+$", "")
  else
    path = backtick_content_under_cursor()
  end
  if not path or path == "" then
    return
  end

  local jump = require("dots.jump")
  local file_dir = vim.fn.expand("%:p:h")
  local git_root = jump.git_root(file_dir)

  local candidates = {
    path,
    file_dir .. "/" .. path,
    git_root and (git_root .. "/" .. path) or nil,
    vim.fn.getcwd() .. "/" .. path,
    vim.fn.expand("~/") .. path,
  }
  for _, p in ipairs(candidates) do
    if p and (vim.fn.filereadable(p) == 1 or vim.fn.isdirectory(p) == 1) then
      jump.open(p, path)
      return
    end
  end
  vim.notify("File not found: " .. path, vim.log.levels.WARN)
end, { buffer = true, desc = "Open @path or `path` file reference" })
