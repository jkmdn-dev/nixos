return function()
  vim.o.termguicolors = true
  require('rose-pine').setup({})
  vim.cmd("colorscheme rose-pine")
end
