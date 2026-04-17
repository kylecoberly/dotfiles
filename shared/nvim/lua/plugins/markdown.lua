---@type LazySpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "Avante" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    file_types = { "markdown", "Avante" },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
  },
}
