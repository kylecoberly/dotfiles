-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.colorscheme.melange-nvim" },
    { import = "astrocommunity.pack.typescript" },
    { import = "astrocommunity.diagnostics.trouble-nvim" },
    { import = "astrocommunity.editing-support.telescope-undo-nvim" },
    { import = "astrocommunity.editing-support.zen-mode-nvim" },
    { import = "astrocommunity.motion.flash-nvim" },
    { import = "astrocommunity.motion.marks-nvim" },
    { import = "astrocommunity.motion.nvim-surround" },
    { import = "astrocommunity.scrolling.mini-animate" },
    { import = "astrocommunity.search.nvim-spectre" },
    { import = "astrocommunity.git.blame-nvim" },
    { import = "astrocommunity.completion.tabnine-nvim" },
  },
  {
    "nvim-autopairs",
    enabled = false,
  },
  {
    "aserowy/tmux.nvim",
  },
  {
    "rmagatti/auto-session",
  },
}
