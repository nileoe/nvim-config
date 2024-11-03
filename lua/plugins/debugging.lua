return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- "leoluz/nvim-dap-go",
			-- "theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			require("dap-python").setup("python3")
			-- If using the above, then `python3 -m debugpy --version`
			-- must work in the shell
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>dg", dap.run_to_cursor)
			-- Eval variable under cursor
			vim.keymap.set("n", "<leader>?", function()
				require("dapui").eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F6>", dap.restart)

			-- dap.adapters.python = function(cb, config)
			-- 	if config.request == "attach" then
			-- 		---@diagnostic disable-next-line: undefined-field
			-- 		local port = (config.connect or config).port
			-- 		---@diagnostic disable-next-line: undefined-field
			-- 		local host = (config.connect or config).host or "127.0.0.1"
			-- 		cb({
			-- 			type = "server",
			-- 			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			-- 			host = host,
			-- 			options = {
			-- 				source_filetype = "python",
			-- 			},
			-- 		})
			-- 	else
			-- 		cb({
			-- 			type = "executable",
			-- 			command = "path/to/virtualenvs/debugpy/bin/python",
			-- 			args = { "-m", "debugpy.adapter" },
			-- 			options = {
			-- 				source_filetype = "python",
			-- 			},
			-- 		})
			-- 	end
			-- end

			-- dap.configurations.python = {
			-- 	{
			-- 		type = "python",
			-- 		request = "launch",
			-- 		name = "Launch file",
			-- 		program = "${file}",
			-- 		pythonPath = function()
			-- 			return "/etc/profiles/per-user/nileoe/bin/python3"
			-- 		end,
			-- 	},
			-- }
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}
