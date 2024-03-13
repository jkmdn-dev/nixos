return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      'l3mon4d3/luasnip',
      'saadparwaiz1/cmp_luasnip',

      -- adds lsp completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- to make copilot cmp work
      "zbirenbaum/copilot-cmp",
      "onsails/lspkind.nvim",

    -- nvim-lsp deps
    {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
    "dundalek/lazy-lsp.nvim",
  },
}
