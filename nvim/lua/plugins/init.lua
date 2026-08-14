return { {
  "stevearc/conform.nvim",
  event = "BufWritePre", -- uncomment for format on save
  opts = require "configs.conform"
}, {
  "HampusHauffman/block.nvim",
  config = function()
    require("block").setup({})
  end
}, {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.assume_mapped = true
  end
}, -- These are some examples, uncomment them if you want to see them work!
  --
  -- Auto session
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {}
  }, -- Tag matching for HTML
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end
  }, {
  -- Custom lualine config
  "nvim-lualine/lualine.nvim",
  lazy = false,
  opts = require "configs.lualine"
}, {
  "neovim/nvim-lspconfig",

  config = function()
    require "configs.lspconfig"

    -- === Go to denifinition keymaps ===
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      desc = "Go to definition"
    })
    vim.keymap.set('n', '<leader>fu', ':lua require("telescope.builtin").lsp_references()<CR>', {
      noremap = true,
      silent = true
    })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, {
      desc = "Find references"
    })
    vim.keymap.set("n", "gs", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", {
      desc = "Go to definition (split)"
    })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    vim.keymap.set("n", "<C-LeftMouse>", vim.lsp.buf.definition, {
      buffer = true,
      desc = "Ctrl-click to go to definition"
    })
    -- === Diagnostics ===
    vim.keymap.set("n", "<leader>dq", function()
      vim.diagnostic.setqflist()
      vim.cmd("copen")
    end, {
      desc = "Diagnostics → Quickfix"
    })

    vim.keymap.set("n", "<leader>dl", function()
      vim.diagnostic.setloclist()
      vim.cmd("lopen")
    end, {
      desc = "Diagnostics → Location List"
    })

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
      desc = "Previous diagnostic"
    })

    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
      desc = "Next diagnostic"
    })

    vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, {
      desc = "Line diagnostics"
    })

    -- === Make gf work for "@/components" imports ===
    vim.opt.path:append "src"
    vim.opt.suffixesadd:append ".js,.jsx,.ts,.tsx"
    vim.cmd [[set includeexpr=substitute(v:fname,'^@/','src/','')]]

    -- 🖱️ Click on import to go to definition
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      callback = function()
        -- double left-click (or Ctrl-click if you prefer) opens definition
        vim.keymap.set("n", "<2-LeftMouse>", vim.lsp.buf.definition, {
          buffer = true,
          desc = "Click to go to definition"
        })
      end
    })
  end
}, -- waktime
  {
    'wakatime/vim-wakatime',
    lazy = false
  }, -- enable scrollbar
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      require("configs.scrollbar")
    end

  }, -- optional: show search matches in the scrollbar
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup({})
      -- scrollbar search handler will be set up later (see setup)
    end
  }, {
  "akinsho/flutter-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" -- optional UI improvement
  },
  config = function()
    require("flutter-tools").setup {
      lsp = {
        on_attach = function(client, bufnr)
          -- NvChad default on_attach
          require("nvchad.configs.lspconfig").on_attach(client, bufnr)
        end,
        capabilities = require("nvchad.configs.lspconfig").capabilities
      }
    }
  end
}, -- test new blink
  -- {
  --   import = "nvchad.blink.lazyspec",
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    "williamboman/mason.nvim",
    opts = {
      auto_install = true,
      ensure_installed = { "gopls", "golangci-lint", "prettier", "copilot-language-server", "delve", "html", "vtsls",
        "css", "json-lsp", "tailwindcss-language-server", "marksman", "bash-language-server",
        "yaml-language-server", "dockerfile-language-server", "svelte-language-server" }
    }
  }, -- Auto close HTML tags
  {
    "windwp/nvim-ts-autotag",
    -- Only load the plugin for these filetypes
    ft = { "html", "javascriptreact", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end
  }, -- Emmmet
  {
    'mattn/emmet-vim',
    -- Emmet is a classic Vim plugin, so it's not configured with a Lua 'config'
    -- function but rather with Vimscript global variables (vim.g in Lua).
    init = function()
      -- Enable Emmet for JSX/TSX (React files)
      vim.g.user_emmet_settings = {
        jsx = {
          extends = 'html'
        }

      }
    end
  }, -- Tree sitter config
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = ""
        }
      }
    }
  }, { 'dart-lang/dart-vim-plugin' }, {
  'akinsho/flutter-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/dressing.nvim' }
}, {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules", ".git", "dist", "build" }
    }
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    -- Telescope shortcut: search file under cursor
    vim.keymap.set("n", "<leader>e", function()
      require("telescope.builtin").find_files {
        default_text = vim.fn.expand "<cword>"
      }
    end, {
      desc = "Find file under cursor"
    })
  end
} }
