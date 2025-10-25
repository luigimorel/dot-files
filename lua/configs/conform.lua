local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "htmlbeautifier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    go = { "gofumpt", "goimports", "golines", "gofmt" },
  },
  linters_by_ft = {
    go = { "golangci-lint" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    lua = { "luacheck" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 100000,
    lsp_fallback = true,
  },
}

return options
