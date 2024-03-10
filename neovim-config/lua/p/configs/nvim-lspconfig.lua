return function()
  local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
  local lsp_format_on_save = function(bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end

  local lsp_zero = require("lsp-zero")

  lsp_zero.on_attach(function(_, bufnr)
    lsp_format_on_save(bufnr)
    lsp_zero.default_keymaps({
      buffer = bufnr,
      preserve_mappings = false
    })
  end)

  local cmp = require("cmp")
  local cmp_format = lsp_zero.cmp_format({ details = true })
  local cmp_action = lsp_zero.cmp_action()


  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup {
    preselect = 'item',
    completion = {
      completeopt = 'menu,menuone,noinsert'
    },
    sources = {
      { name = 'path' },
      { name = 'nvim_lsp' },
      { name = 'luasnip', keyword_length = 2 },
      { name = 'buffer',  keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-n>'] = cmp_action.luasnip_jump_forward(),
      ['<C-p>'] = cmp_action.luasnip_jump_backward(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = cmp_format,
  }

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
