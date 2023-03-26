-- Make line numbers default
vim.wo.number = true

return {
  -- Colors
  "sainnhe/gruvbox-material",
  -- Smooth scrolling
  {
    "declancm/cinnamon.nvim",
    config = function ()
      require("cinnamon").setup()
      -- Don"t let scroll go all the way to edge
      vim.o.scrolloff = 5
      vim.o.sidescrolloff = 7
    end
  },
  -- Better defaults for netrw
  "tpope/vim-vinegar",
  -- Plugin manager
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  -- Highlight instances of the word under cursor
  "RRethy/vim-illuminate",
  -- Show marks in the gutter
  {
    "kshenoy/vim-signature",
    config = function ()
      -- Keep signcolumn on by default
      vim.wo.signcolumn = "yes"
    end
  },
  -- Add indentation guides even on blank lines
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
    },
  },
  -- Top bar
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        separator_style = "slant",
      },
    }
  },
  -- Bottom bar
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "gruvbox-material",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
}
