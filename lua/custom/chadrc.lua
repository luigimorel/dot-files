local M = {}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "round",
    overriden_modules = function()
      return require "lua.configs.lualine"
    end,
  },
}

return M
