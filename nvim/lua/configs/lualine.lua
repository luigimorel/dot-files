local M = {}

local M = {
  options = {
    theme = "auto",
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },

    lualine_c = {
      {
        function()
          return " " .. os.date("%H:%M")
        end,
      }
    },

    lualine_x = { 'fileformat', 'filetype' },
    lualine_y = { 'progress' },

    lualine_z = {
      function()
        local path = vim.fn.expand("%:.:h")
        return path ~= "" and path or "[No Name]"
      end,
      function()
        return os.date("%H:%M")
      end,
    },
  },
}

return M
