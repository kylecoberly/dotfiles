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
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
        html = {},
        jdtls = {},
        jedi_language_server = {},
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
        marksman = {},
        ruby_ls = {},
        sqlls = {},
        volar = {},
        yamlls = {},
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint") then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      },
    },
  },
}
