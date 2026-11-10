return {
  { -- Autocompletion (blink.cmp replaced nvim-cmp 2026-11-10)
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship a prebuilt Rust fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "folke/lazydev.nvim",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- Same keys as the old nvim-cmp setup:
      -- C-n/C-p select, C-y accept, C-Space open, C-b/C-f scroll docs, C-e close
      keymap = {
        preset = "default",
        -- Snippet jumps, like the old LuaSnip <C-l>/<C-h>
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
