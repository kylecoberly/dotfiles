return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      -- {
      --   "<leader>r",
      --   function()
      --     require("refactoring").select_refactor()
      --     -- require("telescope").extensions.refactoring.refactors()
      --   end,
      --   {
      --     mode = { "n", "x" },
      --   },
      -- },
    },
  },
}
