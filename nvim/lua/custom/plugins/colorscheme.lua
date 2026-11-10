return {
  { -- Catppuccin Mocha, same as waybar/tmux/kitty/ghostty
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      no_italic = true, -- matches the old "Comment gui=none"
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        mason = true,
        mini = { enabled = true },
        neotree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        fidget = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
