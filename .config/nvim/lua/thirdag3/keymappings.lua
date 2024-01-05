vim.g.mapleader = " "

local opts = {
    noremap = true,
    silent = true
}

vim.keymap.set({"n", "v"}, "<leader>p", '"+p', opts)
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', opts)
