local swap_next, swap_prev = (function()
	local swap_objects = {
		p = "@parameter.inner",
		f = "@function.outer",
		c = "@class.outer",
	}

	local n, p = {}, {}
	for key, obj in pairs(swap_objects) do
		n[string.format("<leader>cx%s", key)] = obj
		p[string.format("<leader>cX%s", key)] = obj
	end

	return n, p
end)()

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"RRethy/nvim-treesitter-endwise",
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/playground",
		},
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			sync_install = false,
			ensure_installed = {
				"bash",
				"dockerfile",
				"html",
				"lua",
				"luadoc",
				"luap",
				"svelte",
				"tsx",
				"typescript",
				"javascript",
				"scss",
				"prisma",
				"css",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"latex",
				"vim",
				"yaml",
			},
			highlight = { enable = true, additional_vim_regex_highlighting = { "org", "markdown" } },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-j>",
					node_incremental = "<C-j>",
					scope_incremental = "<C-h>",
					node_decremental = "<C-k>",
				},
			},
			matchup = {
				enable = true,
			},
			endwise = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true,
			})
		end,
	},
}
