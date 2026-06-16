require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "html",
    "css",
    "javascript",
    "tsx",
    "markdown",
    "markdown_inline",
    "go", "gomod", "gosum", "gowork"
  },

  highlight = {
    enable = true,
  },

  autotag = {
    enable = true,
  },
})
