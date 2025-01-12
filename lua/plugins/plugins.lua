-- f-person/git-blame.nvim (see git blames)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	require("plugins/colorschemes"),
	require("plugins/git"),
	-- require("plugins/debugging"),
	-- ####################################### LSPS / MASON #######################################
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").clangd.setup({})
		end,
		-- opts = {
		-- 	servers = {
		-- 		clangd = {
		-- 			mason = false,
		-- 		},
		-- 	},
		-- },
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
		opts = {
			ensure_installed = {
				"debugpy",
				"clangd",
			},
		},
	},
	{
		-- mason lsp server names don't always match with nvim-lspconfig.
		-- This plugin (mason-lspconfig.nvim) bridges the two.
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup()
			-- the function below (setup_handlers) essentially takes care of installing to the mason-installed LSPs.
			-- to actually understand it: help on :h mason-lspconfig-automatic-server-setup
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
	},
	-- TREESITTER
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{ -- ALL OF THIS IS TREESITTER DO NOT PANIC
		-- treesitter allows for multiple modules (i.e. plugins) in treesitter.configs.
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				-- when you wanna install another language parser:
				-- add to above table according to this list:
				-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
				-- actually because anto_install active u don't need to

				auto_install = true,

				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = { -- set to `false` to disable one of the mappings
						-- init_selection = "<leader>ss",       -- Selection Start
						-- scope_incremental = "<leader>sc",    -- Selection sCope increement
						-- node_incremental = "<leader>si",     -- Selection Increment
						-- node_decremental = "<leader>sd",     -- Selection Decrement
						node_incremental = "v", -- Selection Increment
						node_decremental = "V", -- Selection Decrement
					},
				},
				textobjects = {
					select = {
						enable = true,

						-- automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- you can use the capture groups defined in textobjects.scm
							-- those effectvely become new MOTIONS like iw, i{, a" etc.
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- you can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "select inner part of a class region" },
							-- you can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "select language scope" },
						},
						-- you can choose the select mode (default is charwise 'v') MEANING normal visual mode
						--
						-- can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'v', or '<c-v>') or a table
						-- mapping query_strings to modes.
						-- BASICALLY (Lino) which type of visual mode should each selection use?
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "v", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- if you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
				},
			}) -- END OF TREESITTER STUFF ffs
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			stop_after_first = true,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "alejandra", "nixpkgs-fmt" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				cs = { "clang-format" },
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				lua = { "stylua", "sqlfmt" },
				sql = { "sql-formatter" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				java = { "google-java-format" },
				html = { "htmlbeautifier" },
				bash = { "buf" },
				rust = { "rustfmt" },
				toml = { "taplo" },
				-- javascript = { { "prettierd", "prettier" } },
				-- typescript = { { "prettierd", "prettier" } },
				-- javascriptreact = { { "prettierd", "prettier" } },
				-- typescriptreact = { { "prettierd", "prettier" } },
				-- lua = { "stylua" },
				-- css = { { "prettierd", "prettier" } },
				-- scss = { { "prettierd", "prettier" } },
				-- json = { { "prettierd", "prettier" } },
				-- java = { "google-java-format" },
				-- html = { "htmlbeautifier" },
				-- bash = { "buf" },
				-- rust = { "rustfmt" },
				-- toml = { "taplo" },
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {

			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					--
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
							-- require('luasnip.loaders.from_vscode').lazy_load({ paths = { "/home/nil_/.vscode-oss/extensions/abusaidm.html-snippets-0.2.1-universal/snippets/snippets.json" } })
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll the documentation window
					["<C-k>"] = cmp.mapping.scroll_docs(-4),
					["<C-j>"] = cmp.mapping.scroll_docs(4),

					-- Accept the completion OK
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<C-o>"] = cmp.mapping.confirm({ select = true }),

					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					--['<CR>'] = cmp.mapping.confirm { select = true },
					--['<Tab>'] = cmp.mapping.select_next_item(),
					--['<S-Tab>'] = cmp.mapping.select_prev_item(),
					-- Manually trigger a completion from nvim-cmp.
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					-- ['<C-Space>'] = cmp.mapping.complete {},

					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),

					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	-- #################################### OTHERS
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	-- {
	-- 	"tpope/vim-fugitive",
	-- },
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration on github
		},
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional (customization)
			-- vim.keymap.set({ "n", "v" }, "<leader>g", ":FzfLua files<CR>", { desc = "[G]o to file" })
			vim.keymap.set({ "n", "v" }, "<C-p>", ":FzfLua files<CR>", { desc = "[G]o to file" })
			vim.keymap.set({ "n", "v" }, "<leader>fc", ":FzfLua colorschemes<CR>", { desc = "[F]zf [C]olorschemes" })
			vim.keymap.set({ "n", "v" }, "<leader>fg", ":FzfLua live_grep<CR>", { desc = "[F]zf [G]rep" })
			require("fzf-lua").setup({})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				keymaps = {
					["<C-p>"] = false,
					["<C-e>"] = "actions.preview",
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open oil parent directory" })
		end,
	},
	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default settings
		submodules = false, -- not needed, submodules are required only for tests
	},
	{
		"Eandrju/cellular-automaton.nvim",
	},
	-- {
	--   "christoomey/vim-tmux-navigator",
	--   cmd = {
	--     "TmuxNavigateLeft",
	--     "TmuxNavigateDown",
	--     "TmuxNavigateUp",
	--     "TmuxNavigateRight",
	--     "TmuxNavigatePrevious",
	--   },
	--   keys = {
	--     { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
	--     { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
	--     { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
	--     { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
	--     { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	--   },
	-- },

	{
		"https://git.sr.ht/~swaits/zellij-nav.nvim",
		lazy = true,
		event = "VeryLazy",
		keys = {
			{ "<C-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
			{ "<C-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
			{ "<C-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
			{ "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
		},
		opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			-- local harpoonConfigFileFfs = require("plugins/harpoon")
			harpoon:setup({})

			-- harpoon:setup() -- called in plugins.lua
			-- REQUIRED

			vim.keymap.set({ "n", "v" }, "<leader>h", function()
				harpoon:list():add()
			end, { desc = "Add buffer to [H]arpoon list" })
			vim.keymap.set({ "n", "v" }, "<A-S-h>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Open [H]arpoon window" })

			vim.keymap.set("n", "<A-u>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<A-i>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<A-o>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<A-p>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<A-S-p>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<A-S-n>", function()
				harpoon:list():next()
			end)
			-- END OF ##### was in harpoon file

			-- basic telescope configuration
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
		end,
	},
	{
		"folke/zen-mode.nvim",
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"Wansmer/treesj",
		-- keys = { '<leader>rt', '<leader>rj', '<leader>rs' },
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({--[[ your config ]]
			})
			vim.keymap.set("n", "<leader>jt", ":TSJToggle<CR>", { desc = "[J]oin [T]oggle" })
			vim.keymap.set("n", "<leader>jj", ":TSJJoin<CR>", { desc = "[J]oin [J]oin" })
			vim.keymap.set("n", "<leader>js", ":TSJSplit<CR>", { desc = "[J]oin [S]plit" })
		end,
	},
	-- MINI
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup(
				--   {
				--     -- added <leader> before s to keep default s functionality
				--     mappings = {
				--       add = '<leader>sa',            -- Add surrounding in Normal and Visual modes
				--       delete = '<leader>sd',         -- Delete surrounding
				--       find = '<leader>sf',           -- Find surrounding (to the right)
				--       find_left = '<leader>sF',      -- Find surrounding (to the left)
				--       highlight = '<leader>sh',      -- Highlight surrounding
				--       replace = '<leader>sr',        -- Replace surrounding
				--       update_n_lines = '<leader>sn', -- Update `n_lines` - conflicts with <leader>s %s word replace
				--
				--       suffix_last = 'l',             -- Suffix to search with "prev" method
				--       suffix_next = 'n',             -- Suffix to search with "next" method
				--     },
				--   }
			)

			-- set use_icons to true if you have a Nerd Font
			-- local statusline = require 'mini.statusline'
			-- statusline.setup { use_icons = vim.g.have_nerd_font }
			--
			-- -- You can configure sections in the statusline by overriding their
			-- -- default behavior. For example, here we set the section for
			-- -- cursor location to LINE:COLUMN
			-- ---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			--   return '%2l:%-2v'
			-- end
			-- require("mini.statusline").setup()
			require("mini.pairs").setup()
			-- require("mini.jump2d").setup()
			-- require("mini.files").setup()
			-- require("mini.jump").setup()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				-- options = {
				--     icons_enabled = true,
				--     component_separators = ">>>>>"
				-- }
			})
		end,
	},
	-- {
	--   'smoka7/hop.nvim',
	--   version = "*",
	--   opts = {
	--     keys = 'etovxqpdygfblzhckisuran'
	--   }
	-- },
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*",
				css = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = true, -- "Name" codes like Blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes: foreground, background
					mode = "background", -- Set the display mode.
				}, -- Enable parsing rgb(...) functions in css.
				javascript = {
					RGB = true, -- #RGB hex codes
					RRGGBB = true, -- #RRGGBB hex codes
					names = true, -- "Name" codes like Blue
					RRGGBBAA = true, -- #RRGGBBAA hex codes
					rgb_fn = true, -- CSS rgb() and rgba() functions
					hsl_fn = true, -- CSS hsl() and hsla() functions
					css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
					css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
					-- Available modes: foreground, background
					mode = "background", -- Set the display mode.
				}, -- Enable parsing rgb(...) functions in css.
			})
		end,
	},
	{
		"wurli/visimatch.nvim",
		opts = {},
	},
	-- {
	-- 	"sontungexpt/better-diagnostic-virtual-text",
	-- 	"LspAttach",
	-- 	config = function(_)
	-- 		require("better-diagnostic-virtual-text").setup(opts)
	-- 	end,
	-- },
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
	    -- stylua: ignore
	    keys = {
	        { "<leader>/", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
	        { "<leader>v", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	        -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	        -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	        -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	    },
	},
	-- { -- REQUIRES v >= 0.10
	--     "m4xshen/hardtime.nvim",
	--     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	--     opts = {
	--         disable_mouse = false,
	--         max_count = 15,
	--     },
	-- },
	-- look into https://github.com/Shatur/neovim-tasks
	-- {
	-- 	{ "mistricky/codesnap.nvim", build = "make" },
	-- },
	-- {
	-- 	"ellisonleao/carbon-now.nvim",
	-- 	lazy = true,
	-- 	cmd = "CarbonNow",
	-- 	---@param opts cn.ConfigSchema
	-- 	opts = { [[ your custom config here ]] },
	-- },
})
-- local lspconfig = require("lspconfig")
-- lspconfig.clangd.setup({
-- 	-- 	cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
-- 	-- 	init_options = {
-- 	-- 		fallbackFlags = { "-std=c++17" },
-- 	-- 	},
-- })
-- lspconfig.opts = {
-- 	servers = {
-- 		clangd = {
-- 			mason = false,
-- 		},
-- 	},
-- }
