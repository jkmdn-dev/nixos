local _configs = vim.api.nvim_get_runtime_file("lua/p/configs/*.lua", true)
local M = {}

-- arcane code, found ad :h vim.lpeg.Cs
local function gsub (s, patt, repl)
  local lpeg = vim.lpeg
  patt = lpeg.P(patt)
  patt = lpeg.Cs((patt / repl + 1)^0)
  return lpeg.match(patt, s)
end

for _, p in pairs(_configs) do
	if not vim.endswith(p, "init.lua") then
		local plist = vim.split(p, "/")
		local len = vim.tbl_count(plist)
		local fname = plist[len]
		local name = gsub(fname, '.lua', "")
		M[name] = require(vim.fs.joinpath("p", "configs", name))
	end
end

return M
