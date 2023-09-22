return {
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xq",
        function()
          require("trouble").open("quickfix")
        end,
      },
      {
        "<leader>xl",
        function()
          require("trouble").open("loclist")
        end,
      },
      {
        "<leader>xx",
        function()
          require("trouble").open()
        end,
        desc = "Open Trouble",
      },
      {
        "<leader>xw",
        function()
          require("trouble").open("workspace_diagnostics")
        end,
        desc = "Open workspace diagnostics",
      },
      {
        "gR",
        function()
          require("trouble").open("lsp_references")
        end,
        desc = "Open references",
      },
      { "<leader>ut", vim.cmd.UndotreeToggle, desc = "Toggle undotree" },
    },
  },
}
