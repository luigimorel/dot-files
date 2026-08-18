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
}

-- Configure vtsls before enabling
vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      preferences = { includePackageJsonAutoImports = "auto" },
    },
    javascript = {
      preferences = { includePackageJsonAutoImports = "auto" },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
    },
    vim.lsp.config("cssls", {
      settings = {
        css = {
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          lint = {
            unknownAtRules = "ignore",
          },
        },
        less = {
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    })
  },
})


vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers
