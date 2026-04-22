vim.opt_local.formatoptions = "oqn1" -- Check out 'fo-table' to see what this does.
vim.opt_local.spell = true

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
