local function bootstrap(author, plugin, ...)
	local path = (vim.fn.stdpath("data") .. "/lazy/" .. plugin)
	if not vim.loop.fs_stat(path) then
		local url = ("https://github.com/" .. author .. "/" .. plugin .. ".git")
		print("cloning", url, "to", path)
		vim.fn.system({ "git", "clone", url, path, "--filter=blob:none", ... })
	else
	end
	return (vim.opt.rtp):prepend(path)
end
bootstrap("folke", "lazy.nvim", "--branch=stable")
bootstrap("rktjmp", "hotpot.nvim")
local hotpot = require("hotpot")
hotpot.setup({
	provide_require_fennel = true,
	compiler = { modules = { correlate = true } },
	enable_hotpot_diagnostics = true
})
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
require("main")
