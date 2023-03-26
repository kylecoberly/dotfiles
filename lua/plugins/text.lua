return {
  {
    "junegunn/goyo.vim",
    config = function()
      vim.g.goyo_width = 60

      vim.keymap.set("n", "m", ":Goyo<CR>", { silent = true })
    end
  },
  {
    "jghauser/follow-md-links.nvim",
    config = function()
      vim.keymap.set("n", "<BS>", ":edit #<CR>", { silent = true })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_port = 8080
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_echo_preview_url = 1

      vim.keymap.set("n", "<Leader>p", ":MarkdownPreviewToggle<CR>")
    end,
  }
}
