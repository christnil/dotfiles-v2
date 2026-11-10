-- LSP on Neovim 0.11+ native API: vim.lsp.config() + vim.lsp.enable().
-- nvim-lspconfig only provides the default server configs; mason installs binaries.
local servers = {
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = "Replace" } } },
  },
  rust_analyzer = {}, -- from rustup (`rustup component add rust-analyzer`), not mason
  vtsls = {}, -- TypeScript / JavaScript
  basedpyright = {}, -- Python types
  ruff = {}, -- Python lint (formatting via conform)
  yamlls = {
    settings = {
      yaml = {
        keyOrdering = false,
        -- Home Assistant uses custom tags (!secret, !include, ...)
        customTags = { "!secret scalar", "!include scalar", "!include_dir_named scalar",
          "!include_dir_list scalar", "!include_dir_merge_named scalar", "!include_dir_merge_list scalar",
          "!input scalar", "!env_var scalar" },
      },
    },
  },
  jsonls = {},
  bashls = {},
  marksman = {}, -- Markdown
  dockerls = {},
  taplo = {}, -- TOML (Cargo.toml etc.)
  html = {},
  cssls = {},
  omnisharp = {}, -- C#
}

-- Mason package names for everything above that mason should install,
-- plus formatters used by conform (format.lua) and the treesitter CLI.
local mason_tools = {
  "lua-language-server", "vtsls", "basedpyright", "ruff", "yaml-language-server",
  "json-lsp", "bash-language-server", "marksman", "dockerfile-language-server",
  "taplo", "html-lsp", "css-lsp", "omnisharp",
  "stylua", "prettierd", "prettier", "shfmt", "shellcheck",
  "tree-sitter-cli",
}

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local tb = require("telescope.builtin")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gd", tb.lsp_definitions, "[G]oto [D]efinition")
          map("gr", tb.lsp_references, "[G]oto [R]eferences")
          map("gI", tb.lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", tb.lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight", event.buf) then
            local hl = vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("custom-lsp-detach", { clear = true }),
              callback = function(e2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "custom-lsp-highlight", buffer = e2.buf })
              end,
            })
          end
          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = "if_many", spacing = 2 },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg)
        vim.lsp.enable(name)
      end

      require("mason-tool-installer").setup({ ensure_installed = mason_tools })
    end,
  },
}
