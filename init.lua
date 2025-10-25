vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Custom keybindings
-- Keymap to open Telescope file finder with <space>e
vim.keymap.set("n", "<leader>e", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

--  Open current file directory in nvim-tree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Only open NvimTree if starting with a directory
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      require("nvim-tree.api").tree.open()
    end
  end,
})

vim.opt.textwidth = 120

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    import = "plugins",
  },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
