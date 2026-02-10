require "nvchad.autocmds"

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Organize imports and fix all in TypeScript (vtsls)",
  group = vim.api.nvim_create_augroup("vtsls_organize_imports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    local function run_code_action(kind)
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { kind },
          diagnostics = {},
        },
      })
    end

    -- Order matters
    run_code_action("source.removeUnusedImports")
    run_code_action("source.organizeImports")
    run_code_action("source.fixAll")

    -- organize imports
    -- local params = {
    --   textDocument = vim.lsp.util.make_text_document_params(bufnr),
    --   context = { only = { "source.removeUnusedImports" } },
    -- }
    -- local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    -- if result then
    --   for _, res in pairs(result) do
    --     for _, action in pairs(res.result or {}) do
    --       if action.edit then
    --         vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
    --       elseif action.command then
    --         vim.lsp.buf.execute(action.command)
    --       end
    --     end
    --   end
    -- end
    -- --
    -- params.context = { only = { "source.organizeImports" } }
    -- result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    -- if result then
    --   for _, res in pairs(result) do
    --     for _, action in pairs(res.result or {}) do
    --       if action.edit then
    --         vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
    --       elseif action.command then
    --         vim.lsp.buf.execute(action.command)
    --       end
    --     end
    --   end
    -- end

    -- fix all
    -- params.context = { only = { "source.fixAll" } }
    -- result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
    -- if result then
    --   for _, res in pairs(result) do
    --     for _, action in pairs(res.result or {}) do
    --       if action.edit then
    --         vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
    --       elseif action.command then
    --         vim.lsp.buf.execute(action.command)
    --       end
    --     end
    --   end
    -- end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- defaults:
    -- https://neovim.io/doc/user/news-0.11.html#_defaults

    map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
    map("<leader>lf", vim.lsp.buf.format, "Format")
    map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has "nvim-0.11" == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
        client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

      -- When cursor stops moving: Highlights all instances of the symbol under the cursor
      -- When cursor moves: Clears the highlighting
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- When LSP detaches: Clears the highlighting
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
        end,
      })
    end
  end,
})
