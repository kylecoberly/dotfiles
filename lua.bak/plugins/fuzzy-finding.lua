return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("telescope").setup {
	defaults = {
	  mappings = {
	    i = {
	      ["<C-u>"] = false,
	      ["<C-d>"] = false,
	    },
	  },
	},
      }
      vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
	  winblend = 10,
	  previewer = false,
	})
	end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

    end
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = "make",
    cond = function()
      return vim.fn.executable "make" == 1
    end,
    config = function()
      -- Enable telescope fzf native, if installed
      pcall(require("telescope").load_extension, "fzf")
    end
  },
}
