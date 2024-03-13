local _plugins = vim.api.nvim_get_runtime_file("lua/p/plugins/*.lua", true)
local M = {}

-- arcane code, found ad :h vim.lpeg.Cs
local function gsub (s, patt, repl)
  local lpeg = vim.lpeg
  patt = lpeg.P(patt)
  patt = lpeg.Cs((patt / repl + 1)^0)
  return lpeg.match(patt, s)
end

for _, p in pairs(_plugins) do
	if not vim.endswith(p, "init.lua") then
		local plist = vim.split(p, "/")
		local len = vim.tbl_count(plist)
		local fname = plist[len]
		local name = gsub(fname, '.lua', "")
		M[name] = require(vim.fs.joinpath("p", "plugins", name))
	end
end

return M
