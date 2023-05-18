local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")
lazy.setup({
    -- Color Scheme
    {
        "folke/tokyonight.nvim",
        config = function() vim.cmd [[colorscheme tokyonight]] end
    },
    'kyazdani42/nvim-web-devicons',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        }
    },
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        },
        version = 'nightly' -- optional, updated every week. (see issue #1193)
    },
    'rcarriga/nvim-notify', -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
            "nvim-lua/plenary.nvim"
        }
    },
    "ahmedkhalf/project.nvim",
    'nvim-telescope/telescope-github.nvim',

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "glepnir/lspsaga.nvim",
            {
                "jose-elias-alvarez/null-ls.nvim",
                dependencies = {"jose-elias-alvarez/typescript.nvim"}
            },
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/playground"
        }
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    },
    'simrat39/rust-tools.nvim', -- GoLang
    'ray-x/go.nvim',
    'ray-x/guihua.lua', -- recommended if need floating window support

    -- Auto Complete
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    {"ray-x/lsp_signature.nvim"},
    {"zbirenbaum/copilot.lua"},
    {"zbirenbaum/copilot-cmp"}, -- Snippet engine
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets", -- Treesitter

    -- Auto close pairs
    "windwp/nvim-autopairs", -- Comments
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function() require"colorizer".setup() end
    },
    {
        "cshuaimin/ssr.nvim",
        config = function()
            require("ssr").setup {
                min_width = 50,
                min_height = 5,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_all = "<leader><cr>"
                }
            }
        end
    }, -- Structural search and replace
    -- 👑 TPOPE 👑
    "tpope/vim-surround", -- Surround objects
    "tpope/vim-abolish", -- Case Converter
    "tpope/vim-fugitive" -- Git
})

-- TODO: check out
-- "folke/which-key.nvim",
-- { "folke/neoconf.nvim", cmd = "Neoconf" },
-- "folke/neodev.nvim",
