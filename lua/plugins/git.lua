return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"ibhagwan/fzf-lua", -- optional
			-- "isakbm/gitgraph.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader>g", "<CMD>Neogit<CR>")
		end,
		opts = { graph_style = kitty },
	},
}
