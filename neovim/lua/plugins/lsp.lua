return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {},
        bashls = {},
        cssls = {},
        docker_compose_language_service = {},
        dockerls = {},
        ember = {},
        eslint = {},
        html = {},
        jdtls = {},
        jedi_language_server = {},
        jsonls = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        marksman = {},
        ruby_ls = {},
        sqlls = {},
        volar = {},
        yamlls = {},
      },
    },
  },
}
