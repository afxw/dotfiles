local M = {}

M.on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "<leader>ft", api.tree.toggle, { silent = true })

    -- custom mappings
    -- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
    -- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

return M
