return {
	{
		"Pocco81/true-zen.nvim",
		config = function()
			local truezen = require("true-zen")
			truezen.setup({
				modes = {
					ataraxis = {
						shade = "dark",
					},
				},
				integrations = {
					tmux = true,
					lualine = true,
				},
			})

			vim.keymap.set("n", "<Leader>m", function()
				truezen.ataraxis()
			end, {
				desc = "Zen: Ataraxis",
				noremap = true,
			})
		end,
	},
	{
		"toppair/peek.nvim",
		event = { "BufRead", "BufNewFile" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}
