local defaults = function()
  local M = {}

  M.add_read_only_maps = function(bufopts)
    vim.keymap.set("n", "<leader>rr", "<cmd>LspRestart<cr>")

    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", bufopts)
    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", bufopts)
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", bufopts)
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>nF", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>dF", vim.lsp.buf.remove_workspace_folder, bufopts)

    vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, bufopts)
  end

  M.add_formatting = function(bufopts)
    vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, bufopts)
  end

  M.get_buffer_options = function(buffer_number)
    return { noremap = true, silent = true, buffer = buffer_number }
  end

  M.on_attach = function(_, bufnr)
    local options = M.get_buffer_options(bufnr)

    M.add_read_only_maps(options)
    M.add_formatting(options)
  end

  M.get_capabilities = function()
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  end

  return M
end

local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
}

return {
  "neovim/nvim-lspconfig",
  init = function()
    local lspconfig = require("lspconfig")
    lspconfig.efm.setup({
      filetypes = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
        "markdown",
        "html",
        "css",
        "scss",
        "lua",
      },
      init_options = { documentFormatting = true },
      rootMarkers = { ".git/" },
      settings = {
        languages = {
          typescript = { prettier },
          typescriptreact = { prettier },
          javascript = { prettier },
          javascriptreact = { prettier },
          markdown = { prettier },
          html = { prettier },
          css = { prettier },
          scss = { prettier },
          json = { prettier },
        },
      },
      on_attach = defaults.on_attach,
      capabilities = defaults.get_capabilities(),
    })

    lspconfig.tsserver.setup({
      on_attach = function(client, bufnr)
        client.server_capabilities.documentformattingprovider = false

        local options = defaults.get_buffer_options(bufnr)
        defaults.add_read_only_maps(options)
      end,
      capabilities = defaults.get_capabilities(),
    })

    lspconfig.eslint.setup({
      on_attach = defaults.on_attach,
      capabilities = defaults.get_capabilities(),
    })

    lspconfig.stylelint_lsp.setup({
      on_attach = defaults.on_attach,
      capabilities = defaults.get_capabilities(),
      settings = {
        stylelintplus = {
          autoFixOnSave = true,
          autoFixOnFormat = true,
        },
      },
    })
  end,
  autoformat = true,
  opts = {
    servers = {
      efm = {},
      stylelint_lsp = {},
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
      tsserver = {},
    },
  },
}, {
  "williamboman/mason.nvim",
}, {
  "williamboman/mason-lspconfig.nvim",
  setup = {
    automatic_installation = true,
    ensure_installed = {
      "efm",
      "eslint",
      "lua_ls",
      "tsserver",
      "bash-language-server",
      "stylelint-lsp",
      "cucumber-language-server",
      "docker-compose-language-service",
      "dockerfile-language-server",
      "json-lsp",
      "shellcheck",
    },
  },
}, {
  "folke/neodev.nvim",
}
