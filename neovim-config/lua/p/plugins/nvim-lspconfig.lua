return {
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- nvim-lsp deps
    {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
    "dundalek/lazy-lsp.nvim",

		-- Completion plugin
		'hrsh7th/nvim-cmp',
	},
}
