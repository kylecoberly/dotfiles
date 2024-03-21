return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = "all",
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end,
  },
}
