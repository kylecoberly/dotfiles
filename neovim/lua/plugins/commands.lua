return {
  {
    "tummetott/unimpaired.nvim",
    config = function()
      require("unimpaired").setup()
    end,
  },
  {
    "tpope/vim-surround",
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>ut", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
    },
  },
}
