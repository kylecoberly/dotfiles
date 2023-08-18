return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ignore_install = { "help" }

      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "html",
          "dockerfile",
          "java",
          "css",
          "scss",
          "sql",
          "javascript",
          "typescript",
          "vue",
          "json",
          "lua",
          "git_config",
          "jsdoc",
          "make",
          "toml",
          "vimdoc",
          "ruby",
        })
      end
    end,
  },
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
