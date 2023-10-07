return {
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "f3fora/cmp-spell",
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      -- Use <tab> for completion and snippets (supertab)
      -- first: disable default <tab> and <s-tab> behavior in LuaSnip (function overwrites defaults)
      return {}
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
      },
    },
    init = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local cmp = require("cmp")
      local cmp_types = require("cmp.types")

      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer", keyword_length = 5 },
          { name = "luasnip" },
          {
            name = "spell",
            option = {
              keep_all_entries = true,
              enable_in_context = function()
                return require("cmp.config.context").in_treesitter_capture("spell")
              end,
            },
          },
          { name = "emoji" },
          { name = "cmp_tabnine" },
          { name = "buffer" },
        }),
        experimental = {
          native_menu = false,
          ghost_text = { cmp_types.cmp.TriggerEvent.TextChanged },
        },
      })

      -- Maybe not necessary?
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig")["bashls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["cssls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["dockerls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["eslint_d"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["grammarly"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["html"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["jsonls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["ltex"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["lua_ls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["marksman"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["markdown_cli2"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["stylelint_lsp"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["sqlls"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["textlsp"].setup({
        capabilities = capabilities,
      })
      require("lspconfig")["tsserver"].setup({
        capabilities = capabilities,
      })
    end,
  },
}
