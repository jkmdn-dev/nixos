return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
		commit = "a05979b623b5017043c20e17ba949fb279d0eb60",
	},
	build = ':TSUpdate',
}
