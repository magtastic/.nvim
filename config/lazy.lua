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
			require("config.conform")
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
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		-- your lsp config or other stuff
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			-- Not sure if this is good or not. Only showing on hover currently...
			require("tiny-inline-diagnostic").setup({
				options = {
					show_source = true,
					multiple_diag_under_cursor = true,
					multilines = true,
				},
			})
		end,
	},
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
