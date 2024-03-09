return function()
	local panel_key_leader = "<C-x>"
	local suggestions_key_leader = "<C-Space>"
	require("copilot").setup(
		{
			panel = {
				keymap = {
					jump_next = panel_key_leader .. "<C-n>",
					jump_prev = panel_key_leader .. "<C-p>",
					accept = panel_key_leader .. "<CR>",
					refresh = panel_key_leader .. "<C-r>",
					open = panel_key_leader .. "<C-o>",
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = suggestions_key_leader .. "<CR>",
					accept_word = false,
					accept_line = false,
					next = suggestions_key_leader .. "<C-n>",
					prev = suggestions_key_leader .. "<C-p>",
					dismiss = suggestions_key_leader .. "<esc>",
				},
			},
			filetypes = {
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node",
		}
	)
end
