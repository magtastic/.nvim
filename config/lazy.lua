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
    -- Quick Fix
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function() require("config.bqf") end
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "theHamsta/nvim-dap-virtual-text",
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("nvim-dap-virtual-text").setup()
                end
            }
        }
    },
    -- Color Scheme
    {
        "folke/tokyonight.nvim",
        config = function() vim.cmd [[colorscheme tokyonight]] end
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function() require("config.lualine") end
    },

    {
        "kyazdani42/nvim-tree.lua",
        version = "nightly",
        config = function() require("config.tree") end
    },

    {"rcarriga/nvim-notify", config = function() require("config.notify") end},

    {
        "kyazdani42/nvim-web-devicons",
        config = function() require("nvim-web-devicons").setup() end
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-github.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                lazy = false
            },
            "ahmedkhalf/project.nvim"

        },
        config = function() require("config.telescope") end

    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/neodev.nvim",
                dependencies = {
                    "folke/neoconf.nvim",
                    cmd = "Neoconf",
                    config = function()
                        require("neoconf").setup({})
                    end
                },
                config = function() require("neodev").setup({}) end
            },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "glepnir/lspsaga.nvim",
                config = function() require("config.lspsaga") end,
                event = "LspAttach",
                dependencies = {
                    "kyazdani42/nvim-web-devicons",
                    -- Please make sure you install markdown and markdown_inline parser
                    "nvim-treesitter/nvim-treesitter"
                }

            },
            "simrat39/rust-tools.nvim",
            {
                "jose-elias-alvarez/null-ls.nvim",
                dependencies = {
                    {
                        "lewis6991/gitsigns.nvim",
                        config = function()
                            require("gitsigns").setup({
                                current_line_blame = true,
                                current_line_blame_opts = {
                                    virt_text = true,
                                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                                    delay = 2000,
                                    ignore_whitespace = false
                                },
                                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>"

                            })
                        end
                    },
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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind.nvim",
            "kyazdani42/nvim-web-devicons",
            {
                "saadparwaiz1/cmp_luasnip",
                config = function()
                    require("config.luasnip.init")
                end
            },
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

    {
        "ray-x/lsp_signature.nvim",
        config = function() require"lsp_signature".setup() end
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

    {
        "nvim-pack/nvim-spectre",
        config = function()
            require("spectre").setup()
            vim.keymap.set("n", "<leader>S",
                           "<cmd>lua require(\"spectre\").open()<CR>",
                           {desc = "Open Spectre"})
        end
    },

    -- 👑 TPOPE 👑
    "tpope/vim-surround", -- Surround objects
    "tpope/vim-abolish", -- Case Converter
    "tpope/vim-fugitive" -- Git
})
