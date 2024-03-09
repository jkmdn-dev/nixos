return {
    -- autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- snippet engine & its associated nvim-cmp source
      'l3mon4d3/luasnip',
      'saadparwaiz1/cmp_luasnip',

      -- adds lsp completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      
      -- adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- to make copilot cmp work
      "zbirenbaum/copilot-cmp",
      "onsails/lspkind.nvim"
    },
}
