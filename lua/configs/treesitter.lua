require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "html",
    "css",
    "javascript",
    "tsx",
  },

  highlight = {
    enable = true,
  },

  autotag = {
    enable = true,
  },
})
