return {
  colorscheme = "melange",
  mappings = {
    n = {
      ["<Leader>m"] = { "<cmd>ZenMode<cr>" }
    },
  },
  plugins = {
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
      "nvim-autopairs",
      enabled = false,
    },
    {
      "akinsho/toggleterm.nvim",
      version = "false",
      opts = {
        open_mapping = [[<Leader>t]]
        direction = "tab"
      }
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({})
      end
    },
    {
      "chentoast/marks.nvim",
    },
    {
      "aserowy/tmux.nvim",
    },
    {
      "rmagatti/auto-session",
    },
    {
    "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
        require("peek").setup()
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
    },
  }
}
