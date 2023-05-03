return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    {
      "\\",
      "<leader>fe",
      desc = "File Explorer",
      remap = true,
    },
  },
  opts = {
    window = {
      filesystem = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = true,
      window = {
        mappings = {
          ["-"] = "navigate_up",
          ["."] = "set_root",
          ["/"] = "fuzzy_finder",
        },
        fuzzy_finder_mappings = {
          ["<C-n>"] = "move_cursor_down",
          ["<C-N>"] = "move_cursor_up",
        },
      },
    },
  },
}
