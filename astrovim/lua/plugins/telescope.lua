return {
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("refactoring")
      end,
    },
    keys = {
      -- Handle git through fugitive
      { "<leader>gs", false },
      { "<leader>gc", false },
      -- Use trouble for diagnostics
      { "<leader>xq", false },
      { "<leader>xl", false },
      { "<leader>xt", false },
    },
  },
}
