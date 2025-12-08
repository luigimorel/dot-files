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
-- Show git blame info for the current line (no plugins)
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    local file = vim.fn.expand("%:p")
    if vim.fn.filereadable(file) == 0 then return end

    local line = vim.fn.line(".")
    local cmd = string.format("git blame -L %d,%d --porcelain -- %s | head -n 1", line, line, vim.fn.shellescape(file))
    local blame = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 or blame == "" then
      vim.api.nvim_echo({ { "Not committed yet", "Comment" } }, false, {})
      return
    end

    local commit = blame:match("^(%S+)")
    local info = vim.fn.system(string.format("git show -s --format='%%an, %%ar, %%s' %s", commit))
    info = info:gsub("\n", "")
    vim.api.nvim_echo({ { info, "Comment" } }, false, {})
  end,
})

-- Inline git blame for the current line (no plugins)
local ns_id = vim.api.nvim_create_namespace("inline_git_blame")

local function show_blame()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  local file = vim.fn.expand("%:p")
  if vim.fn.filereadable(file) == 0 then return end

  local line = vim.fn.line(".")
  local cmd = string.format("git blame -L %d,%d --porcelain -- %s | head -n 1", line, line, vim.fn.shellescape(file))
  local blame = vim.fn.system(cmd)

  -- If not committed yet (untracked or staged file)
  if vim.v.shell_error ~= 0 or blame == "" then
    vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, -1, {
      virt_text = { { "  Uncommitted", "WarningMsg" } },
      virt_text_pos = "eol",
    })
    return
  end

  local commit = blame:match("^(%S+)")
  -- if not commit or commit == "0000000000000000000000000000000000000000" then
  --   vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, -1, {
  --     virt_text = { { "  Uncommitted", "WarningMsg" } },
  --     virt_text_pos = "eol",
  --   })
  --   return
  -- end
  --
  -- Get commit details
  local info = vim.fn.system(string.format("git show -s --format='%%an • %%ar • %%s' %s", commit))
  info = info:gsub("\n", "")
  if info == "" then
    vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, -1, {
      virt_text = { { "  Uncommitted", "WarningMsg" } },
      virt_text_pos = "eol",
    })
    return
  end

  -- Show inline blame
  vim.api.nvim_buf_set_extmark(0, ns_id, line - 1, -1, {
    virt_text = { { "  " .. info, "Comment" } },
    virt_text_pos = "eol",
  })
end

-- Auto-update blame when cursor stops
vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter" }, {
  pattern = "*",
  callback = show_blame,
})

-- Clear when moving cursor
vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end,
})

-- Optional: reduce CursorHold delay
vim.o.updatetime = 800


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
  group    = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern  = "*",
  desc     = "Highlight yanked text",
  callback = function()
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
