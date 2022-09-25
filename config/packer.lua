vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- Color Scheme
    use "folke/tokyonight.nvim"
    use 'projekt0n/github-nvim-theme'

    use 'kyazdani42/nvim-web-devicons'
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        }
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons' -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use 'rcarriga/nvim-notify'

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {{"nvim-lua/plenary.nvim"}}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use "ahmedkhalf/project.nvim"

    -- LSP
    use {
        "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig"
    }
    use "jason0x43/nvim-lsp-ts-utils"
    use "jose-elias-alvarez/null-ls.nvim"
    use "glepnir/lspsaga.nvim"

    -- Snippet engine
    use "L3MON4D3/LuaSnip"

    -- Auto Complete
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'

    -- Treesitter
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"

    -- Auto close pairs
    use "windwp/nvim-ts-autotag"
    use "windwp/nvim-autopairs"

    -- Comments
    use {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    }

    use {
        "norcalli/nvim-colorizer.lua",
        config = function() require"colorizer".setup() end
    }

    -- 👑 TPOPE 👑
    -- Surround objects
    use "tpope/vim-surround"

    -- Case Converter
    use "tpope/vim-abolish"

    -- Git
    use "tpope/vim-fugitive"

end)
