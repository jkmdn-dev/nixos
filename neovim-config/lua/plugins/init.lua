local M = {}

local configs = require('p.configs')
local plugins = require('p.plugins')

M = vim.tbl_values(plugins)
local len = vim.tbl_count(M)
local keys = vim.tbl_keys(plugins)

for i = 1, len do
	M[i].config = configs[keys[i]]
end

return M
