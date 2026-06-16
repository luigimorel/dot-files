local scrollbar = require("scrollbar")

scrollbar.setup({
  show = true,
  set_highlights = true,
  handle = {
    text = " ",
    highlight = "CursorColumn",
  },
})

-- Search marks (requires hlslens)
pcall(function()
  require("scrollbar.handlers.search").setup()
end)

-- Optional: Git marks (if you use gitsigns)
pcall(function()
  require("scrollbar.handlers.gitsigns").setup()
end)
