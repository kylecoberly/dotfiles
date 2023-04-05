return {
  "simrat39/symbols-outline.nvim",
  config = function()
    require("symbols-outline").setup()
    vim.keymap.set("n", "<C>\\", ":SymbolsOutline<CR>", {
      silent = true,
      desc = "Toggle symbols outline",
    })
  end
}
