return function() 
    local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = { "lua", "rust", "c_sharp" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
    })
end
