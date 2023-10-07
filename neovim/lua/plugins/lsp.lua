return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    { "folke/neodev.nvim", opts = {} },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
      "hrsh7th/cmp-nvim-lsp",
      cond = function()
        return require("lazyvim.util").has("nvim-cmp")
      end,
    },
  },
  init = function()
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<Leader>fo", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end,
    })
  end,
  ---@class PluginLspOpts
  opts = {
    diagnostics = {
      underline = true,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = true,
    },
    autoformat = true,
    servers = {
      bashls = {},
      cssls = {},
      diagnosticls = {},
      docker_compose_language_service = {},
      dockerls = {},
      eslint_d = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectory = { mode = "auto" },
        },
      },
      grammarly = {},
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
      ltex = {},
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
              },
            },
          },
        },
      },
      marksman = {},
      markdown_cli2 = {},
      stylelint_lsp = {
        filetypes = { "css", "scss" },
        settings = {
          stylelintplus = {
            autoFixOnFormat = true,
            autoFixOnSave = true,
            validateOnType = true,
            validateOnSave = false,
          },
        },
      },
      sqlls = {},
      textlsp = {},
      tsserver = {},
    },
    setup = {
      tsserver = function(_, opts)
        require("typescript-tools").setup({ server = opts })
        return true
      end,
      eslint_d = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
          callback = function(event)
            if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint_d") then
              vim.cmd("EslintFixAll")
            end
          end,
        })
      end,
    },
  },
  config = function(_, opts)
    local Util = require("lazyvim.util")

    if Util.has("neoconf.nvim") then
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
    end
    require("lazyvim.plugins.lsp.format").setup(opts)
    Util.on_attach(function(client, buffer)
      require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
    end)
    local register_capability = vim.lsp.handlers["client/registerCapability"]

    vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
      local ret = register_capability(err, res, ctx)
      local client_id = ctx.client_id
      ---@type lsp.Client
      local client = vim.lsp.get_client_by_id(client_id)
      local buffer = vim.api.nvim_get_current_buf()
      require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      return ret
    end

    -- diagnostics
    for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
      name = "DiagnosticSign" .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
      Util.on_attach(function(client, buffer)
        if client.supports_method("textDocument/inlayHint") then
          inlay_hint(buffer, true)
        end
      end)
    end

    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
        or function(diagnostic)
          local icons = require("lazyvim.config").icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    -- get all the servers that are available through mason-lspconfig
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local all_mslp_servers = {}
    if have_mason then
      all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    end

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    if have_mason then
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end

    if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
      local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
      Util.lsp_disable("tsserver", is_deno)
      Util.lsp_disable("denols", function(root_dir)
        return not is_deno(root_dir)
      end)
    end
  end,
}, {
  "nvimtools/none-ls.nvim",
  {
    event = "LazyFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mason.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.diagnostics.tsc,
          null_ls.builtins.diagnostics.dotenv_linter,
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.markuplint,
          null_ls.builtins.diagnostics.codespell, -- maybe not?
          null_ls.builtins.diagnostics.misspell, -- needs Go installed
          null_ls.builtins.diagnostics.proselint,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          null_ls.builtins.diagnostics.tidy, -- not in mason?
          null_ls.builtins.diagnostics.trail_space,
          null_ls.builtins.diagnostics.typos,
          null_ls.builtins.diagnostics.writegood,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.diagnostics.zsh, -- not in mason?
          null_ls.builtins.completion.spell,
          null_ls.builtins.completion.luasnip,
          null_ls.builtins.completion.tags,
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.code_actions.gitsigns, -- not in mason?
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.code_actions.refactoring, -- Requires visually selecting the code you want to refactor and calling :'<,'>lua vim.lsp.buf.range_code_action() (for the default handler) or :'<,'>Telescope lsp_range_code_actions (for Telescope).
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.code_actions.ts_node_action,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.beautysh,
          null_ls.builtins.formatting.codespell,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.hover.dictionary, -- Needs Plenary and curl in the $PATH
          null_ls.builtins.hover.printenv,
          null_ls.builtins.formatting.fixjson,
          null_ls.builtins.formatting.json_tool,
          null_ls.builtins.formatting.markdown_toc, --To generate a TOC, add <!-- toc --> before headers in your markdown file.
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          null_ls.builtins.formatting.stylelint,
          null_ls.builtins.formatting.textlint,
          null_ls.builtins.formatting.tidy,
          null_ls.builtins.formatting.trim_whitespace,
          null_ls.builtins.formatting.yamlfix,
          null_ls.builtins.formatting.yamlfmt,
        },
        on_attach = function(client, bufnr)
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettierd",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { { "prettierd", "prettier" } },
        ["javascriptreact"] = { { "prettierd", "prettier" } },
        ["typescript"] = { { "prettierd", "prettier" } },
        ["typescriptreact"] = { { "prettierd", "prettier" } },
        ["vue"] = { { "prettierd", "prettier" } },
        ["css"] = { { "prettierd", "prettier" } },
        ["scss"] = { { "prettierd", "prettier" } },
        ["less"] = { { "prettierd", "prettier" } },
        ["html"] = { { "prettierd", "prettier" } },
        ["json"] = { { "prettierd", "prettier" } },
        ["jsonc"] = { { "prettierd", "prettier" } },
        ["yaml"] = { { "prettierd", "prettier" } },
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["graphql"] = { { "prettierd", "prettier" } },
        ["handlebars"] = { { "prettierd", "prettier" } },
      },
    },
  },
}
