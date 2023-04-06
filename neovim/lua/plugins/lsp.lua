return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        angularls = {},
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        ember = {},
        jdtls = {},
        marksman = {},
        jedi_language_server = {},
        rubyls = {},
        sqlls = {},
        volar = {},
        yamlls = {},
        eslint = {},
        cssls = {},
        html = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
    },
  },
}
