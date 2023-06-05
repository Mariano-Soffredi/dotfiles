return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "go", "gomod" })
		end,
	},
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
		opts = {},
		config = function(_, opts)
			local utils = require("plugins.lsp.utils")

			require("go").setup({
				goimport = "goimports",
				gofmt = "gofumpt",
				max_line_len = 90,
				comment_placeholder = "",
				lsp_cfg = {
					capabilities = utils.capabilities(),
				},
				dap_debug = true,
				lsp_codelens = true,
				lsp_inlay_hints = {
					enable = false,
				},
			})

			-- Run gofmt + goimport on save
			local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.go",
				callback = function()
					require("go.format").gofmt()
					require("go.format").goimport()
				end,
				group = format_sync_grp,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		ft = { "go", "gomod" },
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							staticcheck = true,
							semanticTokens = true,
						},
					},
				},
				golangci_lint_ls = {
					default_config = {
						cmd = { "golangci-lint-langserver" },
						root_dir = function()
							return vim.loop.cwd()
						end,
						init_options = {
							command = {
								"golangci-lint",
								"run",
								"--enable-all",
								"--disable",
								"--allow-parallel-runners",
								"lll",
								"--out-format",
								"json",
							},
						},
					},
				},
			},
			setup = {
				gopls = function(_, opts)
					local lsp_utils = require("plugins.lsp.utils")
					lsp_utils.on_attach(function(client, buffer)
						if client.name == "gopls" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "GolangOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
							vim.keymap.set(
								"n",
								"<leader>cR",
								"GolangRenameFile",
								{ desc = "Rename File", buffer = buffer }
							)
						end
					end)
					return true
				end,
			},
		},
	},
}
