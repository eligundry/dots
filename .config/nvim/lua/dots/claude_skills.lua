-- nvim-cmp source for Claude Code slash commands / skills.
--
-- Surfaces entries from:
--   * ~/.claude/commands/*.md                                (user commands)
--   * ~/.claude/skills/<skill>/SKILL.md                      (user skills)
--   * ~/.agents/skills/<skill>/SKILL.md                      (user agent skills)
--   * installed plugins listed in ~/.claude/plugins/installed_plugins.json
--     (their commands/, skills/, and .agents/skills/ subdirs, namespaced as
--     `plugin:name`)
--   * ./.claude/commands, ./.claude/skills, and ./.agents/skills under the cwd
--     (project scope)
--
-- Triggers on "/" at the start of a line or after whitespace.

local M = {}

local source = {}

local CACHE_TTL_MS = 5000
local cache = { entries = nil, ts = 0 }

local function read_file(path)
  local fd = vim.loop.fs_open(path, "r", 438)
  if not fd then
    return nil
  end
  local stat = vim.loop.fs_fstat(fd)
  if not stat then
    vim.loop.fs_close(fd)
    return nil
  end
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)
  return data
end

local function parse_frontmatter(content)
  if not content or not content:match("^%-%-%-") then
    return nil
  end
  local _, fm_end = content:find("\n%-%-%-\n", 4, false)
  if not fm_end then
    return nil
  end
  local fm = content:sub(4, fm_end - 4)
  local fields = {}
  local key, buf
  for line in (fm .. "\n"):gmatch("([^\n]*)\n") do
    local k, v = line:match("^(%w[%w_%-]*):%s*(.*)$")
    if k then
      if key and buf then
        fields[key] = vim.trim(buf)
      end
      key = k
      buf = v
    elseif key and line:match("^%s+") then
      buf = (buf or "") .. " " .. vim.trim(line)
    end
  end
  if key and buf then
    fields[key] = vim.trim(buf)
  end
  return fields
end

local function first_nonempty_line(content)
  for line in (content or ""):gmatch("[^\n]+") do
    local trimmed = vim.trim(line)
    if trimmed ~= "" then
      return trimmed:gsub("^#+%s*", "")
    end
  end
  return ""
end

local function scan_dir(path)
  local entries = {}
  local handle = vim.loop.fs_scandir(path)
  if not handle then
    return entries
  end
  while true do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    entries[#entries + 1] = { name = name, type = t }
  end
  return entries
end

local function detail_for(scope, kind, namespace)
  if namespace then
    return "plugin " .. kind .. " — " .. namespace
  end
  return scope .. " " .. kind
end

local function collect_commands(dir, namespace, scope, out)
  for _, e in ipairs(scan_dir(dir)) do
    if e.type == "file" and e.name:match("%.md$") then
      local cmd_name = e.name:sub(1, -4)
      local label = namespace and (namespace .. ":" .. cmd_name) or cmd_name
      local file_path = dir .. "/" .. e.name
      local content = read_file(file_path) or ""
      local desc = first_nonempty_line(content)
      out[#out + 1] = {
        label = "/" .. label,
        insert = "/" .. label,
        detail = detail_for(scope, "command", namespace),
        doc = desc,
        path = file_path,
      }
    end
  end
end

local function collect_skills(dir, namespace, scope, out)
  for _, e in ipairs(scan_dir(dir)) do
    if e.type == "directory" then
      local skill_path = dir .. "/" .. e.name .. "/SKILL.md"
      local content = read_file(skill_path)
      if content then
        local fm = parse_frontmatter(content) or {}
        local skill_name = fm.name or e.name
        local label = namespace and (namespace .. ":" .. skill_name) or skill_name
        out[#out + 1] = {
          label = "/" .. label,
          insert = "/" .. label,
          detail = detail_for(scope, "skill", namespace),
          doc = fm.description or "",
          path = skill_path,
        }
      end
    end
  end
end

local function installed_plugin_paths()
  local paths = {}
  local json_path = vim.fn.expand("~/.claude/plugins/installed_plugins.json")
  local content = read_file(json_path)
  if not content then
    return paths
  end
  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" or type(decoded.plugins) ~= "table" then
    return paths
  end
  for key, installs in pairs(decoded.plugins) do
    local plugin_name = key:match("^([^@]+)") or key
    if type(installs) == "table" then
      for _, install in ipairs(installs) do
        if type(install) == "table" and install.installPath then
          paths[#paths + 1] = { name = plugin_name, path = install.installPath }
        end
      end
    end
  end
  return paths
end

local function build_entries()
  local home = vim.fn.expand("~")
  local out = {}

  collect_commands(home .. "/.claude/commands", nil, "user", out)
  collect_skills(home .. "/.claude/skills", nil, "user", out)
  collect_skills(home .. "/.agents/skills", nil, "user", out)

  for _, plugin in ipairs(installed_plugin_paths()) do
    collect_commands(plugin.path .. "/commands", plugin.name, "plugin", out)
    collect_skills(plugin.path .. "/skills", plugin.name, "plugin", out)
    collect_skills(plugin.path .. "/.agents/skills", plugin.name, "plugin", out)
  end

  local cwd = vim.loop.cwd()
  if cwd and cwd ~= home then
    collect_commands(cwd .. "/.claude/commands", nil, "repo", out)
    collect_skills(cwd .. "/.claude/skills", nil, "repo", out)
    collect_skills(cwd .. "/.agents/skills", nil, "repo", out)
  end

  table.sort(out, function(a, b)
    return a.label < b.label
  end)

  local seen = {}
  local entries = {}
  for _, e in ipairs(out) do
    if not seen[e.label] then
      seen[e.label] = true
      entries[#entries + 1] = e
    end
  end
  return entries
end

local function get_entries()
  local now = vim.loop.now()
  if cache.entries and (now - cache.ts) < CACHE_TTL_MS then
    return cache.entries
  end
  cache.entries = build_entries()
  cache.ts = now
  return cache.entries
end

local function get_items()
  local items = {}
  for _, e in ipairs(get_entries()) do
    items[#items + 1] = {
      label = e.label,
      filterText = e.label,
      insertText = e.insert,
      kind = require("cmp").lsp.CompletionItemKind.Function,
      detail = e.detail,
      documentation = e.doc and e.doc ~= "" and { kind = "markdown", value = e.doc } or nil,
    }
  end
  return items
end

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_trigger_characters()
  return { "/" }
end

function source:get_keyword_pattern()
  return [[/\k*]]
end

function source:is_available()
  return vim.bo.filetype == "markdown"
end

function source:complete(params, callback)
  local line = params.context.cursor_before_line or ""
  if not line:match("/[%w%-:_]*$") then
    callback({ items = {}, isIncomplete = false })
    return
  end
  local before_slash = line:sub(1, line:find("/[^/]*$") - 1)
  if before_slash ~= "" and not before_slash:match("%s$") then
    callback({ items = {}, isIncomplete = false })
    return
  end
  callback({ items = get_items(), isIncomplete = false })
end

function M.setup()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    return
  end
  cmp.register_source("claude_skills", source.new())
end

function M.refresh()
  cache.entries = nil
  cache.ts = 0
end

-- Resolve a `/skill` token (with or without the leading slash) to the
-- absolute path of its definition file, or nil if unknown.
function M.resolve(name)
  if not name or name == "" then
    return nil
  end
  local stripped = name:gsub("^/", "")
  local target = "/" .. stripped
  for _, e in ipairs(get_entries()) do
    if e.label == target then
      return e.path
    end
  end
  return nil
end

return M
