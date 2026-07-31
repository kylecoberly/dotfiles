-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  {
    "AstroNvim/astrocommunity",
    -- Language packs (bundle LSP + treesitter + formatter + DAP per language)
    { import = "astrocommunity.pack.lua" },
    { import = "astrocommunity.pack.typescript" },
    { import = "astrocommunity.pack.python" },
    { import = "astrocommunity.pack.bash" },
    { import = "astrocommunity.pack.yaml" },
    { import = "astrocommunity.pack.json" },
    { import = "astrocommunity.pack.markdown" },
    -- Colorscheme
    { import = "astrocommunity.colorscheme.tokyonight-nvim" },
    -- Editing / motion
    { import = "astrocommunity.diagnostics.trouble-nvim" },
    { import = "astrocommunity.editing-support.telescope-undo-nvim" },
    { import = "astrocommunity.editing-support.zen-mode-nvim" },
    { import = "astrocommunity.motion.flash-nvim" },
    { import = "astrocommunity.motion.marks-nvim" },
    { import = "astrocommunity.motion.nvim-surround" },
    { import = "astrocommunity.scrolling.mini-animate" },
    { import = "astrocommunity.search.nvim-spectre" },
  },
  { "nvim-autopairs", enabled = false },
  -- Replaced by oil.nvim (see plugins/oil.lua)
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  -- Broken against nvim 0.12's treesitter API; :Telescope lsp_document_symbols covers it
  { "stevearc/aerial.nvim", enabled = false },
  { "aserowy/tmux.nvim" },
}
