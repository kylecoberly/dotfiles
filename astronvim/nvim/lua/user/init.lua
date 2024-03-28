return {
  colorscheme = "melange",
  mappings = {
    n = {
      ["<Leader>z"] = { "<cmd>ZenMode<cr>" },
      ["<Leader>m"] = { "<cmd>PeekOpen<cr>" },
    },
  },
  plugins = {
    {
      "AstroNvim/astrocommunity",
      {
        import = "astrocommunity.colorscheme.melange-nvim",
      },
      {
        import = "astrocommunity.pack.typescript-all-in-one",
      },
      {
        import = "astrocommunity.diagnostics.lsp_lines-nvim",
      },
      {
        import = "astrocommunity.diagnostics.trouble-nvim",
      },
      {
        import = "astrocommunity.editing-support.telescope-undo-nvim",
      },
      {
        import = "astrocommunity.editing-support.zen-mode-nvim",
      },
      {
        import = "astrocommunity.motion.flash-nvim",
      },
      {
        import = "astrocommunity.motion.marks-nvim",
      },
      {
        import = "astrocommunity.motion.nvim-surround",
      },
      {
        import = "astrocommunity.scrolling.mini-animate",
      },
      {
        import = "astrocommunity.project.nvim-spectre",
      },
      {
        import = "astrocommunity.markdown-and-latex.peek-nvim",
      },
      {
        import = "astrocommunity.git.blame-nvim",
      },
      {
        import = "astrocommunity.completion.tabnine-nvim",
      },
    },
    {
      "nvim-autopairs",
      enabled = false,
    },
    {
      "aserowy/tmux.nvim",
    },
    {
      "rmagatti/auto-session",
    },
  },
}
