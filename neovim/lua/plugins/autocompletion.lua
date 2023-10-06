return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  "L3MON4D3/LuaSnip",
  keys = function()
    return {}
  end,
}, {
  -- override nvim-cmp and add cmp-emoji
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    {
      "tzachar/cmp-tabnine",
      build = "./install.sh",
    },
    {
      "cmp",
      {
        init = function()
          vim.opt.completeopt = { "menu", "menuone", "noselect" }

          local cmp = require("cmp")
          local cmp_types = require("cmp.types")

          cmp.setup({
            snippet = {
              expand = function(args)
                require("luasnip").lsp_expand(args.body)
              end,
            },
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
            }, {
              { name = "buffer" },
            }),
            experimental = {
              native_menu = false,
              ghost_text = { cmp_types.cmp.TriggerEvent.TextChanged },
            },
          })
        end,
      },
    },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      { name = "emoji" },
      { name = "cmp_tabnine" },
    }))

    -- then: setup supertab in cmp
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
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
    })
  end,
}, {
  "hrsh7th/cmp-nvim-lsp",
}, {
  "hrsh7th/cmp-buffer",
}, {
  "hrsh7th/cmp-path",
}, {
  "f3fora/cmp-spell",
}
