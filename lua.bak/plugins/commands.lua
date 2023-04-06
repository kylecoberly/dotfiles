return {
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"tpope/vim-repeat",
	},
	{
		"tummetott/unimpaired.nvim",
		config = function()
			require("unimpaired").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup()
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			require("undotree").setup()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<Leader>t",
				direction = "float",
				insert_mappings = false,
			})
		end,
	},
}
