local M = {}

local function oil_title(name)
  local path = name:gsub("^oil://", ""):gsub("/+$", "")
  if path == "" then
    return "[Oil] /"
  end

  local base = path:match("([^/]+)$")
  if base == nil or base == "" then
    return "[Oil] /"
  end

  return "[Oil] " .. base
end

local function statusline()
  local fileencoding = vim.bo.fileencoding ~= "" and ("[" .. vim.bo.fileencoding .. "]") or ""
  return table.concat({
    "#" .. vim.fn.winnr() .. " %<%f%m%r%h%w  %=",
    fileencoding,
    "%y",
    "[%l/%L,%c]",
  })
end

local function tab_label(tabnr, last)
  local s = ""
  local buflist = vim.fn.tabpagebuflist(tabnr)
  local current_win = vim.fn.tabpagewinnr(tabnr)
  local buf = buflist[current_win] or 0

  s = s .. "%" .. tabnr .. "T"
  s = s .. (tabnr == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#")
  s = s .. "#" .. tabnr .. " "

  local name = vim.fn.bufname(buf)
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  if filetype == "oil" or name:match("^oil://") then
    s = s .. oil_title(name)
  elseif name == "" then
    s = s .. "[New]"
  elseif buftype == "help" then
    s = s .. "[Help] " .. vim.fn.fnamemodify(name, ":t:r")
  elseif buftype == "quickfix" then
    s = s .. "[Quickfix]"
  else
    s = s .. vim.fn.fnamemodify(name, ":t")
  end

  local modified = 0
  local seen = {}
  for _, b in ipairs(buflist) do
    if not seen[b] then
      seen[b] = true
      if vim.bo[b].modified then
        modified = modified + 1
      end
    end
  end
  if modified > 0 then
    s = s .. " [" .. modified .. "+]"
  end

  s = s .. "%#TabLineFill#"
  if tabnr ~= last then
    s = s .. " | "
  end

  return s
end

local function tabline()
  local s = " "
  local last = vim.fn.tabpagenr("$")
  for tabnr = 1, last do
    s = s .. tab_label(tabnr, last)
  end

  s = s .. "%#TabLineFill#%T"

  local session = vim.v.this_session
  if session ~= "" then
    session = vim.fn.fnamemodify(session, ":t")
    session = session:gsub("%.session%.vim$", ""):gsub("%.vim$", "")
    s = s .. "%=%#TabLineSel#[" .. session .. "]"
  end

  return s
end

function M.setup()
  _G._custom_statusline = statusline
  _G._custom_tabline = tabline

  vim.opt.laststatus = 2
  vim.opt.showtabline = 2
  vim.opt.statusline = "%!v:lua._custom_statusline()"
  vim.opt.tabline = "%!v:lua._custom_tabline()"
end

return M
