-- Highlights `/skill` and `/plugin:skill` tokens in markdown buffers in blue.
--
-- Uses treesitter to identify code-ish ranges (fenced/indented code blocks,
-- inline code spans, link destinations, html) and skips matches inside them.
-- Only highlights tokens that resolve to a real installed skill/command via
-- `dots.claude_skills.resolve`.

local M = {}

local ns = vim.api.nvim_create_namespace("dots.claude_skills_hl")
local HL_GROUP = "DotsClaudeSkill"

vim.api.nvim_set_hl(0, HL_GROUP, { link = "Function", default = true })

local EXCLUDE_TYPES = {
  code_span = true,
  fenced_code_block = true,
  indented_code_block = true,
  code_fence_content = true,
  html_block = true,
  link_destination = true,
}

local function collect_excluded(bufnr)
  local excluded = {}
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok or not parser then
    return excluded
  end
  parser:parse()

  local function walk_node(node)
    if EXCLUDE_TYPES[node:type()] then
      local sr, sc, er, ec = node:range()
      excluded[#excluded + 1] = { sr, sc, er, ec }
      return
    end
    for child in node:iter_children() do
      walk_node(child)
    end
  end

  local function walk_ltree(ltree)
    ltree:for_each_tree(function(tree)
      walk_node(tree:root())
    end)
    for _, child in pairs(ltree:children()) do
      walk_ltree(child)
    end
  end

  walk_ltree(parser)
  return excluded
end

local function pos_in_excluded(row, col, excluded)
  for _, r in ipairs(excluded) do
    local sr, sc, er, ec = r[1], r[2], r[3], r[4]
    if row > sr and row < er then
      return true
    end
    if row == sr and row == er then
      if col >= sc and col < ec then
        return true
      end
    elseif row == sr then
      if col >= sc then
        return true
      end
    elseif row == er then
      if col < ec then
        return true
      end
    end
  end
  return false
end

function M.highlight(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local resolve = require("dots.claude_skills").resolve
  local excluded = collect_excluded(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    local row = i - 1
    local pos = 1
    while pos <= #line do
      local s, e = line:find("/[%w][%w%-:_]*", pos)
      if not s then
        break
      end
      local prev = s == 1 and "" or line:sub(s - 1, s - 1)
      local boundary = prev == "" or not prev:match("[%w_%-/:]")
      if boundary and not pos_in_excluded(row, s - 1, excluded) then
        local token = line:sub(s, e)
        if resolve(token) then
          vim.api.nvim_buf_set_extmark(bufnr, ns, row, s - 1, {
            end_row = row,
            end_col = e,
            hl_group = HL_GROUP,
            priority = 200,
          })
        end
      end
      pos = e + 1
    end
  end
end

function M.attach(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local group = vim.api.nvim_create_augroup("DotsClaudeSkillsHL_" .. bufnr, { clear = true })
  M.highlight(bufnr)
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
    group = group,
    buffer = bufnr,
    callback = function()
      M.highlight(bufnr)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = bufnr,
    callback = function()
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })
end

return M
