-- Map leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Override normal mode commands
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Add blank lines in normal mode
vim.keymap.set("n", "<C-o>", "O<Esc>", { silent = true })
vim.keymap.set("n", "<CR>", "o<Esc>", { silent = true })

vim.keymap.set("n", "\\", ":NeoTreeRevealToggle<CR>", {
  silent = true,
  remap = false,
  desc = "Toggle file tree"
})
vim.keymap.set("n", "<Leader>.", "@:", {
  silent = true,
  remap = false,
  desc = "Repeat last ex command"
})
vim.keymap.set("v", "<Leader>s", ":sort<CR>", {
  silent = true,
  remap = false,
  desc = "Sort selection"
})
vim.keymap.set("n", "<Leader>r", ":set relativenumber!<CR>", {
  silent = true,
  remap = false,
  desc = "Toggle relative numbers"
})
vim.keymap.set("n", "<Leader>d", ":bd<CR>", {
  silent = true,
  remap = false,
  desc = "Close buffer"
})
vim.keymap.set("n", "<Tab>", ":b#<CR>", {
  silent = true,
  remap = false,
  desc = "Switch buffer"
})
vim.keymap.set("n", "<Leader>bw", ":bufdo bwipeout<CR>", {
  silent = true,
  remap = false,
  desc = "Close all buffers"
})

return {
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end
  },
  "tpope/vim-repeat",
  "tpope/vim-unimpaired",
  "numToStr/Comment.nvim",
  "folke/which-key.nvim",
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = "<Leader>t",
        direction = "float",
        insert_mappings = false
      })
    end
  }
}
