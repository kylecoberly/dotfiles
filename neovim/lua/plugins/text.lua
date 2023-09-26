return {
  {
    "jghauser/follow-md-links.nvim",
    keys = {
      { "n", "<BS>", ":edit #<CR>" },
    },
  },
  {
    "Pocco81/true-zen.nvim",
    config = function()
      local truezen = require("true-zen")
      truezen.setup({
        integrations = {
          tmux = true,
          lualine = true,
        },
      })

      vim.keymap.set("n", "<Leader>m", function()
        truezen.ataraxis()
      end, {
        desc = "Zen: Ataraxis",
        noremap = true,
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_port = 8080
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_echo_preview_url = 1

      vim.keymap.set("n", "<Leader>p", ":MarkdownPreviewToggle<CR>", {
        desc = "Toggle live markdown preview",
      })
    end,
  },
}
