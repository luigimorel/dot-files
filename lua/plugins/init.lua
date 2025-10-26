return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.assume_mapped = true
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",

    config = function()
      require "configs.lspconfig"

      -- === Go to denifinition keymaps ===
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set('n', '<leader>fu', ':lua require("telescope.builtin").lsp_references()<CR>',
        { noremap = true, silent = true })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "gs", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition (split)" })
      vim.keymap.set(
        "n", "K", vim.lsp.buf.hover, {}
      )
      vim.keymap.set(
        "n",
        "<C-LeftMouse>",
        vim.lsp.buf.definition,
        { buffer = true, desc = "Ctrl-click to go to definition" }
      )

      -- === Make gf work for "@/components" imports ===
      vim.opt.path:append "src"
      vim.opt.suffixesadd:append ".js,.jsx,.ts,.tsx"
      vim.cmd [[set includeexpr=substitute(v:fname,'^@/','src/','')]]

      -- 🖱️ Click on import to go to definition
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        callback = function()
          -- double left-click (or Ctrl-click if you prefer) opens definition
          vim.keymap.set(
            "n",
            "<2-LeftMouse>",
            vim.lsp.buf.definition,
            { buffer = true, desc = "Click to go to definition" }
          )
        end,
      })
    end,
  }, -- test new blink
  -- {
  --   import = "nvchad.blink.lazyspec",
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    "williamboman/mason.nvim",
    opts = {
      auto_install = true,
      ensure_installed = {
        "gopls",
        "golangci-lint",
        "prettier",
        "copilot-language-server",
        "delve",
        "html",
        "vtsls",
        "css",
        "json-lsp",
        "tailwindcss-language-server",
        "marksman",
        "bash-language-server",
        "yaml-language-server",
        "dockerfile-language-server",
        "svelte-language-server",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git", "dist", "build", "public" },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      -- Telescope shortcut: search file under cursor
      vim.keymap.set("n", "<leader>e", function()
        require("telescope.builtin").find_files { default_text = vim.fn.expand "<cword>" }
      end, { desc = "Find file under cursor" })
    end,
  },
}
