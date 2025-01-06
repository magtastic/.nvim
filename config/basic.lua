vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.o.encoding = "utf8"
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.autoread = true
vim.o.swapfile = false
vim.o.wrap = false
vim.o.list = true

vim.api.nvim_command("set exrc")

-- Disable because I use nvim tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt_global.listchars = {
	trail = "·",
	tab = "▸ ",
	lead = "·",
	eol = "↲",
}

vim.api.nvim_set_option_value("colorcolumn", "120", { ctermbg = lightgrey, guibg = lightgrey })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "Podfile", "*.podspec" },
	command = "set filetype=ruby",
})

-- require('github-theme').setup()
