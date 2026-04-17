---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        signcolumn = "yes",
        wrap = false,
        spell = false,
      },
    },
    mappings = {
      n = {
        ["<Leader>z"] = { "<cmd>ZenMode<cr>", desc = "Zen Mode" },
        ["<Leader>e"] = { "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
      },
    },
  },
}
