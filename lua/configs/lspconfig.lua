require("nvchad.configs.lspconfig").defaults()
local servers = {
  "html",
  "cssls",
  "vtsls",
  "gopls",
  "lua_ls",
  "jsonls",
  "tailwindcss",
  "marksman",
  "bashls",
  "yamlls",
  "pyright",
  "dockerls",
  "svelte",
  "copilot"
}
vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers
