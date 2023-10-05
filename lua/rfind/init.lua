local math = require("math")
local function is_visual_mode_p()
  local mode = vim.fn.mode()
  return ((mode == "v") or (mode == "V") or (mode == "\\<C-v>"))
end
local function get_visual_start_line_num()
  if is_visual_mode_p() then
    return vim.fn.line(".")
  else
    return vim.fn.line("'<")
  end
end
local function get_visual_end_line_num()
  if is_visual_mode_p() then
    return vim.fn.line("v")
  else
    return vim.fn.line("'>")
  end
end
local function get_find_command(start_pos, end_pos)
  return string.format("/\\%%>%dl\\%%<%dl", (start_pos - 1), (end_pos + 1))
end
local function get_feedkeys(start_pos, end_pos)
  return string.format("%s%s", vim.api.nvim_replace_termcodes("<esc>", true, false, true), get_find_command(start_pos, end_pos))
end
local function find_in_range(start_pos, end_pos)
  return vim.api.nvim_feedkeys(get_feedkeys(start_pos, end_pos), "ni", false)
end
local function find_in_visual()
  local start_pos = get_visual_start_line_num()
  local end_pos = get_visual_end_line_num()
  return find_in_range(math.min(start_pos, end_pos), math.max(start_pos, end_pos))
end
return {visual = find_in_visual, range = find_in_range}
