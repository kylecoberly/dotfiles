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
          "vue",
          "json",
          "lua",
          "git_config",
          "jsdoc",
          "make",
          "toml",
          "vimdoc",
          "ruby",
          "typescript",
          "tsx",
        })
      end
    end,
  },
}
