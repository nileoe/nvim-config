return {
	"navarasu/onedark.nvim",
	"nickkadutskyi/jb.nvim",
	"sainnhe/edge",
	"catppuccin/nvim",
	"rebelot/kanagawa.nvim",
	"rose-pine/neovim",
	"EdenEast/nightfox.nvim",
	"savq/melange-nvim",
	"projekt0n/github-nvim-theme",
	"ellisonleao/gruvbox.nvim",
	"shaunsingh/nord.nvim",
	"AlexvZyl/nordic.nvim",
	"oxfist/night-owl.nvim",
	"ribru17/bamboo.nvim",
	"nyoom-engineering/oxocarbon.nvim",
	"yorickpeterse/vim-paper",
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- you can set set configuration options here
		-- config = function()
		-- vim.g.zenbones_darken_comments = 45
		-- vim.cmd.colorscheme('zenbones')
		-- end
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				-- use the night style
				style = "night",
				-- disable italic for functions
				styles = { functions = {} },
				sidebars = { "qf", "vista_kind", "terminal", "packer" },
				-- Change the "hint" color to the "orange" color, and make the "error"
				-- color bright red
				on_colors = function(colors)
					-- colors.hint = colors.orange
					-- colors.error = "#00ff00"
					colors.fg_gutter = "#7aa2f7" -- "#3b4261"
					colors.comment = "#767fa9" -- "#565f89"
					colors.terminal_black = colors.orange
					-- colors.terminal_black = "#ff9e64" -- #414868
				end,
				on_highlights = function(highlights)
					highlights.ministatuslinefilename = {
						bg = "#3b4261", -- defaults: so that the gutter doesn't affect this
						fg = "#ffffff", -- "#a9b1d6"
					}
					-- make unused imports and similar (unnessary) readable (default is
					-- too dark)
					-- highlights.DiagnosticUnnecessary = {
					-- fg = "#ffff00",
					-- }
				end,
			})
		end,
	},
}
