return function()
  local lsp_zero = require("lsp-zero")

  lsp_zero.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps({
      buffer = bufnr,
      preserve_mappings = false
    })
  end)

  require("lazy-lsp").setup {
    excluded_servers = {
      "tabby_ml",
      "markdown_oxide",
      "pico8_ls",
      "css_variables",
      "delphi_ls"
    },
    prefer_local = false,
  }

end
