vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Custom keybindings
-- Keymap to open Telescope file finder with <space>e
vim.keymap.set("n", "<leader>e", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

vim.keymap.set("i", "<C-a>", 'copilot#Accept("")', {
  expr = true,
  silent = true,
  replace_keycodes = false,
  noremap = true,
})

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
-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)

      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- Git blame always enabled for git commit messages
vim.api.nvim_create_autocmd("FileType", {

  pattern = "gitcommit",
  callback = function()
    vim.b.gitsigns_blame_enabled = 1
  end,
})



-- Syntax highlighting for .env files
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("env_syntax", { clear = true }),
  pattern = ".env*",
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})


-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group       = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern     = "*",
  description = "Highlight yanked text",
  callback    = function()
    vim.highlight.on_yank { timeout = 200, visual = true, higroup = "IncSearch" }
  end
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
