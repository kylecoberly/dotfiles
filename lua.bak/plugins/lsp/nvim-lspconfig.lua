Nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "folke/neodev.nvim",
  },
  config = function()
    require("neodev").setup()
    require("mason").setup()

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        Nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        Nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        Nmap("<leader>do", vim.lsp.buf.code_action, "'do', alias for: [C]ode [A]ction")
        Nmap("gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
        Nmap("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
        Nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        Nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        Nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        Nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        Nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        Nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        Nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        Nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        Nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        Nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")
        Nmap("<leader>f", function()
          vim.lsp.buf.format { async = true }
        end, "[F]ormat")
      end,
    })

    local servers = {
      tsserver = {
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      },
      eslint = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- Ensure the servers above are installed
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    mason_lspconfig.setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup {
          capabilities = capabilities,
          settings = servers[server_name],
        }
      end,
    })
  end
}
