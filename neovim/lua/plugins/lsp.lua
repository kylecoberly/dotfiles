return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("none-ls")
      opts.sources = vim.list_extend(opts.sources, {
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.stylelint,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.hover.dictionary,
        null_ls.builtins.hover.printenv,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        expose_as_code_actions = "all",
        complete_function_calls = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    -- autoformat = true,
    opts = {
      servers = {
        cssls = {},
        eslint = {},
        html = {},
        jsonls = {
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = {
                enable = true,
              },
            },
          },
        },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        tsserver = {
          enabled = false,
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "bash-language-server",
        "css-lsp",
        "cucumber-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        -- "eslint-lsp",
        -- "grammarly-languageserver",
        "html-lsp",
        -- "htmlbeautifier",
        -- "jdtls",
        -- "jq",
        "json-lsp",
        -- "jsonlint",
        -- "lua-language-server",
        -- "markdownlint",
        -- "marksman",
        -- "proselint",
        -- "remark-cli",
        -- "remark-language-server",
        -- "ruby-lsp",
        "shellcheck",
        -- "shfmt",
        -- "spell",
        -- "sql-formatter",
        -- "sqlls",
        -- "sqlfluff",
        -- "stylelint-lsp",
        -- "stylua",
        -- "tags",
        -- "ts_node_action",
        -- "write-good",
        -- "yaml-language-server",
        -- "yamllint",
      },
    },
  },
}
