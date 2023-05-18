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

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        },
        config = function() require("config.lualine") end
    },

    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        },
        version = 'nightly',
        config = function() require("config.tree") end
    },

    {'rcarriga/nvim-notify', config = function() require("config.notify") end},

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = [[
                  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release &&
                    cmake --build build --config Release &&
                    cmake --install build --prefix build
                ]]
            },
            "nvim-lua/plenary.nvim"
        },
        config = function() require("config.telescope") end

    },
    "ahmedkhalf/project.nvim",
    'nvim-telescope/telescope-github.nvim',

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "glepnir/lspsaga.nvim",
                config = function() require("config.lspsaga") end

            },
            'simrat39/rust-tools.nvim',
            'ray-x/go.nvim', -- GoLang
            'ray-x/guihua.lua', -- recommended if need floating window support
            {
                "jose-elias-alvarez/null-ls.nvim",
                dependencies = {
                    "jose-elias-alvarez/typescript.nvim",
                    {
                        "ThePrimeagen/refactoring.nvim",
                        dependencies = {
                            {"nvim-lua/plenary.nvim"},
                            {"nvim-treesitter/nvim-treesitter"}
                        }
                    }
                },
                config = function()
                    require("config.null_ls.init")
                end
            },
            "nvim-treesitter/nvim-treesitter",
            "nvim-treesitter/playground"
        },
        config = function()
            require("config.lsp")
            require("config.rust_tools")
            require("config.treesitter")
        end
    },

    -- Auto Complete
    {
        'hrsh7th/nvim-cmp',
        dependencies = {

            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            {
                'saadparwaiz1/cmp_luasnip',
                config = function()
                    require("config.luasnip.init")
                end
            },
            "ray-x/lsp_signature.nvim",
            {
                "zbirenbaum/copilot.lua",
                dependencies = {"zbirenbaum/copilot-cmp"},
                config = function()
                    require("config.copilot_config")
                end

            },
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets" -- Treesitter
        },
        config = function() require("config.cmp") end
    },

    -- Auto close pairs
    {
        "windwp/nvim-autopairs",
        config = function() require("config.autopairs") end

    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup() end
    },

    -- Structural search and replace
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
    },

    -- 👑 TPOPE 👑
    "tpope/vim-surround", -- Surround objects
    "tpope/vim-abolish", -- Case Converter
    "tpope/vim-fugitive" -- Git
})

-- TODO: check out
-- "folke/which-key.nvim",
-- { "folke/neoconf.nvim", cmd = "Neoconf" },
-- "folke/neodev.nvim",