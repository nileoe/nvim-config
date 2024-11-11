require("options")
require("plugins/plugins")
require("keymaps")

vim.cmd.colorscheme("tokyobones")

local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
	cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
})
lspconfig.opts = {
	servers = {
		clangd = {
			mason = false,
		},
	},
}
