local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
lazy.setup({
	-- Quick Fix

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("config.bqf")
		end,
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		config = function()
			require("ts-error-translator").setup()
		end,
	},
	-- Color Scheme
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("config.lualine")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		config = function()
			require("config.tree")
		end,
	},

	-- {
	-- 	"rcarriga/nvim-notify",
	-- 	config = function()
	-- 		vim.notify = require("notify")
	-- 	end,
	-- },

	{
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	}, -- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-github.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				lazy = false,
			},
			"ahmedkhalf/project.nvim",
		},
		config = function()
			require("config.telescope")
		end,
	}, -- LSP
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").formatters.ruff_format = {
				prepend_args = function(self, ctx)
					local root_dir = require("conform.util").root_file(".git")(self, ctx)

					-- Check if in smitten project. use linter config there
					if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
						return { "--config", root_dir .. "/linters/ruff.toml" }
					end

					return {}
				end,
			}

			require("conform").formatters.ruff_fix = {
				prepend_args = function(self, ctx)
					local root_dir = require("conform.util").root_file(".git")(self, ctx)

					-- Check if in smitten project. use linter config there
					if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
						return { "--config", root_dir .. "/linters/ruff.toml" }
					end

					return {}
				end,
			}

			require("conform").formatters.ruff_organize_imports = {
				prepend_args = function(self, ctx)
					local root_dir = require("conform.util").root_file(".git")(self, ctx)

					-- Check if in smitten project. use linter config there
					if root_dir ~= nil and root_dir:sub(-#"Smitten/smitten") == "Smitten/smitten" then
						return { "--config", root_dir .. "/linters/ruff.toml" }
					end

					return {}
				end,
			}

			require("conform").setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					javascript = { "biome-check" },
					typescript = { "biome-check" },
					javascriptreact = { "biome-check" },
					typescriptreact = { "biome-check" },
					python = { "ruff_format", "ruff_organize_imports", "ruff_fix" },
					json = { "biome-check" },
					lua = { "stylua" },
				},
			})
		end,
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
	},
	--   {
	--   "mfussenegger/nvim-lint",
	--   event = {
	--     "BufReadPre",
	--     "BufNewFile",
	--   },
	--   config = function()
	--     local lint = require("lint")
	--
	--     lint.linters_by_ft = {
	--       javascript = { "eslint_d" },
	--       typescript = { "eslint_d" },
	--       javascriptreact = { "eslint_d" },
	--       typescriptreact = { "eslint_d" },
	--       lua = { "luac" },
	--       svelte = { "eslint_d" },
	--       python = { "pylint" },
	--       go = { "golangcilint" },
	--     }
	--
	--     local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	--
	--     vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	--       group = lint_augroup,
	--       callback = function()
	--         lint.try_lint()
	--       end,
	--     })
	--   end,
	-- },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				vim.env.VIMRUNTIME,
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
		config = function()
			require("neoconf").setup({})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"nvimdev/lspsaga.nvim",
				config = function()
					require("config.lspsaga")
				end,
				event = "LspAttach",
				dependencies = {
					"kyazdani42/nvim-web-devicons",
					-- Please make sure you install markdown and markdown_inline parser
					"nvim-treesitter/nvim-treesitter",
				},
			},
			{
				"lewis6991/gitsigns.nvim",
				config = function()
					require("gitsigns").setup({
						current_line_blame = true,
						current_line_blame_opts = {
							virt_text = true,
							virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
							delay = 2000,
							ignore_whitespace = false,
						},
						current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
					})
				end,
			},
			"jose-elias-alvarez/typescript.nvim",
			"simrat39/rust-tools.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/playground",
		},
		config = function()
			require("config.lsp")
			require("config.rust_tools")
			require("config.treesitter")
		end,
	}, -- Auto Complete
	"github/copilot.vim",
	"L3MON4D3/LuaSnip",
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"kyazdani42/nvim-web-devicons",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets", -- Treesitter
		},
		config = function()
			require("config.cmp")
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup()
		end,
	}, -- Auto close pairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("config.autopairs")
		end,
	}, -- Comments
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	}, -- Structural search and replace
	{
		"cshuaimin/ssr.nvim",
		config = function()
			require("ssr").setup()
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		config = function()
			require("spectre").setup()
			vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', { desc = "Open Spectre" })
		end,
	}, -- 👑 TPOPE 👑
	"tpope/vim-surround", -- Surround objects
	"tpope/vim-abolish", -- Case Converter
	"tpope/vim-fugitive", -- Git
})
