-- 1. Define your custom color palette (feel free to change these hex codes!)
local colors = {
  bg        = "#1e222a", -- Dark background matching NvChad
  active_bg = "#282c34", -- Slightly lighter background for active sections
  fg        = "#abb2bf", -- Soft white/gray text
  gray      = "#3e4452", -- Muted gray divider sections
  blue      = "#61afef", -- Normal Mode / Path accent
  green     = "#98c379", -- Insert Mode accent
  purple    = "#c678dd", -- Visual Mode accent
  red       = "#e06c75", -- Diagnostics / Replace Mode accent
  orange    = "#d19a66", -- Warning / Progress accent
}

-- 2. Create the mode-by-mode theme mapping
local custom_theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
    b = { fg = colors.fg, bg = colors.gray },
    c = { fg = colors.fg, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.red, gui = "bold" },
  },
  command = {
    a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
  },
  inactive = {
    a = { fg = colors.gray, bg = colors.bg },
    b = { fg = colors.gray, bg = colors.bg },
    c = { fg = colors.gray, bg = colors.bg },
  },
}

local M = {
  options = {
    theme = custom_theme, -- Apply your custom color theme here
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },

    lualine_c = {
      {
        function()
          local fname = vim.fn.expand("%:t")
          if fname == "" then
            fname = "[No Name]"
          end

          if vim.bo.modified then
            fname = fname .. " ●"
          end

          if vim.bo.readonly or not vim.bo.modifiable then
            fname = fname .. " "
          end

          local time = os.date("%H:%M")
          return string.format("%s    %s", fname, time)
        end,
        color = { fg = colors.blue, gui = "bold" },
      }
    },

    lualine_x = { 'fileformat', 'filetype' },
    lualine_y = { 'progress' },

    lualine_z = {
      -- File directory path
      {
        function()
          local path = vim.fn.expand("%:.:h")
          return path ~= "" and path or "[No Name]"
        end,
        color = { fg = colors.fg, bg = colors.gray },
      },
      -- NvChad-style cursor line/total lines position indicator
      {
        function()
          local current_line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          local col = vim.fn.col(".")
          return string.format(" %d/%d : %d", current_line, total_lines, col)
        end,
        color = { fg = colors.bg, bg = colors.blue, gui = "bold" },
      },
    },
  },
}

return M
