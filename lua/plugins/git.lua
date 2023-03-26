-- Diff tool
vim.g.mergetool_layout = "mr"
vim.g.mergetool_prefer_revision = "local"
vim.keymap.set("n", "<Leader>dg", ":diffget<CR>")
vim.keymap.set("n", "<Leader>dp", ":diffput<CR>")

return {
  {
    "tpope/vim-fugitive",
    config = function ()
      -- Stage current file
      vim.keymap.set("n", "<Leader>ga", ":Git add %<CR><CR>")
      -- Interactive tool
      vim.keymap.set("n", "<Leader>gs", ":Git<CR>")
      vim.keymap.set("n", "<Leader>gd", ":Git diff<CR>")
      vim.keymap.set("n", "<Leader>gb", ":Git branch<Space>")
      vim.keymap.set("n", "<Leader>go", ":Git checkout<Space>")
      vim.keymap.set("n", "<Leader>gc", ":Git commit -v -q<CR>")
      -- Commit current file
      vim.keymap.set("n", "<Leader>gg", ":Git commit -v -q %:p<CR>")
      vim.keymap.set("n", "<Leader>gp", ":Git push<CR>")
    end
  },
  "tpope/vim-rhubarb",
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function ()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function (bufnr)
          local gs = package.loaded.gitsigns

          -- Navigating hunks
          vim.keymap.set("n", "]h", function ()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function ()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, {
            expr = true,
            buffer = bufnr
          })
          vim.keymap.set("n", "[h", function ()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function ()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, {
            expr = true,
            buffer = bufnr
          })

          -- Git commands
          vim.keymap.set({"n", "v"}, "<Leader>hs", ":Gitsigns stage_hunk<CR>")
          vim.keymap.set({"n", "v"}, "<Leader>hr", ":Gitsigns reset_hunk<CR>")
          vim.keymap.set("n", "<Leader>hS", gs.stage_buffer)
          vim.keymap.set("n", "<Leader>hu", gs.undo_stage_hunk)

          -- Create a text object
          vim.keymap.set({ "o", "x" }, "ih", ":<C-U>GitSigns select_hunk<CR>")
        end
      })
    end
  },
}
