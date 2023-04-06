local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

-- Diff tool
vim.g.mergetool_layout = "mr"
vim.g.mergetool_prefer_revision = "local"
nmap("<Leader>dg", ":diffget<CR>", "Diff: Get")
nmap("<Leader>dp", ":diffput<CR>", "Diff: Put")

return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<Leader>ga", ":Git add %<CR><CR>", desc = "Git Add this file" },
      { "<Leader>gs", ":Git<CR>", desc = "Git: Interactive tool" },
      { "<Leader>gd", ":Git diff<CR>", desc = "Git Diff" },
      { "<Leader>gb", ":Git branch<Space>", desc = "Git Branch" },
      { "<Leader>go", ":Git checkout<Space>", desc = "Git Checkout" },
      { "<Leader>gc", ":Git commit -v -q<CR>", desc = "Git Commit" },
      { "<Leader>gg", ":Git commit -v -q %:p<CR>", desc = "Git Commit this file" },
      { "<Leader>gp", ":Git push<CR>", desc = "Git Push" },
    },
  },
  "tpope/vim-rhubarb",
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigating hunks
          vim.keymap.set("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, {
            expr = true,
            buffer = bufnr,
          })
          vim.keymap.set("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, {
            expr = true,
            buffer = bufnr,
          })

          -- Git commands
          vim.keymap.set({ "n", "v" }, "<Leader>hs", ":Gitsigns stage_hunk<CR>", {
            desc = "Git: Stage hunk",
          })
          vim.keymap.set({ "n", "v" }, "<Leader>hr", ":Gitsigns reset_hunk<CR>", {
            desc = "Git: Reset hunk",
          })
          nmap("<Leader>hS", gs.stage_buffer, "Git: Stage file")
          nmap("<Leader>hu", gs.undo_stage_hunk, "Git: Undo stage hunk")

          -- Create a text object
          vim.keymap.set({ "o", "x" }, "ih", ":<C-U>GitSigns select_hunk<CR>", {
            desc = "Select hunk",
          })
        end,
      })
    end,
  },
}
